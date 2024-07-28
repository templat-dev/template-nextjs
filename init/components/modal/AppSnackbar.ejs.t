---
to: <%= rootDirectory %>/components/modal/AppSnackbar.tsx
force: true
---
import {Button, Snackbar} from '@mui/material'
import {atom, useAtomValue, useSetAtom} from 'jotai'
import React, {useMemo} from 'react'

export interface SnackbarState {
  open?: boolean
  text?: string
  actionText?: string
  action?: () => void
  timeout?: number | null
}

const SnackbarAtom = atom<SnackbarState>({open: false})

export const useSnackbar = (): [(props: Omit<SnackbarState, 'open'>) => void, () => void] => {
  const setProps = useSetAtom(SnackbarAtom)

  return [
    // showSnackbar
    (props: Omit<SnackbarState, 'open'>) => setProps({
      ...props,
      open: true
    }),
    // hideSnackbar
    () => setProps({
      open: false
    })
  ]
}

export const AppSnackbar = () => {
  const snackbar = useAtomValue(SnackbarAtom)
  const [, hideSnackbar] = useSnackbar()

  const action = useMemo(() => {
    if (!snackbar.actionText) {
      return null
    }
    return (
      <Button color="primary" size="small" onClick={() => {
        if (snackbar.action) {
          snackbar.action()
        }
        hideSnackbar()
      }}>
        {snackbar.actionText}
      </Button>
    )
  }, [snackbar, hideSnackbar])

  return (
    <Snackbar
      open={snackbar.open}
      autoHideDuration={snackbar.timeout}
      onClose={() => hideSnackbar()}
      message={snackbar.text}
      action={action}
      anchorOrigin={{vertical: 'bottom', horizontal: 'center'}}
    />
  )
}
