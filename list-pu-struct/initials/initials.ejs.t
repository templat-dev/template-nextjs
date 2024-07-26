---
to: <%= rootDirectory %>/initials/<%= struct.name.pascalName %>Initials.ts
---
import {Model<%= struct.name.pascalName %>} from '~/apis'
<%_ const importInitialsSet = new Set() -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct') { -%>
    <%_ if (!importInitialsSet.has(field.structName.pascalName)) { -%>
import {INITIAL_<%= field.structName.upperSnakeName %>} from '~/initials/<%= field.structName.pascalName %>Initials'
      <%_ importInitialsSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (field.editType === 'struct') { -%>
    <%_ if (!importInitialsSet.has(field.structName.pascalName)) { -%>
import {INITIAL_<%= field.structName.upperSnakeName %>} from '~/initials/<%= field.structName.pascalName %>Initials'
      <%_ importInitialsSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>

export const INITIAL_<%= struct.name.upperSnakeName %>: Model<%= struct.name.pascalName %> = {
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
  <%= field.name.lowerCamelName %>: INITIAL_<%= field.structName.upperSnakeName %>,
  <%_ } -%>
  <%_ if (field.editType.startsWith('array')) { -%>
  <%= field.name.lowerCamelName %>: [],
  <%_ } -%>
  <%_ if (field.validateTags && field.validateTags.includes('required')) { -%>
    <%_ if (field.editType === 'string' || field.editType === 'textarea' || field.editType === 'image' || field.editType === 'time' || field.editType === 'relation') { -%>
  <%= field.name.lowerCamelName %>: "",
    <%_ } else if (field.editType === 'number' || field.editType === 'segment') { -%>
  <%= field.name.lowerCamelName %>: 0,
    <%_ } else if (field.editType === 'bool') { -%>
  <%= field.name.lowerCamelName %>: false,
    <%_ } -%>
  <%_ } else { -%>
    <%_ if (field.editType === 'string' || field.editType === 'textarea' || field.editType === 'image' || field.editType === 'number' || field.editType === 'bool' || field.editType === 'time' || field.editType === 'segment' || field.editType === 'relation') { -%>
  <%= field.name.lowerCamelName %>: undefined,
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>
}
