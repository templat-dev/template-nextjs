---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/app/login/page.tsx` : null %>"
force: true
---
'use client';

import * as React from 'react';
import { useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { Box, Grid, Stack, Typography } from '@mui/material';
import { GoogleAuthProvider } from 'firebase/auth';
import { firebaseAuthUI } from '@/lib/firebase';

const AUTH_UI_DEFAULT_CONFIG = {
  signInFlow: 'popup',
  signInOptions: [
    {
      provider: GoogleAuthProvider.PROVIDER_ID,
      scopes: []
    }
  ]
};

export default function Login() {
  const router = useRouter();
  const searchParams = useSearchParams();

  useEffect(() => {
    let signInSuccessUrl = '/';
    const redirectParam = searchParams.get('r');
    if (redirectParam) {
      signInSuccessUrl = redirectParam;
    }
    
    firebaseAuthUI.start('#firebaseui-auth-container', {
      ...AUTH_UI_DEFAULT_CONFIG,
      signInSuccessUrl
    });
  }, [searchParams]);

  return (
    <Grid container justifyContent="center">
      <Grid item md={6} sm={8} xs={12} sx={{
        p: '32px',
        mt: '32px',
        borderRadius: '4px',
        backgroundColor: 'rgba(0, 0, 0, 0.02)',
      }}>
        <Stack alignItems="center" sx={{flexGrow: 1}}>
          <Stack alignItems="center" sx={{mb: '16px'}}>
            <Box
              component="img"
              sx={{
                height: 120,
                width: 120
              }}
              alt="logo"
              src="/image/logo.png"
            />
          </Stack>
          <Stack alignItems="center">
            <Typography variant="h6" component="span">
              ログイン
            </Typography>
            <div id="firebaseui-auth-container"></div>
          </Stack>
        </Stack>
      </Grid>
    </Grid>
  );
} 