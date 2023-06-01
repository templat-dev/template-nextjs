---
to: <%= rootDirectory %>/<%= projectName %>/env.sh
force: true
---
#!/bin/bash
cd $(dirname $0)
APP_ENV=$1
cp ./env/.env.$APP_ENV .env.$2