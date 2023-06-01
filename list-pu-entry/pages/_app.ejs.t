---
to: <%= rootDirectory %>/<%= projectName %>/pages/_app.tsx
inject: true
skip_if: // メニュー <%= entity.name %>
after: // メニュー
---
  // メニュー <%= entity.name %>
  {
    title: '<%= entity.screenLabel || h.changeCase.pascal(entity.name) %>',
    to: `/<%= entity.name %>`
  },