---
to: <%= rootDirectory %>/components/modal/AppDialog.tsx
force: true
---
import {Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle} from '@mui/material'
import {atom, useAtomValue, useSetAtom} from 'jotai'
import React, {useCallback} from 'react'

interface DialogState {
  open?: boolean
  title?: string
  message?: string
  positiveText?: string
  neutralText?: string
  negativeText?: string
  positive?: () => void
  neutral?: () => void
  negative?: () => void
  close?: () => void
  persistent?: boolean
}

const DialogAtom = atom<DialogState>({open: false})

export const useDialog = (): [(props: Omit<DialogState, 'open'>) => void, () => void] => {
  const setProps = useSetAtom(DialogAtom)

  return [
    // showDialog
    (props: Omit<DialogState, 'open'>) => setProps({
      ...props,
      open: true
    }),
    // hideDialog
    () => setProps({
      open: false
    })
  ]
}

export const AppDialog = () => {
  const dialog = useAtomValue(DialogAtom)
  const [_, hideDialog] = useDialog()

  const positive = useCallback(() => {
    dialog.positive?.()
    dialog.close?.()
    hideDialog()
  }, [dialog.positive, dialog.close, hideDialog])

  const neutral = useCallback(() => {
    dialog.neutral?.()
    dialog.close?.()
    hideDialog()
  }, [dialog.neutral, dialog.close, hideDialog])

  const negative = useCallback(() => {
    dialog.negative?.()
    dialog.close?.()
    hideDialog()
  }, [dialog.negative, dialog.close, hideDialog])

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
          <Button onClick={negative}>{dialog.negativeText}</Button>
        )}
        <div style={{flexGrow: 1}}/>
        {dialog.neutralText && (
          <Button onClick={neutral}>{dialog.neutralText}</Button>
        )}
        <div style={{flexGrow: 1}}/>
        {dialog.positiveText && (
          <Button onClick={positive}>{dialog.positiveText}</Button>
        )}
      </DialogActions>
    </Dialog>
  )
}
