---
to: <%= rootDirectory %>/package.json
force: true
---
{
  "name": "<%= project.name %>",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "dev:dev": "sh ./env.sh dev development && next dev",
    "dev:stg": "sh ./env.sh stg development && next dev",
    "dev:prod": "sh ./env.sh prod development && next dev",
    "build": "next build",
    "build:dev": "sh ./env.sh dev production && next build",
    "build:stg": "sh ./env.sh stg production && next build",
    "build:prod": "sh ./env.sh prod production && next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "@date-io/date-fns": "^2.11.0",
    "@emotion/cache": "^11.5.0",
    "@emotion/react": "^11.5.0",
    "@emotion/server": "^11.4.0",
    "@emotion/styled": "^11.3.0",
    "@mui/icons-material": "^5.1.0",
    "@mui/lab": "^5.0.0-alpha.54",
    "@mui/material": "^5.1.0",
    "@mui/x-data-grid": "^6.6.0",
    "axios": "^0.24.0",
    "date-fns": "^2.25.0",
    "firebase": "^9.6.4",
    "lodash-es": "^4.17.21",
    "next": "12.1.6",
    "react": "18.1.0",
    "react-dom": "18.1.0",
    "react-firebaseui": "^6.0.0",
    "react-responsive-carousel": "^3.2.22",
    "recoil": "^0.7.1"
  },
  "devDependencies": {
    "@emotion/babel-plugin": "^11.3.0",
    "@types/lodash-es": "^4.17.5",
    "@types/node": "17.0.41",
    "@types/react": "^18.0.10",
    "@types/react-dom": "^18.0.5",
    "eslint": "7",
    "eslint-config-next": "12.0.3",
    "typescript": "4.4.4"
  },
  "resolutions": {
    "**/@types/react": "^18.0.10",
    "**/@types/react-dom": "^18.0.5"
  }
}
