---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/components/common/UseAuth.tsx` : null %>"
force: true
---
import {useEffect} from 'react'
import {cloneDeep} from 'lodash-es'
import {useRecoilState} from 'recoil'
import {authState} from '@/state/Auth'
import {onAuthStateChanged} from 'firebase/auth'
import {firebaseAuth} from '@/lib/firebase'

const useAuth = () => {
  const [auth, setAuth] = useRecoilState(authState)
  const isAuthed = auth && auth.user

  useEffect(() => {
    return onAuthStateChanged(firebaseAuth, (user) => {
      (async () => {
        let token: string | null = null
        if (!!user) {
          token = await user.getIdToken().then(res => res)
        }
        const authInfo = {
          token,
          user: cloneDeep(user)
        }
        setAuth(authInfo)
      })()
    })
  }, [setAuth])

  return {
    auth,
    isAuthed,
    setAuth,
  }
}
export default useAuth