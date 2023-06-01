---
to: <%= rootDirectory %>/<%= projectName %>/state/Auth.tsx
force: true
---
import {ModelUser} from '@/apis'
import {atom} from 'recoil'
import {User} from "firebase/auth";
import globalAxios, {AxiosRequestConfig} from 'axios'

const AUTH_INFO_KEY = 'authInfo'

export interface AuthState {
  token: string | null | undefined
  user: User | null | undefined
}

export const authState = atom<AuthState>({
  key: 'auth/authState',
  default: {
    token: null,
    user: null,
  },
  effects_UNSTABLE: [
    ({setSelf, onSet, trigger}) => {
      if (trigger === 'get' && typeof window !== "undefined" ) {
        const serializedAuthInfo = localStorage.getItem(AUTH_INFO_KEY)
        const authInfo: AuthState | undefined = serializedAuthInfo ? JSON.parse(serializedAuthInfo) : undefined
        if (authInfo && !!authInfo.user) {
          globalAxios.interceptors.request.use((config: AxiosRequestConfig) => {
            config.headers = Object.assign(
              {'Authorization': `Bearer ${authInfo.token}`},
              config.headers
            )
            return config
          })
          setSelf(authInfo)
        }
      }
      onSet((newValue, _, isReset) => {
        if (isReset) {
          localStorage.removeItem(AUTH_INFO_KEY)
        } else {
          globalAxios.interceptors.request.use((config: AxiosRequestConfig) => {
            config.headers = Object.assign(
              {'Authorization': `Bearer ${newValue.token}`},
              config.headers
            )
            return config
          })
          localStorage.setItem(AUTH_INFO_KEY, JSON.stringify(newValue))
        }
      })
      return () => {}
    }
  ]
})
