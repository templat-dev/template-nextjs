---
to: <%= rootDirectory %>/<%= project.name %>/pages/_app.tsx
inject: true
skip_if: // メニュー <%= struct.name %>
after: // メニュー
---
  // メニュー <%= struct.name %>
  {
    title: '<%= struct.screenLabel || h.changeCase.pascal(struct.name) %>',
    to: `/<%= struct.name %>`
  },