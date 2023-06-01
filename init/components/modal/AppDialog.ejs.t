---
to: <%= rootDirectory %>/<%= projectName %>/components/modal/AppDialog.tsx
force: true
---
import React, {useCallback} from 'react'
import {Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle} from '@mui/material'
import {useRecoilValue, useResetRecoilState} from 'recoil'
import {dialogState} from '@/state/App'

export const AppDialog = () => {
  const dialog = useRecoilValue(dialogState)
  const _hideDialog = useResetRecoilState(dialogState)

  const hideDialog = useCallback(() => {
    if (dialog.close) {
      dialog.close()
    }
    _hideDialog()
  }, [dialog, _hideDialog])

  return (
    <Dialog
      open={!!dialog.open}
      onClose={() => hideDialog}
      onBackdropClick={() => {
        if (!dialog.persistent) {
          hideDialog()
        }
      }}
      maxWidth={'xs'}
      fullWidth
    >
      <DialogTitle>
        {dialog.title}
      </DialogTitle>
      <DialogContent>
        <DialogContentText>
          {dialog.message}
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        {dialog.negativeText && (
          <Button onClick={() => {
            if (dialog.negative) {
              dialog.negative()
            }
            hideDialog()
          }}>{dialog.negativeText}</Button>
        )}
        <div style={{flexGrow: 1}}/>
        {dialog.neutralText && (
          <Button onClick={() => {
            if (dialog.neutral) {
              dialog.neutral()
            }
            hideDialog()
          }}>{dialog.neutralText}</Button>
        )}
        <div style={{flexGrow: 1}}/>
        {dialog.positiveText && (
          <Button onClick={() => {
            if (dialog.positive) {
              dialog.positive()
            }
            hideDialog()
          }}>{dialog.positiveText}</Button>
        )}
      </DialogActions>
    </Dialog>
  )
}
