---
to: <%= rootDirectory %>/components/form/DateTimeForm.tsx
force: true
---
import ClearIcon from '@mui/icons-material/Clear'
import {Grid, IconButton} from '@mui/material'
import {LocalizationProvider, MobileDatePicker, MobileTimePicker} from '@mui/x-date-pickers'
import {AdapterDayjs} from '@mui/x-date-pickers/AdapterDayjs'
import dayjs, {Dayjs} from 'dayjs'
import 'dayjs/locale/ja'
import * as React from 'react'

type DateTimeFormProps = {
  /** 画面表示ラベル */
  label: string
  /** 編集対象 */
  dateTime?: string
  /** 変更コールバック */
  syncDateTime: (dateTime?: string) => void
  /** 編集状態 (true: 編集不可, false: 編集可能) */
  disabled?: boolean
  /** 時刻表示状態 (true: 日付のみ, false: 日付と時刻) */
  onlyDate?: boolean
  /** クリア操作可否 (true: クリア可能, false: クリア不可) */
  clearable?: boolean
}
export const DateTimeForm = ({
                               label,
                               dateTime,
                               syncDateTime,
                               disabled = false,
                               onlyDate = false,
                               clearable = false
                             }: DateTimeFormProps) => {
  const clearDate = () => {
    syncDateTime(undefined)
  }

  const clearTime = () => {
    if (!dateTime) {
      return
    }
    syncDateTime(dayjs(dateTime).startOf('day').format())
  }

  return (
    <LocalizationProvider dateAdapter={AdapterDayjs} adapterLocale="ja">
      <Grid container spacing={1} alignItems="center">
        <Grid container xs={6} alignItems="center">
          <MobileDatePicker<Dayjs>
            closeOnSelect
            label={label}
            value={dateTime ? dayjs(dateTime) : null}
            disabled={disabled}
            format="YYYY/MM/DD"
            onChange={(newValue) => {
              syncDateTime(newValue?.format())
            }}
          />
          <IconButton
            edge="start"
            size="small"
            disabled={!dateTime}
            onClick={() => clearDate()}
          >
            <ClearIcon/>
          </IconButton>
        </Grid>
        {!onlyDate && (
          <Grid container xs={6}>
            <MobileTimePicker<Dayjs>
              closeOnSelect
              value={dateTime ? dayjs(dateTime) : null}
              disabled={disabled}
              onChange={(newValue) => {
                syncDateTime(newValue?.format())
              }}
            />
            <IconButton
              edge="start"
              size="small"
              disabled={!dateTime}
              onClick={() => clearTime()}
            >
              <ClearIcon/>
            </IconButton>
          </Grid>
        )}
      </Grid>
    </LocalizationProvider>
  )
}
export default DateTimeForm
