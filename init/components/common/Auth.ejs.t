---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/components/common/Auth.ts` : null %>"
force: true
---
import {firebaseAuth} from '@/lib/firebase'
import {Backdrop, CircularProgress} from '@mui/material'
import globalAxios from 'axios'
import {onAuthStateChanged, User} from 'firebase/auth'
import {atom, useAtom} from 'jotai'
import {cloneDeep} from 'lodash-es'
import {useRouter} from 'next/router'
import * as React from 'react'
import {ReactElement, useEffect, useState} from 'react'

export interface AuthState {
  firebaseUser: User | null
}

export const AuthAtom = atom<AuthState>({
  firebaseUser: null
})

export const Auth = ({children}: { children: ReactElement }) => {
  const [auth, setAuth] = useAtom(AuthAtom)
  const router = useRouter()

  const [firebaseLoaded, setFirebaseLoaded] = useState(false)

  useEffect(() => {
    if (!firebaseLoaded || router.pathname === '/login' || !!auth.firebaseUser) {
      return
    }
    router.push(`/login?r=${encodeURIComponent(router.asPath)}`)
  }, [firebaseLoaded, router.pathname, auth])

  useEffect(() => {
    return onAuthStateChanged(firebaseAuth, (user) => {
      (async () => {
        if (user) {
          globalAxios.interceptors.request.use(async request => {
            request.headers.common = {'Authorization': `Bearer ${await user.getIdToken()}`}
            return request
          })
        }
        setAuth({
          firebaseUser: cloneDeep(user)
        })
        setFirebaseLoaded(true)
      })()
    })
  }, [])

  if (router.pathname !== '/login' && (!firebaseLoaded || !auth.firebaseUser)) {
    return (
      <Backdrop open={true} sx={{backgroundColor: '#FFFFFF'}}>
        <CircularProgress color="primary"/>
      </Backdrop>
    )
  }
  return children
}
