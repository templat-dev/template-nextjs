---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/${struct.name.lowerCamelName}/index.tsx` : null %>"
force: true
---
import * as React from 'react'
import {useCallback, useEffect, useState} from 'react'
import {cloneDeep} from 'lodash-es'
import {NextPage} from 'next'
import {useRouter} from 'next/router'
import {useResetRecoilState, useSetRecoilState} from 'recoil'
import {Container, Dialog} from '@mui/material'
import {dialogState, DialogState, loadingState, snackbarState, SnackbarState} from '@/state/App'
import {Model<%= struct.name.pascalName %>, <%= struct.name.pascalName %>Api} from '@/apis'
import {NEW_INDEX} from '@/components/common/Base'
import {GridPageInfo, INITIAL_GRID_PAGE_INFO} from '@/components/common/AppDataGrid'
import <%= struct.name.pascalName %>DataTable from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable'
import {
  INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION,
  <%= struct.name.pascalName %>SearchCondition
} from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm'
import <%= struct.name.pascalName %>EntryForm, {INITIAL_<%= struct.name.upperSnakeName %>} from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm'

const <%= struct.name.pascalPluralName %>: NextPage = () => {
  const router = useRouter()
  const showLoading = useSetRecoilState<boolean>(loadingState)
  const hideLoading = useResetRecoilState(loadingState)
  const showDialog = useSetRecoilState<DialogState>(dialogState)
  const showSnackbar = useSetRecoilState<SnackbarState>(snackbarState)

  /** 一覧表示用の配列 */
  const [<%= struct.name.lowerCamelPluralName %>, set<%= struct.name.pascalPluralName %>] = useState<Model<%= struct.name.pascalName %>[]>([])

  /** 一覧の表示ページ情報 */
  const [pageInfo, setPageInfo] = useState<GridPageInfo>(cloneDeep(INITIAL_GRID_PAGE_INFO))

  /** 一覧の合計件数 */
  const [totalCount, setTotalCount] = useState(0)

  /** 一覧の読み込み状態 */
  const [isLoading, setIsLoading] = useState<boolean>(false)

  /** 検索条件 */
  const [searchCondition, setSearchCondition] = useState<<%= struct.name.pascalName %>SearchCondition>(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))

  /** 入力フォームの表示表示状態 (true: 表示, false: 非表示) */
  const [entryFormOpen, setEntryFormOpen] = useState<boolean>(false)

  /** 編集対象 */
  const [editTarget, setEditTarget] = useState<Model<%= struct.name.pascalName %> | null>(null)

  /** 編集対象のインデックス */
  const [editIndex, setEditIndex] = useState<number>(-1)

  useEffect(() => {
    (async () => {
      await fetch()
    })()
    // eslint-disable-next-line
  }, [router.pathname])

  const fetch = useCallback(async (
    {searchCondition = INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo = INITIAL_GRID_PAGE_INFO}
      : { searchCondition: <%= struct.name.pascalName %>SearchCondition, pageInfo: GridPageInfo }
      = {searchCondition: INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo: INITIAL_GRID_PAGE_INFO}
  ) => {
    setIsLoading(true)
    try {
      const data = await new <%= struct.name.pascalName %>Api().search<%= struct.name.pascalName %>({
        <%_ struct.fields.forEach(function(property, index){ -%>
<%#_ 通常の検索 -%>
        <%_ if ((property.listType === 'string' || property.listType === 'time' || property.listType === 'bool' || property.listType === 'number')  && property.searchType === 1) { -%>
        <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? searchCondition.<%= property.name.lowerCamelName %>.value : undefined,
<%#_ 配列の検索 -%>
        <%_ } else if ((property.listType === 'array-string' || property.listType === 'array-time' || property.listType === 'array-bool' || property.listType === 'array-number')  && property.searchType === 1) { -%>
        <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? [searchCondition.<%= property.name.lowerCamelName %>.value] : undefined,
<%#_ 範囲検索 -%>
        <%_ } else if ((property.listType === 'time' || property.listType === 'number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
        <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? searchCondition.<%= property.name.lowerCamelName %>.value : undefined,
        <%= property.name.lowerCamelName %>From: searchCondition.<%= property.name.lowerCamelName %>From.enabled ? searchCondition.<%= property.name.lowerCamelName %>From.value : undefined,
        <%= property.name.lowerCamelName %>To: searchCondition.<%= property.name.lowerCamelName %>To.enabled ? searchCondition.<%= property.name.lowerCamelName %>To.value : undefined,
<%#_ 配列の範囲検索 -%>
        <%_ } else if ((property.listType === 'array-time' || property.listType === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
        <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? [searchCondition.<%= property.name.lowerCamelName %>.value] : undefined,
        <%= property.name.lowerCamelName %>From: searchCondition.<%= property.name.lowerCamelName %>From.enabled ? searchCondition.<%= property.name.lowerCamelName %>From.value : undefined,
        <%= property.name.lowerCamelName %>To: searchCondition.<%= property.name.lowerCamelName %>To.enabled ? searchCondition.<%= property.name.lowerCamelName %>To.value : undefined,
        <%_ } -%>
        <%_ }) -%>
        limit: pageInfo.pageSize !== -1 ? pageInfo.pageSize : undefined,
<%_ if (project.dbType === 'datastore') { -%>
        cursor: pageInfo.page !== 0 ? pageInfo.cursors[pageInfo.page - 1] : undefined,
        orderBy: pageInfo.sortModel.map(sm => `${sm.sort === 'desc' ? '-' : ''}${sm.field}`).join(',') || undefined
<%_ } else { -%>
        offset: pageInfo.page * pageInfo.pageSize,
        orderBy: page.sortModel.map(sm => `${snakeCase(sm.field)} ${sm.sort}`).join(',') || undefined
<%_ } -%>
      }).then(res => res.data)
<%_ if (project.dbType === 'datastore') { -%>
      if (data.cursor) {
        const cursors = cloneDeep(pageInfo.cursors)
        cursors[pageInfo.page] = data.cursor
        setPageInfo({...pageInfo, cursors})
      }
<%_ } -%>
      set<%= struct.name.pascalPluralName %>(data.<%= struct.name.lowerCamelPluralName %> || [])
      setTotalCount(data.count || 0)
    } finally {
      setIsLoading(false)
    }
  }, [])

  const reFetch = useCallback(async () => {
    await fetch({searchCondition, pageInfo})
  }, [fetch, searchCondition, pageInfo])

  const search = useCallback(async (searchCondition: <%= struct.name.pascalName %>SearchCondition) => {
    setSearchCondition(searchCondition)
    await fetch({searchCondition, pageInfo})
  }, [fetch, pageInfo])

  const changePageInfo = useCallback(async (pageInfo: GridPageInfo) => {
    setPageInfo(pageInfo)
    await fetch({searchCondition, pageInfo})
  }, [fetch, searchCondition])

  const openEntryForm = useCallback((<%= struct.name.lowerCamelName %>?: Model<%= struct.name.pascalName %>) => {
    if (!!<%= struct.name.lowerCamelName %>) {
      setEditTarget(cloneDeep(<%= struct.name.lowerCamelName %>))
      setEditIndex(<%= struct.name.lowerCamelPluralName %>.findIndex(item => item.id === <%= struct.name.lowerCamelName %>.id))
    } else {
      setEditTarget(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>))
      setEditIndex(NEW_INDEX)
    }
    setEntryFormOpen(true)
  }, [<%= struct.name.lowerCamelPluralName %>])

  const remove = useCallback((index: number) => {
    showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        showLoading(true)
        try {
          await new <%= struct.name.pascalName %>Api().delete<%= struct.name.pascalName %>({id: <%= struct.name.lowerCamelPluralName %>[index].id!})
          setEntryFormOpen(false)
          await reFetch()
        } finally {
          hideLoading()
        }
        showSnackbar({text: '削除しました。'})
      }
    })
  }, [<%= struct.name.lowerCamelPluralName %>, setEntryFormOpen, reFetch, showDialog, showLoading, hideLoading, showSnackbar])

  const removeRow = useCallback((<%= struct.name.lowerCamelName %>: Model<%= struct.name.pascalName %>) => {
    const index = <%= struct.name.lowerCamelPluralName %>.indexOf(<%= struct.name.lowerCamelName %>)
    remove(index)
  }, [<%= struct.name.lowerCamelPluralName %>, remove])

  const removeForm = useCallback(() => {
    remove(editIndex)
  }, [remove, editIndex])

  const syncTarget = useCallback((target) => {
    setEditTarget(editTarget => ({
      ...editTarget,
      ...target
    }))
  }, [setEditTarget])

  return (
    <Container sx={{padding: 2}}>
      <<%= struct.name.pascalName %>DataTable
        items={<%= struct.name.lowerCamelPluralName %>}
        pageInfo={pageInfo}
        totalCount={totalCount}
        isLoading={isLoading}
        searchCondition={searchCondition}
        onChangePageInfo={changePageInfo}
        onChangeSearch={search}
        onOpenEntryForm={openEntryForm}
        onRemove={removeRow}
      />
      <Dialog open={entryFormOpen} onClose={() => setEntryFormOpen(false)}>
        <<%= struct.name.pascalName %>EntryForm
          target={editTarget!}
          isNew={editIndex === NEW_INDEX}
          open={entryFormOpen}
          setOpen={setEntryFormOpen}
          syncTarget={syncTarget}
          updated={reFetch}
          remove={removeForm}
        />
      </Dialog>
    </Container>
  )
}

export default <%= struct.name.pascalPluralName %>
