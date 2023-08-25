---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.tsx
---
import * as React from 'react'
import {useCallback, useEffect, useState} from 'react'
import {cloneDeep} from 'lodash-es'
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControlLabel,
  Grid,
  Switch,
  TextField
} from '@mui/material'
import {BaseSearchCondition, SingleSearchCondition} from '@/components/common/Base'
import DateTimeForm from '@/components/form/DateTimeForm'
import {formatISO} from 'date-fns'

<%_ const searchConditions = [] -%>
<%_ let importDateTime = false -%>
<%_ if (struct.fields && struct.fields.length > 0) { -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'time' || field.listType === 'array-time') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name, listType: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name, listType: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name, listType: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name, listType: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name, listType: 'string', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'time' || field.listType === 'array-time')) { -%>
  <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
<%_ if (searchConditions.length > 0) { -%>
export interface <%= struct.name.pascalName %>SearchCondition extends BaseSearchCondition {
  <%_ searchConditions.forEach(function(field) { -%>
    <%_ if (field.listType === 'string' && !field.range) { -%>
  <%= field.name.lowerCamelName %>: SingleSearchCondition<<%= field.listType %>>
    <%_ } -%>
    <%_ if (field.listType === 'boolean' && !field.range) { -%>
  <%= field.name.lowerCamelName %>: SingleSearchCondition<<%= field.listType %>>
    <%_ } -%>
    <%_ if (field.listType === 'number' && !field.range) { -%>
  <%= field.name.lowerCamelName %>: SingleSearchCondition<<%= field.listType %>>
    <%_ } -%>
    <%_ if (field.listType === 'number' && field.range) { -%>
  <%= field.name.lowerCamelName %>: SingleSearchCondition<<%= field.listType %>>
  <%= field.name.lowerCamelName %>From: SingleSearchCondition<<%= field.listType %>>
  <%= field.name.lowerCamelName %>To: SingleSearchCondition<<%= field.listType %>>
    <%_ } -%>
    <%_ if (field.listType === 'string' && field.range) { -%>
  <%= field.name.lowerCamelName %>: SingleSearchCondition<<%= field.listType %>>
  <%= field.name.lowerCamelName %>From: SingleSearchCondition<<%= field.listType %>>
  <%= field.name.lowerCamelName %>To: SingleSearchCondition<<%= field.listType %>>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalName %>SearchCondition = {
  <%_ searchConditions.forEach(function(field) { -%>
    <%_ if (field.listType === 'string' && !field.range) { -%>
  <%= field.name.lowerCamelName %>: {enabled: false, value: ''},
    <%_ } -%>
    <%_ if (field.listType === 'boolean' && !field.range) { -%>
  <%= field.name.lowerCamelName %>: {enabled: false, value: false},
    <%_ } -%>
    <%_ if (field.listType === 'number' && !field.range) { -%>
  <%= field.name.lowerCamelName %>: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (field.listType === 'number' && field.range) { -%>
  <%= field.name.lowerCamelName %>: {enabled: false, value: 0},
  <%= field.name.lowerCamelName %>From: {enabled: false, value: 0},
  <%= field.name.lowerCamelName %>To: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (field.listType === 'string' && field.range) { -%>
  <%= field.name.lowerCamelName %>: {enabled: false, value: ''},
  <%= field.name.lowerCamelName %>From: {enabled: false, value: ''},
  <%= field.name.lowerCamelName %>To: {enabled: false, value: ''},
    <%_ } -%>
  <%_ }) -%>
}
<%_ } else { -%>
export interface <%= struct.name.pascalName %>SearchCondition {
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalName %>SearchCondition = {}
<%_ } -%>

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

  const setSingleSearchCondition = useCallback(<T extends keyof <%= struct.name.pascalName %>SearchCondition, >(key: T, value: <%= struct.name.pascalName %>SearchCondition[T]['value']) => {
    setSearchCondition(searchCondition => ({
      ...searchCondition,
      [key]: {
        ...searchCondition[key],
        value
      }
    }))
  }, [])

  const toggleEnabled = useCallback((key: keyof <%= struct.name.pascalName %>SearchCondition) => {
    setSearchCondition(searchCondition => ({
      ...searchCondition,
      [key]: {
        ...searchCondition[key],
        enabled: !searchCondition[key].enabled
      }
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
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              type="text"
              value={searchCondition.<%= field.name.lowerCamelName %>.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= field.name.lowerCamelName %>', e.target.value)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType !== 0) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= field.name.lowerCamelName %>.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= field.name.lowerCamelName %>', Number(e.target.value) || 0)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType && field.searchType <= 5) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>From.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>From')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>From"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>From"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= field.name.lowerCamelName %>From.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= field.name.lowerCamelName %>From', Number(e.target.value) || 0)}
            />
          </Grid>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>To.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>To')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= field.name.lowerCamelName %>To"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>To"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= field.name.lowerCamelName %>To.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= field.name.lowerCamelName %>To', Number(e.target.value) || 0)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'time' || field.listType === 'array-time') && field.searchType !== 0) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>.value ? new Date(searchCondition.<%= field.name.lowerCamelName %>.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= field.name.lowerCamelName %>', value ? formatISO(value) : '')}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>From.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>From')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>From"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>From.value ? new Date(searchCondition.<%= field.name.lowerCamelName %>From.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= field.name.lowerCamelName %>From', value ? formatISO(value) : '')}
            />
          </Grid>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>To.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>To')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>To"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>To.value ? new Date(searchCondition.<%= field.name.lowerCamelName %>To.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= field.name.lowerCamelName %>To', value ? formatISO(value) : '')}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= field.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= field.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <FormControlLabel
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              control={
                <Switch
                  checked={searchCondition.<%= field.name.lowerCamelName %>.value}
                  onChange={e => setSingleSearchCondition('<%= field.name.lowerCamelName %>', e.target.checked)}
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
