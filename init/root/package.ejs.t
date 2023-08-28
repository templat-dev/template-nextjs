---
to: <%= rootDirectory %>/package.json
force: true
---
{
  "name": "<%= project.name %>",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "dev:dev": "sh ./env.sh dev local && next dev",
    "dev:stg": "sh ./env.sh stg local && next dev",
    "dev:prod": "sh ./env.sh prod local && next dev",
    "build": "next build",
    "build:dev": "sh ./env.sh dev production && next build",
    "build:stg": "sh ./env.sh stg production && next build",
    "build:prod": "sh ./env.sh prod production && next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "@emotion/cache": "^11.11.0",
    "@emotion/react": "^11.11.0",
    "@emotion/server": "^11.11.0",
    "@emotion/styled": "^11.11.0",
    "@mui/icons-material": "^5.14.6",
    "@mui/material": "^5.14.6",
    "@mui/x-data-grid": "^6.12.0",
    "@mui/x-date-pickers": "^6.12.0",
    "axios": "^0.27.2",
    "date-fns": "^2.30.0",
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
    "firebase": "^10.3.0",
    "firebaseui": "^6.1.0",
<%_ } -%>
    "lodash-es": "^4.17.21",
    "next": "13.4.19",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "react-responsive-carousel": "^3.2.23",
    "recoil": "^0.7.7"
  },
  "devDependencies": {
    "@emotion/babel-plugin": "^11.3.0",
    "@openapitools/openapi-generator-cli": "^1.0.18-5.0.0-beta2",
    "@types/lodash-es": "^4.17.8",
    "@types/node": "20.5.7",
    "@types/react": "^18.2.21",
    "@types/react-dom": "^18.2.7",
    "typescript": "5.2.2"
  },
  "resolutions": {
    "**/@types/react": "^18.2.21",
    "**/@types/react-dom": "^18.2.7"
  }
}
