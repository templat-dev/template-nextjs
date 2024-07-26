---
to: <%= rootDirectory %>/utils/appUtils.ts
force: true
---
import {AxiosError} from 'axios'
import dayjs from 'dayjs'

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

  static formatErrorMessage(error: Error): string {
    let message = 'エラーが発生しました。'
    message = error.message ? `エラーが発生しました。\n${error.message}` : message
    if (error instanceof AxiosError) {
      message = error.response?.data?.error ? `エラーが発生しました。\n${error.response?.data?.error}` : message
    }
    return message
  }

  static formatTime(time: string): string {
    if (!time) return ''
    return dayjs(time).format(this.DATE_TIME_FORMAT)
  }

  static formatArray(items: any[]): string {
    if (!items) return ''
    const formattedValues = items.map(item => item ? item.toString() : '')
    return `[${formattedValues.join(',')}]`
  }

  static formatTimeArray(times: string[]): string {
    if (!times) return ''
    const formattedValues = times.map(time => time ? dayjs(time).format(this.DATE_TIME_FORMAT) : '')
    return `[${formattedValues.join(',')}]`
  }
}
