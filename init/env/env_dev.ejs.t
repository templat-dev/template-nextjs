---
to: <%= rootDirectory %>/<%= projectName %>/env/.env.dev
force: true
---
NEXT_PUBLIC_API_BASE_PATH=http://localhost:5000<%= entity.apiBasePath %>
