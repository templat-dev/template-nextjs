---
to: <%= rootDirectory %>/cloudbuild.yaml
force: true
---
steps:
  - id: yarn-install
    name: node:18
    entrypoint: yarn
    args: ['install']
  - id: build
    name: node:18
    entrypoint: yarn
    args: ['build:prod']
  - id: deploy
    name: gcr.io/cloud-builders/gcloud
    args:
      - app
      - deploy
      - app.yaml
      - --quiet
timeout: 900s

