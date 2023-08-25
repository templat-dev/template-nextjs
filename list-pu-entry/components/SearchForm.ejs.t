---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.tsx
---
import * as React from 'react'
import {useCallback, useEffect, useState} from 'react'
import {cloneDeep} from 'lodash-es'
<%_ if (struct.exists.search.time || struct.exists.search.arrayTime) { -%>
import {formatISO} from 'date-fns'
<%_ } -%>
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
<%_ if (struct.exists.search.bool || struct.exists.search.arrayBool) { -%>
  FormControlLabel,
<%_ } -%>
  Grid,
<%_ if (struct.exists.search.bool || struct.exists.search.arrayBool) { -%>
  Switch,
<%_ } -%>
  TextField
} from '@mui/material'
<%_ if (struct.exists.search.time || struct.exists.search.arrayTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm'
<%_ } -%>

<%_ const searchConditions = [] -%>
<%_ if (struct.fields && struct.fields.length > 0) { -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'time' || field.listType === 'array-time') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: true}) -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
export interface <%= struct.name.pascalName %>SearchCondition {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
  <%= searchCondition.name %>From?: <%= searchCondition.type %>
  <%= searchCondition.name %>To?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
  <%= searchCondition.name %>From?: <%= searchCondition.type %>
  <%= searchCondition.name %>To?: <%= searchCondition.type %>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalName %>SearchCondition = {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
  <%_ }) -%>
}

export interface <%= struct.name.pascalName %>SearchFormProps {
  open: boolean,
  setOpen: (open: boolean) => void,
  currentSearchCondition: <%= struct.name.pascalName %>SearchCondition,
  onSearch: (searchCondition: <%= struct.name.pascalName %>SearchCondition) => void
}

const <%= struct.name.pascalName %>SearchForm = ({open, setOpen, currentSearchCondition, onSearch}: <%= struct.name.pascalName %>SearchFormProps) => {
  const [searchCondition, setSearchCondition] = useState(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))

  useEffect(() => {
    setSearchCondition(cloneDeep(currentSearchCondition))
  }, [currentSearchCondition])

  const close = useCallback(() => {
    setOpen(false)
  }, [setOpen])

  const search = useCallback(() => {
    onSearch(searchCondition)
    close()
  }, [onSearch, searchCondition, close])

  const clear = useCallback(() => {
    onSearch(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))
    close()
  }, [onSearch, close])

  const setSingleSearchCondition = useCallback((value: Partial<<%= struct.name.pascalName %>SearchCondition>) => {
    setSearchCondition(searchCondition => ({
      ...searchCondition,
      ...value
    }))
  }, [])

  return (
    <Dialog open={open} onClose={close}>
      <DialogTitle><%= struct.screenLabel || struct.name.pascalName %>検索</DialogTitle>
      <DialogContent>
        <Grid container spacing={2}>
        <%_ if (struct.fields) { -%>
        <%_ struct.fields.forEach(function (field, key) { -%>
          <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'textarea' || field.listType === 'array-textarea') && field.searchType === 1) { -%>
          <Grid item xs={12}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              type="text"
              value={searchCondition.<%= field.name.lowerCamelName %>}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>: e.target.value})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType !== 0) { -%>
          <Grid item xs={12}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= field.name.lowerCamelName %>}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>: Number(e.target.value) || undefined})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType && field.searchType <= 5) { -%>
          <Grid item xs={12}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>From"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>From"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= field.name.lowerCamelName %>From}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>From: Number(e.target.value) || undefined})}
            />
          </Grid>
          <Grid item xs={12}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>To"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>To"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= field.name.lowerCamelName %>To}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>To: Number(e.target.value) || undefined})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'time' || field.listType === 'array-time') && field.searchType !== 0) { -%>
          <Grid item xs={12}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              dateTime={searchCondition.<%= field.name.lowerCamelName %> ? new Date(searchCondition.<%= field.name.lowerCamelName %>) : null}
              syncDateTime={value => setSingleSearchCondition({<%= field.name.lowerCamelName %>: value ? formatISO(value) : undefined})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
          <Grid item xs={12}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>From"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>From ? new Date(searchCondition.<%= field.name.lowerCamelName %>From) : null}
              syncDateTime={value => setSingleSearchCondition({<%= field.name.lowerCamelName %>From: value ? formatISO(value) : undefined})}
            />
          </Grid>
          <Grid item xs={12}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>To"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>To ? new Date(searchCondition.<%= field.name.lowerCamelName %>To) : null}
              syncDateTime={value => setSingleSearchCondition({<%= field.name.lowerCamelName %>To: value ? formatISO(value) : undefined})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
          <Grid item xs={12}>
            <FormControlLabel
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              control={
                <Switch
                  checked={searchCondition.<%= field.name.lowerCamelName %>}
                  onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>: e.target.checked})}
                />
              }
            />
          </Grid>
          <%_ } -%>
        <%_ }) -%>
        <%_ } -%>
        </Grid>
      </DialogContent>
      <DialogActions>
        <Button onClick={close}>キャンセル</Button>
        <Button onClick={clear}>クリア</Button>
        <Button onClick={search}>検索</Button>
      </DialogActions>
    </Dialog>
  )
}

export default <%= struct.name.pascalName %>SearchForm
