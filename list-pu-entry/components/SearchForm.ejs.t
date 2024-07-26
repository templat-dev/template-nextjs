---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.tsx
---
import {<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request} from '@/apis'
<%_ if (struct.exists.search.time || struct.exists.search.arrayTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm'
<%_ } -%>
import {INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION} from '@/initials/<%= struct.name.pascalName %>Initials'
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
<%_ if (struct.exists.search.text || struct.exists.search.number) { -%>
  TextField,
<%_ } -%>
} from '@mui/material'
<%_ if (struct.exists.search.time || struct.exists.search.arrayTime) { -%>
import dayjs from 'dayjs'
<%_ } -%>
import {cloneDeep} from 'lodash-es'
import * as React from 'react'
import {useCallback, useEffect, useState} from 'react'
import {Writable} from 'type-fest'

type <%= struct.name.pascalName %>SearchFormProps = {
  open: boolean,
  setOpen: (open: boolean) => void,
  currentSearchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>,
  onSearch: (searchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>) => void
}
const <%= struct.name.pascalName %>SearchForm = ({open, setOpen, currentSearchCondition, onSearch}: <%= struct.name.pascalName %>SearchFormProps) => {
  const [searchCondition, setSearchCondition] = useState(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))

  useEffect(() => {
    setSearchCondition(cloneDeep(currentSearchCondition))
  }, [currentSearchCondition])

  useEffect(() => {
    // 空文字とfalseは表示されないため検索条件から除外する
    setSearchCondition(searchCondition => {
      for (const [key, value] of Object.entries(searchCondition)) {
        if ((typeof value === 'boolean' || typeof value === 'string') && !value) {
          (searchCondition as any)[key] = undefined
        }
      }
      return searchCondition
    })
  }, [searchCondition])

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

  const setSingleSearchCondition = useCallback((value: Partial<Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>>) => {
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
          <%_ if ((field.dataType === 'string' || field.dataType === 'array-string' || field.dataType === 'textarea' || field.dataType === 'array-textarea') && field.searchType === 1) { -%>
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
          <%_ if ((field.dataType === 'number' || field.dataType === 'array-number') && field.searchType !== 0) { -%>
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
              onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>: e.target.value === '' ? undefined : Number(e.target.value)})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.dataType === 'number' || field.dataType === 'array-number') && 2 <= field.searchType && field.searchType <= 5) { -%>
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
              onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>From: e.target.value === '' ? undefined : Number(e.target.value)})}
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
              onChange={e => setSingleSearchCondition({<%= field.name.lowerCamelName %>To: e.target.value === '' ? undefined : Number(e.target.value)})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.dataType === 'time' || field.dataType === 'array-time') && field.searchType !== 0) { -%>
          <Grid item xs={12}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>}
              syncDateTime={value => setSingleSearchCondition({<%= field.name.lowerCamelName %>: value ? dayjs(value).format() : undefined})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.dataType === 'time' || field.dataType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
          <Grid item xs={12}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>From"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>From}
              syncDateTime={value => setSingleSearchCondition({<%= field.name.lowerCamelName %>From: value ? dayjs(value).format() : undefined})}
            />
          </Grid>
          <Grid item xs={12}>
            <DateTimeForm
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>To"
              dateTime={searchCondition.<%= field.name.lowerCamelName %>To}
              syncDateTime={value => setSingleSearchCondition({<%= field.name.lowerCamelName %>To: value ? dayjs(value).format() : undefined})}
            />
          </Grid>
          <%_ } -%>
          <%_ if ((field.dataType === 'bool' || field.dataType === 'array-bool') && field.searchType === 1) { -%>
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
