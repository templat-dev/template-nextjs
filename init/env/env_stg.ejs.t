---
to: <%= rootDirectory %>/<%= projectName %>/env/.env.stg
force: true
---
NEXT_PUBLIC_API_BASE_PATH=<%= entity.apiSchemeSTG %>://<%= entity.apiHostSTG %><%= entity.apiBasePathSTG %>
