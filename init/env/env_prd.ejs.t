---
to: <%= rootDirectory %>/<%= project.name %>/env/.env.prod
force: true
---
NEXT_PUBLIC_API_BASE_PATH=<%= struct.apiScheme %>://<%= struct.apiHost %><%= struct.apiBasePath %>
