---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable.tsx
---
import * as React from 'react'
<%_ if (struct.structType !== 'struct') { -%>
import {useMemo, useState} from 'react'
import {Box, Divider, Fab, IconButton, Paper, Typography} from '@mui/material'
<%_ } else { -%>
import {useMemo} from 'react'
import {Box, Fab, Paper, Typography} from '@mui/material'
<%_ } -%>
<%_ if (struct.exists.list.image || struct.exists.list.arrayImage) { -%>
import {
  GridActionsCellItem,
  GridColDef,
  GridRenderCellParams,
  GridRowParams,
  GridToolbarContainer
} from '@mui/x-data-grid'
<%_ } else { -%>
import {GridActionsCellItem, GridColDef, GridRowParams, GridToolbarContainer} from '@mui/x-data-grid'
<%_ } -%>
<%_ if (struct.structType !== 'struct') { -%>
import SearchIcon from '@mui/icons-material/Search'
<%_ } -%>
import AddIcon from '@mui/icons-material/Add'
import DeleteIcon from '@mui/icons-material/Delete'
<%_ if (struct.exists.list.arrayImage) { -%>
import 'react-responsive-carousel/lib/styles/carousel.min.css'
import {Carousel} from 'react-responsive-carousel'
<%_ } -%>
import {Model<%= struct.name.pascalName %>} from '@/apis'
import {AppDataGrid, AppDataGridBaseProps} from '@/components/common/AppDataGrid'
<%_ if (struct.structType !== 'struct') { -%>
import <%= struct.name.pascalName %>SearchForm, {
  INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION,
  <%= struct.name.pascalName %>SearchCondition
} from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm'
<%_ } -%>

<%_ if (struct.structType === 'struct') { -%>
const <%= struct.name.pascalName %>DataTable = (props: AppDataGridBaseProps<Model<%= struct.name.pascalName %>, never>) => {
  const {items = [], onOpenEntryForm, onRemove} = props
<%_ } -%>
<%_ if (struct.structType !== 'struct') { -%>
const <%= struct.name.pascalName %>DataTable = (props: AppDataGridBaseProps<Model<%= struct.name.pascalName %>, <%= struct.name.pascalName %>SearchCondition>) => {
  const {
    items = [],
    searchCondition = INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION,
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
      if (!value) {
        continue
      }
      previewSearchConditions.push(`${key}=${value}`)
    }
    return previewSearchConditions.join(', ')
  }, [searchCondition])
<%_ } -%>

  const columns = useMemo((): GridColDef[] => [
      <%_ if (struct.fields) { -%>
      <%_ struct.fields.forEach(function(field, index){ -%>
        <%_ if (field.listType === 'image' && field.dataType === 'string') { -%>
    {
      field: '<%= field.name.lowerCamelName %>',
      headerName: '<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>',
      width: 120,
      renderCell: (params: GridRenderCellParams<any, string>) => (
        params.value ?
          <Box component="img" src={params.value} sx={{
            height: '100px',
            width: '100px',
            aspectRatio: '1',
            objectFit: 'contain'
          }}/> : <Box/>
      ),
    },
        <%_ } else if (field.listType === 'array-image') { -%>
    {
      field: '<%= field.name.lowerCamelName %>',
      headerName: '<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>',
      width: 120,
      renderCell: (params: GridRenderCellParams<any, string[]>) => (
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
        <%_ } else if (field.listType !== 'none' && field.dataType !== 'struct' && field.dataType !== 'array-struct') { -%>
    {field: '<%= field.name.lowerCamelName %>', headerName: '<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName === 'id' ? 'ID' : field.name.lowerCamelName %>', width: <%= field.name.lowerCamelName === 'id' ? 160 : 120 %>},
        <%_ } -%>
      <%_ }); -%>
      <%_ } -%>
    {
      field: 'actions',
      type: 'actions',
      headerName: '',
      width: 150,
      getActions: ((params: GridRowParams) => {
        return [
          <GridActionsCellItem
            key={params.id}
            icon={<DeleteIcon/>}
            label="Delete"
            onClick={() => {
              const item = items[params.id as number]
              onRemove(item)
            }}
            color="inherit"
          />
        ]
      })
    }
  ], [items, onRemove])

  return (
    <Paper elevation={1}>
      <AppDataGrid
        columns={columns}
        rows={items}
<%_ if (struct.exists.list.image || struct.exists.list.arrayImage) { -%>
        rowHeight={100}
<%_ } -%>
        components={{
          Toolbar: () => (
            <GridToolbarContainer>
              <Typography variant="h6" component="div">
                <%= struct.screenLabel || struct.name.pascalName %>一覧
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
      <<%= struct.name.pascalName %>SearchForm
        open={searchFormOpen}
        setOpen={setSearchFormOpen}
        currentSearchCondition={searchCondition}
        onSearch={onChangeSearch}
      />
<%_ } -%>
    </Paper>
  )
}

export default <%= struct.name.pascalName %>DataTable
