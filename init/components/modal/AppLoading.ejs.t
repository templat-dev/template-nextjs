---
to: <%= rootDirectory %>/components/modal/AppLoading.tsx
force: true
---
import {Backdrop, CircularProgress} from '@mui/material'
import {atom, useAtomValue, useSetAtom} from 'jotai'

const LoadingAtom = atom<boolean>(false)

export const useLoading = (): [() => void, () => void] => {
  const setProps = useSetAtom(LoadingAtom)

  return [
    // showLoading
    () => setProps(true),
    // hideLoading
    () => setProps(false)
  ]
}

export const AppLoading = () => {
  const open = useAtomValue(LoadingAtom)

  return (
    <Backdrop sx={{color: '#fff', zIndex: (theme) => theme.zIndex.modal + 1}} open={open}>
      <CircularProgress color="primary"/>
    </Backdrop>
  )
}
