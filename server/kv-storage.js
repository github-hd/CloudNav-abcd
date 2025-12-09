import fs from 'fs/promises';
import path from 'path';

class KVStorage {
  constructor(dataPath = './data') {
    this.dataPath = dataPath;
    this.kvFile = path.join(dataPath, 'kv.json');
  }

  async init() {
    try {
      await fs.mkdir(this.dataPath, { recursive: true });
      try {
        await fs.access(this.kvFile);
      } catch {
        await fs.writeFile(this.kvFile, JSON.stringify({}));
      }
    } catch (error) {
      console.error('Failed to initialize KV storage:', error);
    }
  }

  async get(key) {
    try {
      const data = await fs.readFile(this.kvFile, 'utf-8');
      const kv = JSON.parse(data);
      const item = kv[key];
      
      if (!item) return null;
      
      // 检查是否过期
      if (item.expiresAt && Date.now() > item.expiresAt) {
        await this.delete(key);
        return null;
      }
      
      return item.value;
    } catch (error) {
      console.error('Failed to get from KV:', error);
      return null;
    }
  }

  async put(key, value, options = {}) {
    try {
      const data = await fs.readFile(this.kvFile, 'utf-8');
      const kv = JSON.parse(data);
      
      const item = { value };
      
      // 处理过期时间
      if (options.expirationTtl) {
        item.expiresAt = Date.now() + options.expirationTtl * 1000;
      }
      
      kv[key] = item;
      
      await fs.writeFile(this.kvFile, JSON.stringify(kv, null, 2));
    } catch (error) {
      console.error('Failed to put to KV:', error);
      throw error;
    }
  }

  async delete(key) {
    try {
      const data = await fs.readFile(this.kvFile, 'utf-8');
      const kv = JSON.parse(data);
      delete kv[key];
      await fs.writeFile(this.kvFile, JSON.stringify(kv, null, 2));
    } catch (error) {
      console.error('Failed to delete from KV:', error);
    }
  }
}

export default KVStorage;
