---
to: <%= rootDirectory %>/components/modal/AppSnackbar.tsx
force: true
---
'use client';

import { Alert, Snackbar } from '@mui/material';
import { atom, useAtom } from 'jotai';

export type SnackbarState = {
  open: boolean;
  message: string;
  severity?: 'success' | 'info' | 'warning' | 'error';
  autoHideDuration?: number;
};

export const SnackbarAtom = atom<SnackbarState>({
  open: false,
  message: '',
  severity: 'info',
  autoHideDuration: 6000,
});

export function AppSnackbar() {
  const [snackbar, setSnackbar] = useAtom(SnackbarAtom);

  const handleClose = (event?: React.SyntheticEvent | Event, reason?: string) => {
    if (reason === 'clickaway') {
      return;
    }
    setSnackbar({ ...snackbar, open: false });
  };

  return (
    <Snackbar
      open={snackbar.open}
      autoHideDuration={snackbar.autoHideDuration}
      onClose={handleClose}
      anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
    >
      <Alert 
        onClose={handleClose} 
        severity={snackbar.severity} 
        sx={{ width: '100%' }}
      >
        {snackbar.message}
      </Alert>
    </Snackbar>
  );
}
