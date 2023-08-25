---
to: <%= rootDirectory %>/swagger.sh
force: true
---
#!/usr/bin/env bash
# swagger.yamlのtype: objectとexample: xxxを削除
sed -i '' 's|          type: object||g; s|example:.*||g' apis/swagger.yaml

npx openapi-generator generate -i apis/swagger.yaml -o apis -g typescript-axios --additional-properties=useSingleRequestParameter=true

# base.tsのBASE_PATHを置換
sed -i '' 's|export const BASE_PATH = "http://localhost/api/v1".replace(/\\/+$/, "");|let basePath = '\'''\''\nif (process \&\& process.env \&\& process.env.NEXT_PUBLIC_API_BASE_PATH) {\n    basePath = process.env.NEXT_PUBLIC_API_BASE_PATH\n}\nexport const BASE_PATH = basePath.replace(/\\/+$/, "");|' apis/base.ts