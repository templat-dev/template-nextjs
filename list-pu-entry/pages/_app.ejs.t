---
to: <%= rootDirectory %>/<%= project.name %>/pages/_app.tsx
inject: true
skip_if: // メニュー <%= struct.name.lowerCamelName %>
after: // メニュー
---
  // メニュー <%= struct.name.lowerCamelName %>
  {
    title: '<%= struct.screenLabel || struct.name.pascalName %>',
    to: `/<%= struct.name.lowerCamelName %>`
  },