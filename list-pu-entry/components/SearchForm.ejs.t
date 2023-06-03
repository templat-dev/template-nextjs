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
<%_ struct.fields.forEach(function (property, key) { -%>
  <%_ if ((property.listType === 'string' || property.listType === 'array-string' || property.listType === 'time' || property.listType === 'array-time') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'bool' || property.listType === 'array-bool') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'number' || property.listType === 'array-number') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'number' || property.listType === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'time' || property.listType === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'string', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'time' || property.listType === 'array-time')) { -%>
  <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
<%_ if (searchConditions.length > 0) { -%>
export interface <%= struct.name.pascalName %>SearchCondition extends BaseSearchCondition {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.listType === 'string' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'boolean' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'number' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'number' && property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>From: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>To: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'string' && property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>From: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>To: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalName %>SearchCondition = {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.listType === 'string' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: ''},
    <%_ } -%>
    <%_ if (property.listType === 'boolean' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: false},
    <%_ } -%>
    <%_ if (property.listType === 'number' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.listType === 'number' && property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: 0},
  <%= property.name.lowerCamelName %>From: {enabled: false, value: 0},
  <%= property.name.lowerCamelName %>To: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.listType === 'string' && property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: ''},
  <%= property.name.lowerCamelName %>From: {enabled: false, value: ''},
  <%= property.name.lowerCamelName %>To: {enabled: false, value: ''},
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
      [key] : {
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
      <DialogTitle><%= struct.label || struct.name.upperSnakeName %>検索</DialogTitle>
      <DialogContent>
        <Grid container spacing={2}>
        <%_ if (struct.fields) { -%>
        <%_ struct.fields.forEach(function (property, key) { -%>
          <%_ if ((property.listType === 'string' || property.listType === 'array-string' || property.listType === 'textarea' || property.listType === 'array-textarea') && property.searchType === 1) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              type="text"
              value={searchCondition.<%= property.name.lowerCamelName %>.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name.lowerCamelName %>', e.target.value)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.listType === 'number' || property.listType === 'array-number') && property.searchType !== 0) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= property.name.lowerCamelName %>.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name.lowerCamelName %>', Number(e.target.value) || 0)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.listType === 'number' || property.listType === 'array-number') && 2 <= property.searchType && property.searchType <= 5) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>From.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>From')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name.lowerCamelName %>From"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>From"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= property.name.lowerCamelName %>From.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name.lowerCamelName %>From', Number(e.target.value) || 0)}
            />
          </Grid>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>To.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>To')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name.lowerCamelName %>To"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>To"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= property.name.lowerCamelName %>To.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name.lowerCamelName %>To', Number(e.target.value) || 0)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.listType === 'time' || property.listType === 'array-time') && property.searchType !== 0) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              dateTime={searchCondition.<%= property.name.lowerCamelName %>.value ? new Date(searchCondition.<%= property.name.lowerCamelName %>.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= property.name.lowerCamelName %>', value ? formatISO(value) : '')}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.listType === 'time' || property.listType === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>From.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>From')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>From"
              dateTime={searchCondition.<%= property.name.lowerCamelName %>From.value ? new Date(searchCondition.<%= property.name.lowerCamelName %>From.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= property.name.lowerCamelName %>From', value ? formatISO(value) : '')}
            />
          </Grid>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>To.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>To')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>To"
              dateTime={searchCondition.<%= property.name.lowerCamelName %>To.value ? new Date(searchCondition.<%= property.name.lowerCamelName %>To.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= property.name.lowerCamelName %>To', value ? formatISO(value) : '')}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.listType === 'bool' || property.listType === 'array-bool') && property.searchType === 1) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name.lowerCamelName %>.enabled}
              onChange={() => toggleEnabled('<%= property.name.lowerCamelName %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <FormControlLabel
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              control={
                <Switch
                  checked={searchCondition.<%= property.name.lowerCamelName %>.value}
                  onChange={e => setSingleSearchCondition('<%= property.name.lowerCamelName %>', e.target.checked)}
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
