---
to: <%= rootDirectory %>/utils/appUtils.ts
force: true
---
import {DialogState} from '@/state/App'
import {AxiosError} from 'axios'
import dayjs from 'dayjs'
import {SetterOrUpdater} from 'recoil'

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

  static showApiErrorDialog = (error: Error, showDialog: SetterOrUpdater<DialogState>): any => {
    let message = '通信エラーが発生しました。\n再度実行してください。'
    message = error.message ? `エラーが発生しました。\n${error.message}` : message
    if (error instanceof AxiosError) {
      message = error.response?.data?.error ? `エラーが発生しました。\n${error.response?.data?.error}` : message
    }
    showDialog({
      title: 'エラー',
      message
    })
  }

  static formatArray(items: any[]): string {
    if (!items) return ''
    const formattedValues = items.map(item => item ? item.toString() : '')
    return `[${formattedValues.join(',')}]`
  }

  static formatTime(time: string): string {
    if (!time) return ''
    return dayjs(time).format(this.DATE_TIME_FORMAT)
  }

  static formatTimeArray(times: string[]): string {
    if (!times) return ''
    const formattedValues = times.map(time => time ? dayjs(time).format(this.DATE_TIME_FORMAT) : '')
    return `[${formattedValues.join(',')}]`
  }
}

