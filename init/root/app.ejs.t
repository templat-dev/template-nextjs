---
to: <%= rootDirectory %>/app.yaml
force: true
---
runtime: nodejs18
<%_ if (applicationType === 'console') { -%>
service: console
<%_ } -%>

instance_class: F2

handlers:
  - url: /_next/static
    static_dir: .next/static
  - url: /(.*\.(gif|png|jpg|ico|txt|svg))$
    static_files: public/\1
    upload: public/.*\.(gif|png|jpg|ico|txt|svg)$
  - url: /.*
    script: auto
    secure: always

env_variables:
  HOST: '0.0.0.0'
  NODE_ENV: 'prod'
