---
to: <%= rootDirectory %>/<%= projectName %>/components/common/AppDataGrid.tsx
---
import * as React from 'react'
import {styled} from '@mui/system'
import {DataGrid, DataGridProps, GridColumns, GridSortModel} from '@mui/x-data-grid'
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
  },
}))

export interface GridPageInfo {
  /** ページ番号 (初期ページは0) */
  page: number
  /** ページサイズ */
  pageSize: number
<%_ if (entity.dbType === 'datastore') { -%>
  /** ページング用のcursor配列 */
  cursors: string[]
<%_ } -%>
  /** ソート情報 */
  sortModel: GridSortModel
}

export const INITIAL_GRID_PAGE_INFO: GridPageInfo = {
  page: 0,
  pageSize: 25,
<%_ if (entity.dbType === 'datastore') { -%>
  cursors: [],
<%_ } -%>
  sortModel: []
}

// index.tsxから渡されるProps
export interface AppDataGridBaseProps<I, S> {
  /** 一覧表示用の配列 */
  items?: I[]
  /** 表示ページ情報 */
  pageInfo: GridPageInfo
  /** 全ての件数 */
  totalCount?: number
  /** 一覧の読み込み状態 */
  isLoading?: boolean
  /** 検索条件 */
  searchCondition?: S
  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  hasParent?: boolean
  /** 表示ページ情報変更コールバック */
  onChangePageInfo: (pageInfo: GridPageInfo) => void
  /** 検索条件変更コールバック */
  onChangeSearch?: (searchCondition: S) => void
  /** 編集ダイアログ表示コールバック */
  onOpenEntryForm: (item?: I) => void
  /** 削除コールバック */
  onRemove: (item: I) => void
}

// DataTableから渡されるProps
interface AppDataGridProps<I, S> extends AppDataGridBaseProps<I, S>, DataGridProps {
  /* 画面表示情報 */
  columns: GridColumns
}

export const AppDataGrid = <I, S>(props: AppDataGridProps<I, S>) => {
  const {
    items = [],
    pageInfo = INITIAL_GRID_PAGE_INFO,
    totalCount,
    isLoading = false,
    hasParent = false,
    onOpenEntryForm,
    onChangePageInfo = () => {},
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
      disableSelectionOnClick
      getRowId={item => itemIndexMap.get(item as I)!}
      onRowClick={params => onOpenEntryForm(params.row as I)}
      pageSize={pageInfo.pageSize}
      paginationMode={hasParent ? 'client' : 'server'}
      page={pageInfo.page}
      onPageChange={(page) => onChangePageInfo({...pageInfo, page})}
      onPageSizeChange={pageSize => onChangePageInfo({...pageInfo, page: 0, pageSize})}
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
