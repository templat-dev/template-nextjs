---
to: <%= rootDirectory %>/components/modal/AppLoading.tsx
force: true
---
'use client';

import { Backdrop, CircularProgress } from '@mui/material';
import { atom, useAtom } from 'jotai';

export const LoadingAtom = atom<boolean>(false);

export function AppLoading() {
  const [loading] = useAtom(LoadingAtom);

  return (
    <Backdrop
      sx={{ 
        color: '#fff', 
        zIndex: (theme) => theme.zIndex.drawer + 1000 
      }}
      open={loading}
    >
      <CircularProgress color="inherit" />
    </Backdrop>
  );
}
