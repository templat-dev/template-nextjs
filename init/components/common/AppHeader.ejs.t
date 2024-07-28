---
to: <%= rootDirectory %>/components/common/AppHeader.tsx
force: true
---
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
import {AuthAtom} from '@/components/common/Auth'
<%_ } -%>
import Link from '@/components/Link'
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
import {firebaseAuth} from '@/lib/firebase'
import LogoutIcon from '@mui/icons-material/Logout'
<%_ } -%>
import MenuIcon from '@mui/icons-material/Menu'
import {
  AppBar,
  Box,
  Drawer,
  IconButton,
  List,
  ListItemButton,
  ListItemText,
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
  Stack,
<%_ } -%>
  Toolbar,
  Typography
} from '@mui/material'
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
import {useAtom} from 'jotai'
<%_ } -%>
import {useRouter} from 'next/router'
import * as React from 'react'
import {useCallback, useMemo, useState} from 'react'

const menus = [
  {
    title: 'Top',
    to: `/`
  },
  // メニュー
] as const

export const AppHeader = () => {
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
  const [auth, setAuth] = useAtom(AuthAtom)
<%_ } -%>
  const router = useRouter()

  const [open, setOpen] = useState(false)

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
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>

  const logout = useCallback(async () => {
    setAuth({firebaseUser: null})
    await firebaseAuth.signOut()
  }, [setAuth])
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
              templat-test-32-web
            </Typography>
          </Link>
          {currentPageTitle && (
            <Typography variant="subtitle2" component="h2" sx={{
              ml: 2,
              px: '8px',
              py: '4px',
              border: '1px solid',
              borderRadius: '4px',
              lineHeight: 1
            }}>{currentPageTitle}</Typography>
          )}
          <Box sx={{flexGrow: 1}}/>
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
          <Stack spacing={1} alignItems="center" direction="row">
            <Typography variant="subtitle2"
                        sx={{color: '#FFFFFF'}}>{auth?.firebaseUser?.displayName}</Typography>
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
            width: 240,
            boxSizing: 'border-box'
          }
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
  )
}