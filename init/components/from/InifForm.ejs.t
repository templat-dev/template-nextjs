---
to: <%= rootDirectory %>/<%= projectName %>/components/form/InitForm.tsx
force: true
---
import * as React from 'react'
import {DialogContent, Fab, Stack} from '@mui/material'
import AddIcon from '@mui/icons-material/Add'

export interface InitFormProps<T> {
  /** 編集対象同期コールバック */
  syncTarget: (target: T) => void
  /** 編集対象の初期値 */
  initial: T
}

export const InitForm = <T, >({syncTarget, initial}: InitFormProps<T>) => {
  return (
    <DialogContent>
      <Stack direction="row">
        <Fab color="primary" size="small" onClick={() => syncTarget(initial)}>
          <AddIcon/>
        </Fab>
      </Stack>
    </DialogContent>
  )
}
export default InitForm
