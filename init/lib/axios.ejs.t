---
to: <%= rootDirectory %>/lib/axios.ts
force: true
---
'use client';

import globalAxios from 'axios';

// axiosにBASE_PATHを設定
if (process?.env?.NEXT_PUBLIC_API_BASE_PATH) {
  globalAxios.defaults.baseURL = process.env.NEXT_PUBLIC_API_BASE_PATH;
}

export default globalAxios; 