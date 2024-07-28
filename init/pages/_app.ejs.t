---
to: <%= rootDirectory %>/pages/_app.tsx
force: true
---
import {AppHeader} from '@/components/common/AppHeader'
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
import {Auth} from '@/components/common/Auth'
<%_ } -%>
import {AppDialog} from '@/components/modal/AppDialog'
import {AppLoading} from '@/components/modal/AppLoading'
import {AppSnackbar} from '@/components/modal/AppSnackbar'
import createEmotionCache from '@/styles/createEmotionCache'
import theme from '@/styles/theme'
import {CacheProvider, EmotionCache} from '@emotion/react'
import {Box, CssBaseline, Toolbar} from '@mui/material'
import {ThemeProvider} from '@mui/material/styles'
import globalAxios from 'axios'
import {AppProps} from 'next/app'
import * as React from 'react'

// axiosにBASE_PATHを設定
if (process?.env?.NEXT_PUBLIC_API_BASE_PATH) {
  globalAxios.defaults.baseURL = process.env.NEXT_PUBLIC_API_BASE_PATH
}

// Client-side cache, shared for the whole session of the user in the browser.
const clientSideEmotionCache = createEmotionCache()

type MyAppProps = {
  emotionCache?: EmotionCache;
}
export default function MyApp({
                                Component,
                                pageProps,
                                router,
                                // @ts-ignore
                                emotionCache = clientSideEmotionCache
                              }: MyAppProps & AppProps) {

  return (
    <CacheProvider value={emotionCache}>
      <ThemeProvider theme={theme}>
        <CssBaseline/>
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
        <Auth>
          <Box sx={{display: 'flex'}}>
            <AppHeader/>
            <Box component="main" sx={{flexGrow: 1}}>
              <Toolbar variant="dense"/>
              <Component {...pageProps} />
            </Box>
            <AppDialog/>
            <AppLoading/>
            <AppSnackbar/>
          </Box>
        </Auth>
<%_ } else { -%>
        <Box sx={{display: 'flex'}}>
          <AppHeader/>
          <Box component="main" sx={{flexGrow: 1}}>
            <Toolbar variant="dense"/>
            <Component {...pageProps} />
          </Box>
          <AppDialog/>
          <AppLoading/>
          <AppSnackbar/>
        </Box>
<%_ } -%>
      </ThemeProvider>
    </CacheProvider>
  )
}
