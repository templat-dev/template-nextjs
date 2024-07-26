---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/${project.buildConfig.webPageRoot}${struct.name.lowerCamelName}/index.tsx` : null %>"
force: true
---
import {Model<%= struct.name.pascalName %>, <%= struct.name.pascalName %>Api, <%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request} from '@/apis'
import {GridPageInfo, INITIAL_GRID_PAGE_INFO} from '@/components/common/AppDataGrid'
import {NEW_INDEX} from '@/components/common/Base'
import <%= struct.name.pascalName %>DataTable from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable'
import <%= struct.name.pascalName %>EntryForm from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm'
import {INITIAL_<%= struct.name.upperSnakeName %>, INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION} from '@/initials/<%= struct.name.pascalName %>Initials'
import {dialogState, DialogState, loadingState, snackbarState, SnackbarState} from '@/state/App'
import {Container, Dialog} from '@mui/material'
import {cloneDeep} from 'lodash-es'
import {NextPage} from 'next'
import {useRouter} from 'next/router'
import * as React from 'react'
import {useCallback, useEffect, useState} from 'react'
import {useResetRecoilState, useSetRecoilState} from 'recoil'
import {Writable} from 'type-fest'

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
  const [searchCondition, setSearchCondition] = useState<Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>>(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))

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
      : { searchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>, pageInfo: GridPageInfo }
      = {searchCondition: INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo: INITIAL_GRID_PAGE_INFO}
  ) => {
    setIsLoading(true)
    try {
      const data = await new <%= struct.name.pascalName %>Api().search<%= struct.name.pascalName %>({
        <%_ struct.fields.forEach(function(field, index){ -%>
<%#_ 通常の検索 -%>
        <%_ if ((field.listType === 'string' || field.listType === 'time' || field.listType === 'bool' || field.listType === 'number')  && field.searchType === 1 && field.name.lowerCamelName != 'id') { -%>
        <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> || undefined,
<%#_ 配列の検索 -%>
        <%_ } else if ((field.listType === 'array-string' || field.listType === 'array-time' || field.listType === 'array-bool' || field.listType === 'array-number')  && field.searchType === 1) { -%>
        <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> ? [searchCondition.<%= field.name.lowerCamelName %>] : undefined,
<%#_ 範囲検索 -%>
        <%_ } else if ((field.listType === 'time' || field.listType === 'number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
        <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> || undefined,
        <%= field.name.lowerCamelName %>From: searchCondition.<%= field.name.lowerCamelName %>From || undefined,
        <%= field.name.lowerCamelName %>To: searchCondition.<%= field.name.lowerCamelName %>To || undefined,
<%#_ 配列の範囲検索 -%>
        <%_ } else if ((field.listType === 'array-time' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
        <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> ? [searchCondition.<%= field.name.lowerCamelName %>] : undefined,
        <%= field.name.lowerCamelName %>From: searchCondition.<%= field.name.lowerCamelName %>From || undefined,
        <%= field.name.lowerCamelName %>To: searchCondition.<%= field.name.lowerCamelName %>To || undefined,
        <%_ } -%>
        <%_ }) -%>
        limit: pageInfo.pageSize !== -1 ? pageInfo.pageSize : undefined,
<%_ if (project.dbType === 'datastore') { -%>
        cursor: pageInfo.page !== 0 ? pageInfo.cursors[pageInfo.page - 1] : undefined,
        orderBy: pageInfo.sortModel.map(sm => `${sm.sort === 'desc' ? '-' : ''}${sm.field}`).join(',') || undefined
<%_ } else { -%>
        offset: pageInfo.page * pageInfo.pageSize,
        orderBy: pageInfo.sortModel.map(sm => `${sm.field} ${sm.sort}`).join(',') || undefined
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

  const search = useCallback(async (searchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>) => {
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

  const syncTarget = useCallback((target: Model<%= struct.name.pascalName %>) => {
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
