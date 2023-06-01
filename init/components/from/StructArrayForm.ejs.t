---
to: <%= rootDirectory %>/<%= projectName %>/components/form/StructArrayForm.tsx
force: true
---
import * as React from 'react'
import {ReactNode, useCallback, useState} from 'react'
import {cloneDeep} from 'lodash-es'
import {useSetRecoilState} from 'recoil'
import {Dialog} from '@mui/material'
import {dialogState, DialogState} from '@/state/App'
import {NEW_INDEX} from '@/components/common/Base'
import {GridPageInfo, INITIAL_GRID_PAGE_INFO} from '@/components/common/AppDataGrid'

export interface StructArrayFormProps<T, > {
  /** 編集対象 */
  items: T[]
  /** 編集対象同期コールバック */
  syncItems: (items: T[]) => void
  /** 単一の編集対象の初期値 */
  initial: T
  /** DataTable描画メソッド */
  table: (items: T[], pageInfo: GridPageInfo, changePageInfo: (pageInfo: GridPageInfo) => void, openEntryForm: () => void, removeRow: (item: T) => void) => ReactNode
  /** EntryForm描画メソッド */
  form: (editIndex: number, open: boolean, setOpen: (open: boolean) => void, editTarget: T, syncTarget: (item: T) => void, updatedForm: () => void, removeForm: () => void) => ReactNode
}

export const StructArrayForm = <T, >({items, syncItems, initial, table, form}: StructArrayFormProps<T>) => {
  const showDialog = useSetRecoilState<DialogState>(dialogState)

  /** 編集対象Model */
  const [editTarget, setEditTarget] = useState<T | null>(null)

  /** 編集対象のインデックス番号 */
  const [editIndex, setEditIndex] = useState<number>(0)

  /** 編集ダイアログ表示状態 (true: 表示, false: 非表示) */
  const [entryFormOpen, setEntryFormOpen] = useState<boolean>(false)

  /** 表示ページ情報 */
  const [pageInfo, setPageInfo] = useState<GridPageInfo>(cloneDeep(INITIAL_GRID_PAGE_INFO))

  const openEntryForm = useCallback((item?: T) => {
    if (!!item) {
      setEditTarget(cloneDeep(item))
      setEditIndex(items.indexOf(item))
    } else {
      setEditTarget(cloneDeep(initial))
      setEditIndex(NEW_INDEX)
    }
    setEntryFormOpen(true)
  }, [items, initial])

  const updatedForm = useCallback(() => {
    if (!editTarget) {
      return
    }
    if (!items) {
      syncItems([editTarget])
    } else if (editIndex === NEW_INDEX) {
      syncItems([...items, editTarget])
    } else {
      syncItems(items.reduce<T[]>((newItems, item, i) => {
        if (editIndex === i) {
          return [...newItems, editTarget]
        }
        return [...newItems, item]
      }, []))
    }
  }, [editTarget, items, editIndex, syncItems])

  const remove = useCallback((index: number) => {
    showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        syncItems(items.filter((_, i) => i !== index))
        setEntryFormOpen(false)
      }
    })
  }, [syncItems, items, showDialog])

  const removeRow = useCallback((item: T) => {
    const index = items.indexOf(item)
    remove(index)
  }, [items, remove])

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
    <>
      {table(items, pageInfo, setPageInfo, openEntryForm, removeRow)}
      <Dialog open={entryFormOpen} onClose={() => setEntryFormOpen(false)}>
        {editTarget && (
          form(editIndex, entryFormOpen, setEntryFormOpen, editTarget, syncTarget, updatedForm, removeForm)
        )}
      </Dialog>
    </>
  )
}
export default StructArrayForm
