---
to: <%= rootDirectory %>/<%= projectName %>/components/modal/AppLoading.tsx
force: true
---
import {Backdrop, CircularProgress} from '@mui/material'
import {useRecoilValue} from 'recoil'
import {loadingState} from '@/state/App'

export const AppLoading = () => {
  const open = useRecoilValue(loadingState)

  return (
    <Backdrop sx={{color: '#fff', zIndex: (theme) => theme.zIndex.modal + 1}} open={open}>
      <CircularProgress color="primary"/>
    </Backdrop>
  )
}
