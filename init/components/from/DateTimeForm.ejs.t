---
to: <%= rootDirectory %>/components/form/DateTimeForm.tsx
force: true
---
import * as React from 'react'
import {Grid, IconButton} from '@mui/material'
import ClearIcon from '@mui/icons-material/Clear'
import {LocalizationProvider, MobileDatePicker, MobileTimePicker} from '@mui/x-date-pickers'
import {AdapterDateFns} from '@mui/x-date-pickers/AdapterDateFns'
import {startOfDay} from 'date-fns'
import ja from 'date-fns/locale/ja'

export interface DateTimeFormProps {
  /** 画面表示ラベル */
  label: string
  /** 編集対象 */
  dateTime: Date | null
  /** 編集状態 (true: 編集不可, false: 編集可能) */
  disabled?: boolean
  /** 変更コールバック */
  syncDateTime: (dateTime: Date | null) => void
}

export const DateTimeForm = ({label, dateTime, disabled = false, syncDateTime}: DateTimeFormProps) => {
  const clearDate = () => {
    syncDateTime(null)
  }

  const clearTime = () => {
    if (!dateTime) {
      return
    }
    syncDateTime(startOfDay(dateTime))
  }

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={ja}>
      <Grid container spacing={1} alignItems="center">
        <Grid item xs={5}>
          <MobileDatePicker
            closeOnSelect
            label={label}
            value={dateTime}
            disabled={disabled}
            format="yyyy/MM/dd"
            onChange={(newValue: Date | null) => {
              syncDateTime(newValue)
            }}
          />
        </Grid>
        <Grid item xs={1}>
          <IconButton
            edge="start"
            size="small"
            disabled={!dateTime}
            onClick={() => clearDate()}
          >
            <ClearIcon/>
          </IconButton>
        </Grid>
        <Grid item xs={5}>
          <MobileTimePicker
            closeOnSelect
            value={dateTime}
            disabled={disabled}
            onChange={(newValue: Date | null) => {
              syncDateTime(newValue)
            }}
          />
        </Grid>
        <Grid item xs={1}>
          <IconButton
            edge="start"
            size="small"
            disabled={!dateTime}
            onClick={() => clearTime()}
          >
            <ClearIcon/>
          </IconButton>
        </Grid>
      </Grid>
    </LocalizationProvider>
  )
}
export default DateTimeForm