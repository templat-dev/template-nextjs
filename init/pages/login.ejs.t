---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/pages/login.tsx` : null %>"
force: true
---
import {NextPage} from "next";
import {useEffect} from "react";
import {Card, CardActions, CardContent, CardHeader, Grid, Stack} from "@mui/material";
import {useRecoilState} from "recoil";
import {authState, AuthState} from "@/state/Auth";
import Image from "next/image";
import * as React from "react";
import {
  getAuth,
  GoogleAuthProvider,
} from 'firebase/auth'
import { auth } from 'firebaseui'
import StyledFirebaseAuth from 'react-firebaseui/StyledFirebaseAuth'
import {app} from "@/lib/firebase";

const uiConfig: auth.Config = {
  signInFlow: 'popup',
  signInOptions: [
    GoogleAuthProvider.PROVIDER_ID,
  ],
  signInSuccessUrl: '/',
}

const Login: NextPage = () => {
  return (
    <Grid container direction="column" alignItems="center">
      <Grid item xs={6}>
        <Stack justifyContent="center" alignItems="center" sx={{flexGrow: 1, my: '36px', py: '24px', px: '24px', backgroundColor: theme => theme.palette.primary.main}}>
          <Image src="/image/logo.png" alt="logo" width="134px" height="135px"/>
        </Stack>
      </Grid>
      <Grid item xs={6}>
        <Card sx={{}}>
          <CardHeader title="ログイン"/>
          <CardContent>
          </CardContent>
          <CardActions>
            <StyledFirebaseAuth firebaseAuth={getAuth(app)} uiConfig={uiConfig} />
          </CardActions>
        </Card>
      </Grid>
    </Grid>
  )
}
export default Login
