---
to: <%= rootDirectory %>/<%= projectName %>/pages/_app.tsx
force: true
---
import * as React from 'react'
import {useCallback, useEffect, useMemo, useState} from 'react'
import {AppProps} from 'next/app'
import {RecoilRoot} from 'recoil'
import {CacheProvider, EmotionCache} from '@emotion/react'
import {ThemeProvider} from '@mui/material/styles'
import {
  AppBar,
  Box,
  CssBaseline,
  Drawer,
  IconButton,
  List,
  ListItemButton,
  ListItemText,
  Stack,
  Toolbar,
  Typography
} from '@mui/material'
import MenuIcon from '@mui/icons-material/Menu'

import createEmotionCache from '@/styles/createEmotionCache'
import theme from '@/styles/theme'

import Link from '@/components/Link'
import {AppDialog} from '@/components/modal/AppDialog'
import {AppLoading} from '@/components/modal/AppLoading'
import {AppSnackbar} from '@/components/modal/AppSnackbar'
<%_ if (entity.plugins.includes('auth')) { -%>
import useAuth from "@/components/common/UseAuth"
import LogoutIcon from '@mui/icons-material/Logout'
import {getAuth} from "firebase/auth"
import {app} from "@/lib/firebase"
<%_ } -%>

// Client-side cache, shared for the whole session of the user in the browser.
const clientSideEmotionCache = createEmotionCache()

interface MyAppProps extends AppProps {
  emotionCache?: EmotionCache;
}

const drawerWidth = 240

const menus = [
  {
    title: 'Top',
    to: `/`
  },
  // メニュー
]

type Props = {
  children: JSX.Element;
};

export default function MyApp({Component, pageProps, router, emotionCache = clientSideEmotionCache}: MyAppProps): JSX.Element | null {
  const [open, setOpen] = useState(false)
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const activeMenu = useMemo(() => {
    return menus.find(menu => router.pathname === menu.to)
  }, [router.pathname])

  const currentPageTitle = useMemo(() => {
    if (router.pathname === '/' || !activeMenu) {
      return null
    }
    return activeMenu.title
  }, [router.pathname, activeMenu])

  const toggleDrawer = useCallback((open: boolean) => {
    setOpen(open)
  }, [])

  const AppHeader = () => {
<%_ if (entity.plugins.includes('auth')) { -%>
    const {auth, setAuth, isAuthed} = useAuth();
    const fbAuth = getAuth(app)

    const logout = useCallback(() => {
      fbAuth.signOut()
      setAuth({token: null, user: null})
    }, [])
<%_ } -%>

    return (
     <>
       <AppBar position="fixed">
         <Toolbar variant="dense">
           <IconButton color="inherit" onClick={() => toggleDrawer(true)} edge="start" sx={{mr: 1}}>
             <MenuIcon/>
           </IconButton>
           <Link href="/">
             <Typography variant="h6" component="h1" sx={{flexGrow: 1}} color="common.white">
               umafull
             </Typography>
           </Link>
           {currentPageTitle && (
             <Typography variant="subtitle2" component="h2" sx={{
               ml: 2,
               px: '8px',
               py: '4px',
               border: '1px solid',
               borderRadius: '4px',
               lineHeight: 1,
             }}>{currentPageTitle}</Typography>
           )}
           <Box sx={{ flexGrow: 1 }} />
<%_ if (entity.plugins.includes('auth')) { -%>
           <Stack spacing={1} alignItems="center" direction="row">
             <Typography variant="subtitle2"
                         sx={{color: '#FFFFFF'}}>{auth.user?.displayName}</Typography>
             <IconButton onClick={() => logout()} edge="start" sx={{
               mr: 1,
               color: '#FFFFFF'
             }}>
               <LogoutIcon/>
             </IconButton>
           </Stack>
<%_ } -%>
         </Toolbar>
       </AppBar>
       <Drawer
         open={open}
         onClose={() => toggleDrawer(false)}
         sx={{
           '& .MuiDrawer-paper': {
             width: drawerWidth,
             boxSizing: 'border-box',
           },
         }}>
         <List>
           {menus.map((menu, index) => (
             <ListItemButton key={index} component={Link} href={menu.to} selected={menu === activeMenu}
                             onClick={() => toggleDrawer(false)}>
               <ListItemText primary={menu.title}/>
             </ListItemButton>
           ))}
         </List>
       </Drawer>
     </>
  )}

<%_ if (entity.plugins.includes('auth')) { -%>
  const Auth = ({ children }: Props) => {
    const {setAuth, isAuthed} = useAuth();

    useEffect(() => {
      if (router.pathname === '/login') {
        return
      }
      if (!!isAuthed) {
        return
      }
      router.push('/login')
    }, [router.pathname, isAuthed])

    return !isAuthed && router.pathname !== '/login' ? (
      <Box>
        <Typography>Loading...</Typography>
      </Box>
    ): children;
  }
<%_ } -%>

  if (!mounted) return null;

  return (
    <RecoilRoot>
      <CacheProvider value={emotionCache}>
        <ThemeProvider theme={theme}>
          <CssBaseline/>
<%_ if (entity.plugins.includes('auth')) { -%>
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
    </RecoilRoot>
  )
}
