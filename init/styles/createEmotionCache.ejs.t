---
to: <%= rootDirectory %>/<%= projectName %>/styles/createEmotionCache.ts
force: true
---
import createCache, { EmotionCache } from "@emotion/cache";

export default function createEmotionCache(): EmotionCache {
  return createCache({ key: "css" });
}