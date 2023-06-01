---
to: <%= rootDirectory %>/<%= projectName %>/components/form/DateTimeForm.tsx
force: true
---
import * as React from 'react'
import {DatePicker, LocalizationProvider, TimePicker} from '@mui/lab';
import {Grid, IconButton, TextField} from '@mui/material';
import ClearIcon from '@mui/icons-material/Clear'
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import {startOfDay} from 'date-fns';

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
    <LocalizationProvider dateAdapter={AdapterDateFns}>
      <Grid container spacing={1} alignItems="center">
        <Grid item xs={5}>
          <DatePicker
            label={label}
            value={dateTime}
            disabled={disabled}
            clearable
            inputFormat="yyyy/MM/dd"
            mask="____/__/__"
            onChange={(newValue: Date | null) => {
              syncDateTime(newValue);
            }}
            renderInput={(params: any) => <TextField {...params} />}
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
          <TimePicker
            value={dateTime}
            disabled={disabled}
            onChange={(newValue: Date | null) => {
              syncDateTime(newValue)
            }}
            renderInput={(params) => <TextField {...params} />}
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