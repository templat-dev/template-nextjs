---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/components/common/UseAuth.tsx` : null %>"
force: true
---
import {useRecoilState} from 'recoil';
import {cloneDeep} from 'lodash-es'
import { authState } from '@/state/Auth'
import {useCallback, useEffect} from "react";
import {getAuth, onAuthStateChanged} from "firebase/auth";
import {app} from "@/lib/firebase";

const useAuth = () => {
  const [auth, setAuth] = useRecoilState(authState)
  const isAuthed = auth && auth.user

  useEffect(() => {
    const fbAuth = getAuth(app)
    return onAuthStateChanged(fbAuth, (user) => {
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
  };
}
export default useAuth