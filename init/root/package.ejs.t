---
to: <%= rootDirectory %>/package.json
force: true
---
{
  "name": "<%= project.name %>",
  "private": true,
  "scripts": {
    "openapi": "npx -y @openapitools/openapi-generator-cli@^2.13.4 generate --generator-key default",
    "dev:dev": "sh ./env.sh dev && next dev",
    "dev:stg": "sh ./env.sh stg && next dev",
    "dev:prod": "sh ./env.sh prod && next dev",
    "build:dev": "sh ./env.sh dev && next build",
    "build:stg": "sh ./env.sh stg && next build",
    "build:prod": "sh ./env.sh prod && next build",
    "start": "next start"
  },
  "dependencies": {
    "@emotion/cache": "^11.11.0",
    "@emotion/react": "^11.11.0",
    "@emotion/server": "^11.11.0",
    "@emotion/styled": "^11.11.0",
    "@hookform/resolvers": "^3.3.1",
    "@mui/icons-material": "^5.14.6",
    "@mui/material": "^5.14.6",
    "@mui/x-data-grid": "^6.12.0",
    "@mui/x-date-pickers": "^6.12.0",
    "axios": "^1.7.2",
    "dayjs": "^1.11.12",
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
    "firebase": "^10.3.0",
    "firebaseui": "^6.1.0",
<%_ } -%>
    "jotai": "^2.9.1",
    "lodash-es": "^4.17.21",
    "next": "13.4.19",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "react-hook-form": "^7.45.4",
    "react-responsive-carousel": "^3.2.23",
    "yup": "^1.2.0"
  },
  "devDependencies": {
    "@emotion/babel-plugin": "^11.3.0",
    "@openapitools/openapi-generator-cli": "^2.13.4",
    "@types/lodash-es": "^4.17.8",
    "@types/node": "20.5.7",
    "@types/react": "^18.2.21",
    "@types/react-dom": "^18.2.7",
    "type-fest": "^4.23.0",
    "typescript": "5.2.2"
  },
  "resolutions": {
    "**/@types/react": "^18.2.21",
    "**/@types/react-dom": "^18.2.7"
  }
}
