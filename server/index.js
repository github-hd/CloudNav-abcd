import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';
import KVStorage from './kv-storage.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;
const PASSWORD = process.env.PASSWORD || '';

// 初始化 KV 存储
const kvStorage = new KVStorage(process.env.CLOUDNAV_KV_PATH || './data');
await kvStorage.init();

// 中间件
app.use(cors());
app.use(express.json());

// 统一的响应头
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, x-auth-password',
};

// API 路由 - Storage
app.get('/api/storage', async (req, res) => {
  try {
    const { checkAuth, getConfig, domain } = req.query;
    
    // 检查认证
    if (checkAuth === 'true') {
      return res.json({
        hasPassword: !!PASSWORD,
        requiresAuth: !!PASSWORD
      });
    }
    
    // 获取配置
    if (getConfig === 'ai') {
      const aiConfig = await kvStorage.get('ai_config');
      return res.json(aiConfig ? JSON.parse(aiConfig) : {});
    }
    
    if (getConfig === 'search') {
      const searchConfig = await kvStorage.get('search_config');
      return res.json(searchConfig ? JSON.parse(searchConfig) : {});
    }
    
    if (getConfig === 'website') {
      const websiteConfig = await kvStorage.get('website_config');
      return res.json(websiteConfig ? JSON.parse(websiteConfig) : { passwordExpiry: { value: 1, unit: 'week' } });
    }
    
    if (getConfig === 'favicon') {
      if (!domain) {
        return res.status(400).json({ error: 'Domain parameter is required' });
      }
      
      const cachedIcon = await kvStorage.get(`favicon:${domain}`);
      if (cachedIcon) {
        return res.json({ icon: cachedIcon, cached: true });
      }
      
      return res.json({ icon: null, cached: false });
    }
    
    // 获取应用数据
    const data = await kvStorage.get('app_data');
    
    if (req.query.getConfig === 'true') {
      const password = req.headers['x-auth-password'];
      if (!password || password !== PASSWORD) {
        return res.status(401).json({ error: '密码错误' });
      }
      
      // 检查密码是否过期
      const websiteConfigStr = await kvStorage.get('website_config');
      const websiteConfig = websiteConfigStr ? JSON.parse(websiteConfigStr) : { passwordExpiry: { value: 1, unit: 'week' } };
      const passwordExpiry = websiteConfig.passwordExpiry || { value: 1, unit: 'week' };
      
      if (passwordExpiry.unit !== 'permanent') {
        const lastAuthTime = await kvStorage.get('last_auth_time');
        if (lastAuthTime) {
          const lastTime = parseInt(lastAuthTime);
          const now = Date.now();
          let expiryMs = 0;
          
          switch (passwordExpiry.unit) {
            case 'day':
              expiryMs = passwordExpiry.value * 24 * 60 * 60 * 1000;
              break;
            case 'week':
              expiryMs = passwordExpiry.value * 7 * 24 * 60 * 60 * 1000;
              break;
            case 'month':
              expiryMs = passwordExpiry.value * 30 * 24 * 60 * 60 * 1000;
              break;
            case 'year':
              expiryMs = passwordExpiry.value * 365 * 24 * 60 * 60 * 1000;
              break;
          }
          
          if (now - lastTime > expiryMs) {
            return res.status(401).json({ error: '密码已过期，请重新输入' });
          }
        }
      }
      
      await kvStorage.put('last_auth_time', Date.now().toString());
    }
    
    if (!data) {
      return res.json({ links: [], categories: [] });
    }
    
    res.json(JSON.parse(data));
  } catch (error) {
    console.error('Storage GET error:', error);
    res.status(500).json({ error: 'Failed to fetch data' });
  }
});

app.post('/api/storage', async (req, res) => {
  try {
    const providedPassword = req.headers['x-auth-password'];
    const body = req.body;
    
    // 仅验证密码
    if (body.authOnly) {
      if (!PASSWORD) {
        return res.status(500).json({ error: 'Server misconfigured: PASSWORD not set' });
      }
      
      if (providedPassword !== PASSWORD) {
        return res.status(401).json({ error: 'Unauthorized' });
      }
      
      await kvStorage.put('last_auth_time', Date.now().toString());
      return res.json({ success: true });
    }
    
    // 保存搜索配置
    if (body.saveConfig === 'search') {
      if (PASSWORD && (!providedPassword || providedPassword !== PASSWORD)) {
        return res.status(401).json({ error: 'Unauthorized' });
      }
      
      await kvStorage.put('search_config', JSON.stringify(body.config));
      return res.json({ success: true });
    }
    
    // 保存图标
    if (body.saveConfig === 'favicon') {
      const { domain, icon } = body;
      if (!domain || !icon) {
        return res.status(400).json({ error: 'Domain and icon are required' });
      }
      
      await kvStorage.put(`favicon:${domain}`, icon, { expirationTtl: 30 * 24 * 60 * 60 });
      return res.json({ success: true });
    }
    
    // 其他操作需要密码
    if (PASSWORD) {
      if (!providedPassword || providedPassword !== PASSWORD) {
        return res.status(401).json({ error: 'Unauthorized' });
      }
    } else {
      return res.status(500).json({ error: 'Server misconfigured: PASSWORD not set' });
    }
    
    // 保存 AI 配置
    if (body.saveConfig === 'ai') {
      await kvStorage.put('ai_config', JSON.stringify(body.config));
      return res.json({ success: true });
    }
    
    // 保存网站配置
    if (body.saveConfig === 'website') {
      await kvStorage.put('website_config', JSON.stringify(body.config));
      return res.json({ success: true });
    }
    
    // 保存应用数据
    await kvStorage.put('app_data', JSON.stringify(body));
    res.json({ success: true });
  } catch (error) {
    console.error('Storage POST error:', error);
    res.status(500).json({ error: 'Failed to save data' });
  }
});

// API 路由 - Link
app.post('/api/link', async (req, res) => {
  try {
    const providedPassword = req.headers['x-auth-password'];
    
    if (!PASSWORD) {
      return res.status(500).json({ error: 'Server misconfigured: PASSWORD not set' });
    }
    
    if (!providedPassword || providedPassword !== PASSWORD) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
    
    const currentDataStr = await kvStorage.get('app_data');
    let currentData = { links: [], categories: [] };
    
    if (currentDataStr) {
      currentData = JSON.parse(currentDataStr);
    }
    
    const newLink = req.body;
    currentData.links = [newLink, ...(currentData.links || [])];
    
    await kvStorage.put('app_data', JSON.stringify(currentData));
    
    res.json({ success: true, link: newLink });
  } catch (error) {
    console.error('Link POST error:', error);
    res.status(500).json({ error: 'Failed to add link' });
  }
});

// 静态文件服务
app.use(express.static(path.join(__dirname, '../dist')));

// SPA 路由处理
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../dist/index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`CloudNav server running on port ${PORT}`);
  console.log(`Password protection: ${PASSWORD ? 'Enabled' : 'Disabled'}`);
});
