---
to: <%= rootDirectory %>/<%= projectName %>/components/form/ArrayForm.tsx
force: true
---
import * as React from 'react'
import {ReactNode, useCallback} from 'react'
import {useSetRecoilState} from 'recoil'
import {Box, Fab, IconButton, Stack} from '@mui/material'
import AddIcon from '@mui/icons-material/Add'
import DeleteIcon from '@mui/icons-material/Delete'
import {dialogState, DialogState} from '@/state/App'

export interface ArrayFormProps<T, > {
  /** 編集対象 */
  items: T[]
  /** 編集対象同期コールバック */
  syncItems: (items: T[]) => void
  /** 単一の編集対象の初期値 */
  initial: T
  /** EntryForm描画メソッド */
  form: (editTarget: T, updatedForm: (item: T | undefined) => void) => ReactNode
}

export const ArrayForm = <T, >({items, syncItems, initial, form}: ArrayFormProps<T>) => {
  const showDialog = useSetRecoilState<DialogState>(dialogState)

  const addItem = useCallback(() => {
    if (!items) {
      syncItems([initial])
    } else {
      syncItems([...items, initial])
    }
  }, [items, syncItems, initial])

  const updatedForm = useCallback((index: number, updatedItem: T) => {
    syncItems(items.reduce<T[]>((newItems, item, i) => {
      if (index === i) {
        return [...newItems, updatedItem]
      }
      return [...newItems, item]
    }, []))
  }, [syncItems, items])

  const remove = useCallback((index: number) => {
    showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        syncItems(items.filter((_, i) => i !== index))
      }
    })
  }, [syncItems, items, showDialog])

  return (
    <>
      <Stack direction="row" sx={{p: '12px'}}>
        <Box sx={{flexGrow: 1}}/>
        <Fab color="primary" size="small" onClick={() => addItem()}>
          <AddIcon/>
        </Fab>
      </Stack>
      <Box>
        {items.map((item, index) => (
          <Stack key={index} direction="row" justifyContent="space-between" alignItems="center"
                 spacing={2} sx={{p: '12px', pt: 0}}>
            {form(item, value => updatedForm(index, (value as T)))}
            <IconButton onClick={() => remove(index)} sx={{width: '32px', height: '32px'}}>
              <DeleteIcon/>
            </IconButton>
          </Stack>
        ))}
      </Box>
    </>
  )
}
export default ArrayForm
