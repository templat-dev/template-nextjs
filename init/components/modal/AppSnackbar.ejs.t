---
to: <%= rootDirectory %>/<%= projectName %>/components/modal/AppSnackbar.tsx
force: true
---
import React, {useMemo} from 'react'
import {useRecoilValue, useResetRecoilState} from 'recoil'
import {Button, Snackbar} from '@mui/material'
import {snackbarState} from '@/state/App'

export const AppSnackbar = () => {
  const snackbar = useRecoilValue(snackbarState)
  const hideSnackbar = useResetRecoilState(snackbarState)

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
