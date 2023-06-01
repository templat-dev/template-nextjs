---
to: "<%= entity.enable ? `${rootDirectory}/${projectName}/pages/${entity.name}/index.tsx` : null %>"
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
import {Model<%= h.changeCase.pascal(entity.name) %>, <%= h.changeCase.pascal(entity.name) %>Api} from '@/apis'
import {NEW_INDEX} from '@/components/common/Base'
import {GridPageInfo, INITIAL_GRID_PAGE_INFO} from '@/components/common/AppDataGrid'
import <%= h.changeCase.pascal(entity.name) %>DataTable from '@/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>DataTable'
import {
  INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION,
  <%= h.changeCase.pascal(entity.name) %>SearchCondition
} from '@/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>SearchForm'
import <%= h.changeCase.pascal(entity.name) %>EntryForm, {INITIAL_<%= h.changeCase.constant(entity.name) %>} from '@/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>EntryForm'

const <%= h.changeCase.pascal(entity.pluralName) %>: NextPage = () => {
  const router = useRouter()
  const showLoading = useSetRecoilState<boolean>(loadingState)
  const hideLoading = useResetRecoilState(loadingState)
  const showDialog = useSetRecoilState<DialogState>(dialogState)
  const showSnackbar = useSetRecoilState<SnackbarState>(snackbarState)

  /** 一覧表示用の配列 */
  const [<%= entity.pluralName %>, set<%= h.changeCase.pascal(entity.pluralName) %>] = useState<Model<%= h.changeCase.pascal(entity.name) %>[]>([])

  /** 一覧の表示ページ情報 */
  const [pageInfo, setPageInfo] = useState<GridPageInfo>(cloneDeep(INITIAL_GRID_PAGE_INFO))

  /** 一覧の合計件数 */
  const [totalCount, setTotalCount] = useState(0)

  /** 一覧の読み込み状態 */
  const [isLoading, setIsLoading] = useState<boolean>(false)

  /** 検索条件 */
  const [searchCondition, setSearchCondition] = useState<<%= h.changeCase.pascal(entity.name) %>SearchCondition>(cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION))

  /** 入力フォームの表示表示状態 (true: 表示, false: 非表示) */
  const [entryFormOpen, setEntryFormOpen] = useState<boolean>(false)

  /** 編集対象 */
  const [editTarget, setEditTarget] = useState<Model<%= h.changeCase.pascal(entity.name) %> | null>(null)

  /** 編集対象のインデックス */
  const [editIndex, setEditIndex] = useState<number>(-1)

  useEffect(() => {
    (async () => {
      await fetch()
    })()
    // eslint-disable-next-line
  }, [router.pathname])

  const fetch = useCallback(async (
    {searchCondition = INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION, pageInfo = INITIAL_GRID_PAGE_INFO}
      : { searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition, pageInfo: GridPageInfo }
      = {searchCondition: INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION, pageInfo: INITIAL_GRID_PAGE_INFO}
  ) => {
    setIsLoading(true)
    try {
      const data = await new <%= h.changeCase.pascal(entity.name) %>Api().search<%= h.changeCase.pascal(entity.name) %>({
        <%_ entity.listProperties.listExtraProperties.forEach(function(property, index){ -%>
<%#_ 通常の検索 -%>
        <%_ if ((property.type === 'string' || property.type === 'time' || property.type === 'bool' || property.type === 'number')  && property.searchType === 1) { -%>
        <%= property.name %>: searchCondition.<%= property.name %>.enabled ? searchCondition.<%= property.name %>.value : undefined,
<%#_ 配列の検索 -%>
        <%_ } else if ((property.type === 'array-string' || property.type === 'array-time' || property.type === 'array-bool' || property.type === 'array-number')  && property.searchType === 1) { -%>
        <%= property.name %>: searchCondition.<%= property.name %>.enabled ? [searchCondition.<%= property.name %>.value] : undefined,
<%#_ 範囲検索 -%>
        <%_ } else if ((property.type === 'time' || property.type === 'number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
        <%= property.name %>: searchCondition.<%= property.name %>.enabled ? searchCondition.<%= property.name %>.value : undefined,
        <%= property.name %>From: searchCondition.<%= property.name %>From.enabled ? searchCondition.<%= property.name %>From.value : undefined,
        <%= property.name %>To: searchCondition.<%= property.name %>To.enabled ? searchCondition.<%= property.name %>To.value : undefined,
<%#_ 配列の範囲検索 -%>
        <%_ } else if ((property.type === 'array-time' || property.type === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
        <%= property.name %>: searchCondition.<%= property.name %>.enabled ? [searchCondition.<%= property.name %>.value] : undefined,
        <%= property.name %>From: searchCondition.<%= property.name %>From.enabled ? searchCondition.<%= property.name %>From.value : undefined,
        <%= property.name %>To: searchCondition.<%= property.name %>To.enabled ? searchCondition.<%= property.name %>To.value : undefined,
        <%_ } -%>
        <%_ }) -%>
        limit: pageInfo.pageSize !== -1 ? pageInfo.pageSize : undefined,
<%_ if (entity.dbType === 'datastore') { -%>
        cursor: pageInfo.page !== 0 ? pageInfo.cursors[pageInfo.page - 1] : undefined,
        orderBy: pageInfo.sortModel.map(sm => `${sm.sort === 'desc' ? '-' : ''}${sm.field}`).join(',') || undefined
<%_ } else { -%>
        offset: pageInfo.page * pageInfo.pageSize,
        orderBy: page.sortModel.map(sm => `${snakeCase(sm.field)} ${sm.sort}`).join(',') || undefined
<%_ } -%>
      }).then(res => res.data)
<%_ if (entity.dbType === 'datastore') { -%>
      if (data.cursor) {
        const cursors = cloneDeep(pageInfo.cursors)
        cursors[pageInfo.page] = data.cursor
        setPageInfo({...pageInfo, cursors})
      }
<%_ } -%>
      set<%= h.changeCase.pascal(entity.pluralName) %>(data.<%= entity.pluralName %> || [])
      setTotalCount(data.count || 0)
    } finally {
      setIsLoading(false)
    }
  }, [])

  const reFetch = useCallback(async () => {
    await fetch({searchCondition, pageInfo})
  }, [fetch, searchCondition, pageInfo])

  const search = useCallback(async (searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition) => {
    setSearchCondition(searchCondition)
    await fetch({searchCondition, pageInfo})
  }, [fetch, pageInfo])

  const changePageInfo = useCallback(async (pageInfo: GridPageInfo) => {
    setPageInfo(pageInfo)
    await fetch({searchCondition, pageInfo})
  }, [fetch, searchCondition])

  const openEntryForm = useCallback((<%= entity.name %>?: Model<%= h.changeCase.pascal(entity.name) %>) => {
    if (!!<%= entity.name %>) {
      setEditTarget(cloneDeep(<%= entity.name %>))
      setEditIndex(<%= entity.pluralName %>.findIndex(item => item.id === <%= entity.name %>.id))
    } else {
      setEditTarget(cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>))
      setEditIndex(NEW_INDEX)
    }
    setEntryFormOpen(true)
  }, [<%= entity.pluralName %>])

  const remove = useCallback((index: number) => {
    showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        showLoading(true)
        try {
          await new <%= h.changeCase.pascal(entity.name) %>Api().delete<%= h.changeCase.pascal(entity.name) %>({id: <%= entity.pluralName %>[index].id!})
          setEntryFormOpen(false)
          await reFetch()
        } finally {
          hideLoading()
        }
        showSnackbar({text: '削除しました。'})
      }
    })
  }, [<%= entity.pluralName %>, setEntryFormOpen, reFetch, showDialog, showLoading, hideLoading, showSnackbar])

  const removeRow = useCallback((<%= entity.name %>: Model<%= h.changeCase.pascal(entity.name) %>) => {
    const index = <%= entity.pluralName %>.indexOf(<%= entity.name %>)
    remove(index)
  }, [<%= entity.pluralName %>, remove])

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
      <<%= h.changeCase.pascal(entity.name) %>DataTable
        items={<%= entity.pluralName %>}
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
        <<%= h.changeCase.pascal(entity.name) %>EntryForm
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

export default <%= h.changeCase.pascal(entity.pluralName) %>
