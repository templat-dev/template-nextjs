---
to: <%= rootDirectory %>/initials/<%= struct.name.pascalName %>Initials.ts
---
import {Writable} from 'type-fest'
import {Model<%= struct.name.pascalName %>, <%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request} from '~/apis'
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
<%_ const searchConditions = [] -%>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if ((field.dataType === 'string' || field.dataType === 'array-string' || field.dataType === 'time' || field.dataType === 'array-time') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: false, required: field.searchValidateTags && field.searchValidateTags.includes('required')}) -%>
  <%_ } -%>
  <%_ if (field.dataType === 'relation' && field.dataType === 'string' && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: false, required: field.searchValidateTags && field.searchValidateTags.includes('required')}) -%>
  <%_ } -%>
  <%_ if ((field.dataType === 'bool' || field.dataType === 'array-bool') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'boolean', range: false, required: field.searchValidateTags && field.searchValidateTags.includes('required')}) -%>
  <%_ } -%>
  <%_ if ((field.dataType === 'number' || field.dataType === 'array-number' || field.dataType === 'segment') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: false, required: field.searchValidateTags && field.searchValidateTags.includes('required')}) -%>
  <%_ } -%>
  <%_ if (field.dataType === 'relation' && field.dataType === 'number' && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: false, required: field.searchValidateTags && field.searchValidateTags.includes('required')}) -%>
  <%_ } -%>
  <%_ if ((field.dataType === 'number' || field.dataType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: true, required: field.searchValidateTags && field.searchValidateTags.includes('required')}) -%>
  <%_ } -%>
  <%_ if ((field.dataType === 'time' || field.dataType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: true, required: field.searchValidateTags && field.searchValidateTags.includes('required')}) -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request> = {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: <% if (searchCondition.required) { -%>''<%_ } else { -%>undefined<%_ } -%>,
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: <% if (searchCondition.required) { -%>false<%_ } else { -%>undefined<%_ } -%>,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: <% if (searchCondition.required) { -%>0<%_ } else { -%>undefined<%_ } -%>,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>: <% if (searchCondition.required) { -%>0<%_ } else { -%>undefined<%_ } -%>,
  <%= searchCondition.name %>From: <% if (searchCondition.required) { -%>0<%_ } else { -%>undefined<%_ } -%>,
  <%= searchCondition.name %>To: <% if (searchCondition.required) { -%>0<%_ } else { -%>undefined<%_ } -%>,
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>: <% if (searchCondition.required) { -%>''<%_ } else { -%>undefined<%_ } -%>,
  <%= searchCondition.name %>From: <% if (searchCondition.required) { -%>''<%_ } else { -%>undefined<%_ } -%>,
  <%= searchCondition.name %>To: <% if (searchCondition.required) { -%>''<%_ } else { -%>undefined<%_ } -%>,
    <%_ } -%>
  <%_ }) -%>
}

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
  <%= field.name.lowerCamelName %>: '',
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
