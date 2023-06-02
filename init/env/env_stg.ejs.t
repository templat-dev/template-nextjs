---
to: <%= rootDirectory %>/<%= project.name %>/env/.env.stg
force: true
---
NEXT_PUBLIC_API_BASE_PATH=<%= struct.apiSchemeSTG %>://<%= struct.apiHostSTG %><%= struct.apiBasePathSTG %>
