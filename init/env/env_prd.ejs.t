---
to: <%= rootDirectory %>/<%= projectName %>/env/.env.prod
force: true
---
NEXT_PUBLIC_API_BASE_PATH=<%= entity.apiScheme %>://<%= entity.apiHost %><%= entity.apiBasePath %>
