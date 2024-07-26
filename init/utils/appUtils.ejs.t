---
to: <%= rootDirectory %>/utils/appUtils.ts
force: true
---
import {dialogState, DialogState} from '@/state/App'
import {AxiosError} from 'axios'
import dayjs from 'dayjs'
import {useSetRecoilState} from 'recoil'

export default class AppUtils {
  static readonly DATE_TIME_FORMAT = 'YYYY-MM-DD HH:mm'

  static wait = (ms: number): Promise<void> => new Promise(r => setTimeout(r, ms))

  static generateRandomString(length: number) {
    const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    const charactersLength = characters.length
    let result = ''
    for (let i = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength))
    }
    return result
  }

  static showApiErrorDialog = (error: Error): any => {
    const showDialog = useSetRecoilState<DialogState>(dialogState)
    let message = '通信エラーが発生しました。\n再度実行してください。'
    message = error.message ? `エラーが発生しました。\n${error.message}` : message
    if (error instanceof AxiosError) {
      message = error.response?.data?.error ? `エラーが発生しました。\n${error.response?.data?.error}` : message
    }
    showDialog({
      title: 'エラー',
      message
    })
    return Promise.reject(error)
  }

  static toStringArray(array: any[]): string {
    if (!array) return ''
    let result = '['
    for (let idx = 0; idx < array.length; idx++) {
      const item = array[idx]
      if (idx !== 0) {
        result = `${result},`
      }
      result = `${result}${item.toString()}`
    }
    result = `${result}]`
    return result
  }

  static toStringTimeArray(array: string[]): string {
    if (!array) return ''
    let result = '['
    for (let idx = 0; idx < array.length; idx++) {
      const formatted = dayjs(array[idx]).format(this.DATE_TIME_FORMAT)
      if (idx !== 0) {
        result = `${result},`
      }
      result = `${result}${formatted}`
    }
    result = `${result}]`
    return result
  }
}
