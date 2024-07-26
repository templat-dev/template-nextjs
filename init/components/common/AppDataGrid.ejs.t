---
to: <%= rootDirectory %>/components/common/AppDataGrid.tsx
---
import {styled} from '@mui/system'
import {DataGrid, DataGridProps, GridColDef, GridPaginationModel, GridSortModel} from '@mui/x-data-grid'
import * as React from 'react'
import {useMemo} from 'react'

const StyledDataGrid = styled(DataGrid)<DataGridProps>(({theme}) => ({
  '&.MuiDataGrid-root': {
    border: 0
  },
  '& .MuiDataGrid-toolbarContainer': {
    padding: '8px 16px'
  },
  '& .MuiDataGrid-overlay': {
    top: '112px !important'
  },
  '& .MuiDataGrid-row': {
    cursor: 'pointer'
  },
  '& .MuiDataGrid-cell:focus-within, & .MuiDataGrid-cell:focus': {
    outline: 'none !important'
  },
  '& .MuiDataGrid-columnHeader:focus-within, & .MuiDataGrid-columnHeader:focus': {
    outline: 'none !important'
  }
}))

export type GridPageInfo = {
  /** ページ番号 (初期ページは0) */
  page: number
  /** ページサイズ */
  pageSize: number
  /** ページング用のcursor配列 */
  cursors: string[]
  /** ソート情報 */
  sortModel: GridSortModel
}

export const INITIAL_GRID_PAGE_INFO: GridPageInfo = {
  page: 0,
  pageSize: 25,
  cursors: [],
  sortModel: []
}

// index.tsxから渡されるProps
export type AppDataGridBaseProps<I> = {
  /** 一覧表示用の配列 */
  items?: I[]
  /** 表示ページ情報 */
  pageInfo: GridPageInfo
  /** 全ての件数 */
  totalCount?: number
  /** 一覧の読み込み状態 */
  isLoading?: boolean
  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  hasParent?: boolean
  /** 表示ページ情報変更コールバック */
  onChangePageInfo: (pageInfo: GridPageInfo) => void
  /** 行選択コールバック */
  onClickRow: (item?: I) => void
  /** 削除コールバック */
  onRemove: (item: I) => void
}

// DataTableから渡されるProps
type AppDataGridProps<I> = AppDataGridBaseProps<I> & DataGridProps & {
  /* 画面表示情報 */
  columns: GridColDef[]
}
export const AppDataGrid = <I, >(props: AppDataGridProps<I>) => {
  const {
    items = [],
    pageInfo = INITIAL_GRID_PAGE_INFO,
    totalCount,
    isLoading = false,
    hasParent = false,
    onClickRow,
    onChangePageInfo = () => {}
  } = props

  const itemIndexMap = useMemo((): Map<I, number> => {
    return items.reduce<Map<I, number>>((map, item, index) => {
      map.set(item, index)
      return map
    }, new Map<I, number>())
  }, [items])

  return (
    <StyledDataGrid
      autoHeight
      disableColumnMenu
      rowCount={totalCount}
      disableRowSelectionOnClick
      getRowId={item => itemIndexMap.get(item as I)!}
      onRowClick={params => onClickRow(params.row as I)}
      pageSizeOptions={[pageInfo.pageSize]}
      paginationMode={hasParent ? 'client' : 'server'}
      paginationModel={{page: pageInfo.page, pageSize: pageInfo.pageSize}}
      onPaginationModelChange={(model: GridPaginationModel) => onChangePageInfo({
        ...pageInfo,
        page: model.page,
        pageSize: model.pageSize
      })}
      sortingMode={hasParent ? 'client' : 'server'}
      sortModel={pageInfo.sortModel}
      onSortModelChange={sortModel => onChangePageInfo({...pageInfo, page: 0, sortModel})}
      loading={isLoading}
      {...{
        ...props,
        sx: undefined
      }}
    />
  )
}
