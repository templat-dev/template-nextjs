---
to: <%= rootDirectory %>/<%= projectName %>/cloudbuild_stg.yaml
force: true
---
steps:
  - id: yarn-install
    name: node:14
    entrypoint: yarn
    args: ['install']
  - id: build
    name: node:14
    entrypoint: yarn
    args: ['build:stg']
  - id: deploy
    name: gcr.io/cloud-builders/gcloud
    args:
      - app
      - deploy
      - app_stg.yaml
      - --quiet
timeout: 900s

