---
to: <%= rootDirectory %>/<%= projectName %>/state/App.tsx
force: true
---
import {atom, DefaultValue, selector} from 'recoil'

export interface DialogState {
  open?: boolean
  title: string
  message: string
  positiveText?: string
  neutralText?: string
  negativeText?: string
  positive?: () => void
  neutral?: () => void
  negative?: () => void
  close?: () => void
  persistent?: boolean
}

export interface SnackbarState {
  open?: boolean
  text?: string
  actionText?: string
  action?: () => void
  timeout?: number | null
}

const _loadingState = atom<boolean>({
  key: 'app/_loading',
  default: false
})

export const loadingState = selector<boolean>({
  key: 'app/loading',
  get: ({get}) => get(_loadingState),
  set: ({set}, newValue) => set(_loadingState, newValue)
})

const _dialogState = atom<DialogState>({
  key: 'app/_dialog',
  default: {
    open: false,
    title: '',
    message: '',
    positiveText: 'OK',
    neutralText: '',
    negativeText: '',
    positive: () => {},
    neutral: () => {},
    negative: () => {},
    close: () => {},
    persistent: false
  },
})

export const dialogState = selector<DialogState>({
  key: 'app/dialog',
  get: ({get}) => get(_dialogState),
  set: ({set}, newValue) =>
    set(_dialogState, newValue instanceof DefaultValue ? newValue :
      {
        open: true,
        positiveText: 'OK',
        neutralText: '',
        negativeText: '',
        positive: () => {},
        neutral: () => {},
        negative: () => {},
        close: () => {},
        persistent: false,
        ...newValue,
      }
    )
})

const _snackbarState = atom<SnackbarState>({
  key: 'app/_snackbar',
  default: {
    open: false,
    text: '',
    actionText: '',
    action: () => {},
    timeout: 2000
  },
})

export const snackbarState = selector<SnackbarState>({
  key: 'app/snackbar',
  get: ({get}) => get(_snackbarState),
  set: ({set}, newValue) =>
    set(_snackbarState, newValue instanceof DefaultValue ? newValue :
      {
        open: true,
        text: '',
        actionText: '',
        action: () => {},
        timeout: 2000,
        ...newValue,
      }
    )
})
