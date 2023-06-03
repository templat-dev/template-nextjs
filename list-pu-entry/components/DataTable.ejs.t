---
to: <%= rootDirectory %>/<%= project.name %>/components/<%= struct.name %>/<%= h.changeCase.pascal(struct.name) %>DataTable.tsx
---
import * as React from 'react'
import {useMemo, useState} from 'react'
import {Box, Divider, Fab, IconButton, Paper, Typography} from '@mui/material'
<%_ if (struct.hasImage === true || struct.hasMultiImage === true) { -%>
import {GridActionsCellItem, GridColumns, GridRenderCellParams, GridToolbarContainer} from '@mui/x-data-grid'
<%_ } else { -%>
import {GridActionsCellItem, GridColumns, GridToolbarContainer} from '@mui/x-data-grid'
<%_ } -%>
import SearchIcon from '@mui/icons-material/Search'
import AddIcon from '@mui/icons-material/Add'
import DeleteIcon from '@mui/icons-material/Delete'
<%_ if (struct.hasMultiImage === true) { -%>
import 'react-responsive-carousel/lib/styles/carousel.min.css'
import {Carousel} from 'react-responsive-carousel'
<%_ } -%>
import {Model<%= h.changeCase.pascal(struct.name) %>} from '@/apis'
import {AppDataGrid, AppDataGridBaseProps} from '@/components/common/AppDataGrid'
<%_ if (struct.structType !== 'struct') { -%>
import <%= h.changeCase.pascal(struct.name) %>SearchForm, {
  INITIAL_<%= h.changeCase.constant(struct.name) %>_SEARCH_CONDITION,
  <%= h.changeCase.pascal(struct.name) %>SearchCondition
} from '@/components/<%= struct.name %>/<%= h.changeCase.pascal(struct.name) %>SearchForm'
<%_ } -%>

<%_ if (struct.structType === 'struct') { -%>
const <%= h.changeCase.pascal(struct.name) %>DataTable = (props: AppDataGridBaseProps<Model<%= h.changeCase.pascal(struct.name) %>, never>) => {
  const {items = [], onOpenEntryForm, onRemove} = props
<%_ } -%>
<%_ if (struct.structType !== 'struct') { -%>
const <%= h.changeCase.pascal(struct.name) %>DataTable = (props: AppDataGridBaseProps<Model<%= h.changeCase.pascal(struct.name) %>, <%= h.changeCase.pascal(struct.name) %>SearchCondition>) => {
  const {
    items = [],
    searchCondition = INITIAL_<%= h.changeCase.constant(struct.name) %>_SEARCH_CONDITION,
    hasParent,
    onChangeSearch = () => {},
    onOpenEntryForm,
    onRemove
  } = props

  /** 検索フォームの表示表示状態 (true: 表示, false: 非表示) */
  const [searchFormOpen, setSearchFormOpen] = useState<boolean>(false)

  const previewSearchCondition = useMemo((): string => {
    const previewSearchConditions = []
    for (const [key, value] of Object.entries(searchCondition)) {
      if (!value.enabled) {
        continue
      }
      previewSearchConditions.push(`${key}=${value.value}`)
    }
    return previewSearchConditions.join(', ')
  }, [searchCondition])
<%_ } -%>

  const columns = useMemo((): GridColumns => [
      <%_ if (struct.fields) { -%>
      <%_ struct.fields.forEach(function(property, index){ -%>
        <%_ if (property.listType === 'image' && property.dataType === 'string') { -%>
    {
      field: '<%= property.name %>',
      headerName: '<%= property.screenLabel ? property.screenLabel : property.name %>',
      width: 120,
      renderCell: (params: GridRenderCellParams<string>) => (
        params.value ?
          <Box component="img" src={params.value} sx={{
            height: '100px',
            width: '100px',
            aspectRatio: '1',
            objectFit: 'contain'
          }}/> : <Box/>
      ),
    },
        <%_ } else if (property.listType === 'array-image') { -%>
    {
      field: '<%= property.name %>',
      headerName: '<%= property.screenLabel ? property.screenLabel : property.name %>',
      width: 120,
      renderCell: (params: GridRenderCellParams<string[]>) => (
        params.value ?
          <Carousel showStatus={false} showIndicators={false} showThumbs={false} width={100} infiniteLoop
                    renderArrowPrev={(clickHandler: any) => (
                      <button type="button" className={'control-arrow control-prev'}
                              onClick={e => {
                                e.stopPropagation()
                                clickHandler()
                              }}/>
                    )}
                    renderArrowNext={(clickHandler: any) => (
                      <button type="button" className={'control-arrow control-next'}
                              onClick={e => {
                                e.stopPropagation()
                                clickHandler()
                              }}/>
                    )}>
            {params.value.map((item, i) => (
              <Box key={i} component="img" src={item} sx={{
                height: '100px',
                width: '100px',
                aspectRatio: '1',
                objectFit: 'contain'
              }}/>
            ))}
          </Carousel> : <Box/>
      )
    },
        <%_ } else if (property.listType !== 'none' && property.dataType !== 'struct' && property.dataType !== 'array-struct') { -%>
    {field: '<%= property.name %>', headerName: '<%= property.screenLabel ? property.screenLabel : property.name === 'id' ? 'ID' : property.name %>', width: <%= property.name === 'id' ? 160 : 120 %>},
        <%_ } -%>
      <%_ }); -%>
      <%_ } -%>
    {
      field: 'actions',
      type: 'actions',
      headerName: '',
      width: 150,
      getActions: ({id}) => {
        return [
          <GridActionsCellItem
            key={id}
            icon={<DeleteIcon/>}
            label="Delete"
            onClick={() => {
              const item = items[id as number]
              onRemove(item)
            }}
            color="inherit"
          />
        ]
      }
    }
  ], [items, onRemove])

  return (
    <Paper elevation={1}>
      <AppDataGrid
        columns={columns}
        rows={items}
<%_ if (struct.hasImage === true || struct.hasMultiImage === true) { -%>
        rowHeight={100}
<%_ } -%>
        components={{
          Toolbar: () => (
            <GridToolbarContainer>
              <Typography variant="h6" component="div">
                <%= struct.listLabel %>
              </Typography>
<%_ if (struct.structType !== 'struct') { -%>
              {!hasParent && (
                <>
                  <Divider orientation="vertical" flexItem sx={{mx: 2, my: 1}}/>
                  <IconButton onClick={() => setSearchFormOpen(true)}>
                    <SearchIcon/>
                  </IconButton>
                  <Typography variant="subtitle1">
                    {previewSearchCondition}
                  </Typography>
                </>
              )}
<%_ } -%>
              <Box sx={{flexGrow: 1}}/>
              <Fab color="primary" size="small" onClick={() => onOpenEntryForm()}>
                <AddIcon/>
              </Fab>
            </GridToolbarContainer>
          )
        }}
        {...props}
      />
<%_ if (struct.structType !== 'struct') { -%>
      <<%= h.changeCase.pascal(struct.name) %>SearchForm
        open={searchFormOpen}
        setOpen={setSearchFormOpen}
        currentSearchCondition={searchCondition}
        onSearch={onChangeSearch}
      />
<%_ } -%>
    </Paper>
  )
}

export default <%= h.changeCase.pascal(struct.name) %>DataTable
