---
to: <%= rootDirectory %>/<%= projectName %>/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>SearchForm.tsx
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
<%_ if (entity.listProperties.listExtraProperties && entity.listProperties.listExtraProperties.length > 0) { -%>
<%_ entity.listProperties.listExtraProperties.forEach(function (property, key) { -%>
  <%_ if ((property.type === 'string' || property.type === 'array-string' || property.type === 'time' || property.type === 'array-time') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'bool' || property.type === 'array-bool') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'number' || property.type === 'array-number') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'number' || property.type === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'time' || property.type === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name, type: 'string', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'time' || property.type === 'array-time')) { -%>
  <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
<%_ if (searchConditions.length > 0) { -%>
export interface <%= h.changeCase.pascal(entity.name) %>SearchCondition extends BaseSearchCondition {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.type === 'string' && !property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'boolean' && !property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'number' && !property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'number' && property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>From: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>To: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'string' && property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>From: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>To: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION: <%= h.changeCase.pascal(entity.name) %>SearchCondition = {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.type === 'string' && !property.range) { -%>
  <%= property.name %>: {enabled: false, value: ''},
    <%_ } -%>
    <%_ if (property.type === 'boolean' && !property.range) { -%>
  <%= property.name %>: {enabled: false, value: false},
    <%_ } -%>
    <%_ if (property.type === 'number' && !property.range) { -%>
  <%= property.name %>: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.type === 'number' && property.range) { -%>
  <%= property.name %>: {enabled: false, value: 0},
  <%= property.name %>From: {enabled: false, value: 0},
  <%= property.name %>To: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.type === 'string' && property.range) { -%>
  <%= property.name %>: {enabled: false, value: ''},
  <%= property.name %>From: {enabled: false, value: ''},
  <%= property.name %>To: {enabled: false, value: ''},
    <%_ } -%>
  <%_ }) -%>
}
<%_ } else { -%>
export interface <%= h.changeCase.pascal(entity.name) %>SearchCondition {
}

export const INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION: <%= h.changeCase.pascal(entity.name) %>SearchCondition = {}
<%_ } -%>

export interface <%= h.changeCase.pascal(entity.name) %>SearchFormProps {
  open: boolean,
  setOpen: (open: boolean) => void,
  currentSearchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition,
  onSearch: (searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition) => void
}

const <%= h.changeCase.pascal(entity.name) %>SearchForm = ({open, setOpen, currentSearchCondition, onSearch}: <%= h.changeCase.pascal(entity.name) %>SearchFormProps) => {
  const [searchCondition, setSearchCondition] = useState(cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION))

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
    onSearch(cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION))
    close()
  }, [onSearch, close])

  const setSingleSearchCondition = useCallback(<T extends keyof <%= h.changeCase.pascal(entity.name) %>SearchCondition, >(key: T, value: <%= h.changeCase.pascal(entity.name) %>SearchCondition[T]['value']) => {
    setSearchCondition(searchCondition => ({
      ...searchCondition,
      [key] : {
        ...searchCondition[key],
        value
      }
    }))
  }, [])

  const toggleEnabled = useCallback((key: keyof <%= h.changeCase.pascal(entity.name) %>SearchCondition) => {
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
      <DialogTitle><%= entity.label || h.changeCase.constant(entity.name) %>検索</DialogTitle>
      <DialogContent>
        <Grid container spacing={2}>
        <%_ if (entity.listProperties.listExtraProperties) { -%>
        <%_ entity.listProperties.listExtraProperties.forEach(function (property, key) { -%>
          <%_ if ((property.type === 'string' || property.type === 'array-string' || property.type === 'textarea' || property.type === 'array-textarea') && property.searchType === 1) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>.enabled}
              onChange={() => toggleEnabled('<%= property.name %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              type="text"
              value={searchCondition.<%= property.name %>.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name %>', e.target.value)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.type === 'number' || property.type === 'array-number') && property.searchType !== 0) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>.enabled}
              onChange={() => toggleEnabled('<%= property.name %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= property.name %>.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name %>', Number(e.target.value) || 0)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.type === 'number' || property.type === 'array-number') && 2 <= property.searchType && property.searchType <= 5) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>From.enabled}
              onChange={() => toggleEnabled('<%= property.name %>From')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name %>From"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>From"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= property.name %>From.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name %>From', Number(e.target.value) || 0)}
            />
          </Grid>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>To.enabled}
              onChange={() => toggleEnabled('<%= property.name %>To')}
            />
          </Grid>
          <Grid item xs={10}>
            <TextField
              margin="dense"
              id="<%= property.name %>To"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>To"
              type="number"
              inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
              value={searchCondition.<%= property.name %>To.value}
              fullWidth
              variant="standard"
              onChange={e => setSingleSearchCondition('<%= property.name %>To', Number(e.target.value) || 0)}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.type === 'time' || property.type === 'array-time') && property.searchType !== 0) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>.enabled}
              onChange={() => toggleEnabled('<%= property.name %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              dateTime={searchCondition.<%= property.name %>.value ? new Date(searchCondition.<%= property.name %>.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= property.name %>', value ? formatISO(value) : '')}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.type === 'time' || property.type === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>From.enabled}
              onChange={() => toggleEnabled('<%= property.name %>From')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= property.screenLabel ? property.screenLabel : property.name %>From"
              dateTime={searchCondition.<%= property.name %>From.value ? new Date(searchCondition.<%= property.name %>From.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= property.name %>From', value ? formatISO(value) : '')}
            />
          </Grid>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>To.enabled}
              onChange={() => toggleEnabled('<%= property.name %>To')}
            />
          </Grid>
          <Grid item xs={10}>
            <DateTimeForm
              label="<%= property.screenLabel ? property.screenLabel : property.name %>To"
              dateTime={searchCondition.<%= property.name %>To.value ? new Date(searchCondition.<%= property.name %>To.value) : null}
              syncDateTime={value => setSingleSearchCondition('<%= property.name %>To', value ? formatISO(value) : '')}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((property.type === 'bool' || property.type === 'array-bool') && property.searchType === 1) { -%>
          <Grid item xs={2}>
            <Switch
              checked={searchCondition.<%= property.name %>.enabled}
              onChange={() => toggleEnabled('<%= property.name %>')}
            />
          </Grid>
          <Grid item xs={10}>
            <FormControlLabel
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              control={
                <Switch
                  checked={searchCondition.<%= property.name %>.value}
                  onChange={e => setSingleSearchCondition('<%= property.name %>', e.target.checked)}
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

export default <%= h.changeCase.pascal(entity.name) %>SearchForm
