---
to: <%= rootDirectory %>/styles/createEmotionCache.ts
force: true
---
'use client';

import createCache from '@emotion/cache';

export default function createEmotionCache() {
  return createCache({ key: 'css', prepend: true });
}