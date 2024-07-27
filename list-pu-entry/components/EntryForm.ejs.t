---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.tsx
---
import {<%_ if (struct.structType !== 'struct') { -%><%= struct.name.pascalName %>Api, <% } -%>Model<%= struct.name.pascalName %>} from '@/apis'
<%_ if (struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime) { -%>
import ArrayForm from '@/components/form/ArrayForm'
<%_ } -%>
<%_ if (struct.exists.edit.time || struct.exists.edit.arrayTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm'
<%_ } -%>
<%_ if (struct.exists.edit.struct || struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime || struct.exists.edit.arrayStruct) { -%>
import Expansion from '@/components/form/Expansion'
<%_ } -%>
<%_ if (struct.exists.edit.image) { -%>
import ImageForm from '@/components/form/ImageForm'
<%_ } -%>
<%_ if (struct.exists.edit.arrayImage) { -%>
import ImageArrayForm from '@/components/form/ImageArrayForm'
<%_ } -%>
<%_ if (struct.exists.edit.struct) { -%>
import InitForm from '@/components/form/InitForm'
<%_ } -%>
<%_ if (struct.exists.edit.arrayStruct) { -%>
import StructArrayForm from '@/components/form/StructArrayForm'
<%_ } -%>
<%_ const importStructTableSet = new Set() -%>
<%_ const importStructFormSet = new Set() -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct') { -%>
    <%_ if (!importStructTableSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>DataTable from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>DataTable'
      <%_ importStructTableSet.add(field.structName.pascalName) -%>
    <%_ } -%>
    <%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>EntryForm from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>EntryForm'
import {INITIAL_<%= field.structName.upperSnakeName %>} from '@/initials/<%= field.structName.pascalName %>Initials'
      <%_ importStructFormSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (field.editType === 'struct') { -%>
    <%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>EntryForm from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>EntryForm'
import {INITIAL_<%= field.structName.upperSnakeName %>} from '@/initials/<%= field.structName.pascalName %>Initials'
      <%_ importStructFormSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>
<%_ if (struct.structType !== 'struct') { -%>
import {dialogState, DialogState, loadingState} from '@/state/App'
<%_ } else { -%>
import {dialogState, DialogState} from '@/state/App'
<%_ } -%>
import AppUtils from '@/utils/appUtils'
import {yupResolver} from '@hookform/resolvers/yup'
import {
  Button,
  DialogActions,
  DialogContent,
  DialogTitle,
<%_ if (struct.exists.edit.bool || struct.exists.edit.arrayBool) { -%>
  FormControl,
  FormControlLabel,
  FormHelperText,
<%_ } -%>
  Grid,
<%_ if (struct.exists.edit.bool || struct.exists.edit.arrayBool) { -%>
  Switch,
<%_ } -%>
<%_ if (struct.exists.edit.text || struct.exists.edit.textArea || struct.exists.edit.number || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayNumber) { -%>
  TextField,
<%_ } -%>
} from '@mui/material'
<%_ if (struct.exists.edit.time || struct.exists.edit.arrayTime) { -%>
import dayjs from 'dayjs'
<%_ } -%>
<%_ if (struct.exists.edit.struct) { -%>
import {cloneDeep} from 'lodash-es'
<%_ } -%>
import * as React from 'react'
import {useCallback, useMemo} from 'react'
<%_ if (struct.exists.edit.bool || struct.exists.edit.arrayBool) { -%>
import {Controller, useForm} from 'react-hook-form'
<%_ } else { -%>
import {useForm} from 'react-hook-form'
<%_ } -%>
<%_ if (struct.structType !== 'struct') { -%>
import {useResetRecoilState, useSetRecoilState} from 'recoil'
<%_ } else { -%>
import {useSetRecoilState} from 'recoil'
<%_ } -%>
import * as yup from 'yup'

export const <%= struct.name.lowerCamelName %>Schema = yup.object({
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType.startsWith('array')) { -%>
  <%= field.name.lowerCamelName %>: yup.array().of(yup.mixed()),
  <%_ } else if (field.editType !== 'none') { -%>
  <%= field.name.lowerCamelName %>: yup.mixed(),
  <%_ } -%>
<%_ }) -%>
})
export type <%= struct.name.pascalName %>Schema = yup.InferType<typeof <%= struct.name.lowerCamelName %>Schema>

type <%= struct.name.pascalName %>EntryFormProps = {
  /** 表示状態 */
  open?: boolean
  /** 表示状態設定コールバック */
  setOpen?: (open: boolean) => void,
  /** 編集対象 */
  target: Model<%= struct.name.pascalName %>,
  /** 編集対象同期コールバック */
  syncTarget: (target: Model<%= struct.name.pascalName %>) => void,
  /** 表示方式 (true: 埋め込み, false: ダイアログ) */
  isEmbedded?: boolean,
  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  hasParent?: boolean,
<%_ if (struct.structType === 'struct') { -%>
  /** 編集状態 (true: 新規, false: 更新) */
  isNew?: boolean,
<%_ } -%>
  /** 更新コールバック */
  updated?: () => void,
  /** 削除コールバック */
  remove?: () => void
}
const <%= struct.name.pascalName %>EntryForm = (props: <%= struct.name.pascalName %>EntryFormProps) => {
  const {
    open = true,
    setOpen = () => {},
    target,
    syncTarget,
    isEmbedded = false,
    hasParent = false,
<%_ if (struct.structType === 'struct') { -%>
    isNew = true,
<%_ } -%>
    updated = () => {},
    remove = () => {}
  } = props

<%_ if (struct.structType !== 'struct') { -%>
  const isNew = useMemo(() => {
    return !target.id
  }, [target])

  const showLoading = useSetRecoilState<boolean>(loadingState)
  const hideLoading = useResetRecoilState(loadingState)
<%_ } -%>
  const showDialog = useSetRecoilState<DialogState>(dialogState)

  const {
    register,
    formState: {errors},
    control,
    handleSubmit
  } = useForm<<%= struct.name.pascalName %>Schema>({
    mode: 'all',
    resolver: yupResolver(<%= struct.name.lowerCamelName %>Schema),
  })

  const close = useCallback(() => {
    if (!isEmbedded) {
      setOpen(false)
    }
  }, [isEmbedded, setOpen])

<%_ if (struct.structType !== 'struct') { -%>
  const save = useCallback(async () => {
    if (hasParent) {
      // 親要素側で保存
      updated()
      return
    }
    showLoading(true)
    try {
      if (isNew) {
        // 新規の場合
        await new <%= struct.name.pascalName %>Api().create<%= struct.name.pascalName %>({
          body: target
        })
      } else {
        // 更新の場合
        await new <%= struct.name.pascalName %>Api().update<%= struct.name.pascalName %>({
          id: target.id!,
          body: target
        })
      }
      close()
    } catch (e: any) {
      showDialog({
        title: 'エラー',
        message: AppUtils.formatErrorMessage(e)
      })
    } finally {
      hideLoading()
    }
    updated()
  }, [hasParent, isNew, target, close, updated, showLoading, hideLoading])
<%_ } -%>
<%_ if (struct.structType === 'struct') { -%>
  const save = useCallback(async () => {
    updated()
    close()
  }, [updated, close])
<%_ } -%>

  const validateError = useCallback(() => {
    showDialog({
      title: 'エラー',
      message: '入力項目を確認して下さい。',
    })
  }, [])

  <%_ struct.fields.forEach(function (field, key) { -%>
    <%_ if (field.editType === 'none') { return } -%>
  const <%= field.name.lowerCamelName %>Form = useMemo(() => (
    <%_ if (field.editType === 'string' && field.name.lowerCamelName === 'id') { -%>
    <TextField
      error={!!errors.<%= field.name.lowerCamelName %>}
      helperText={errors.<%= field.name.lowerCamelName %>?.message?.toString()}
      disabled={!isNew}
      margin="dense"
      id="<%= field.name.lowerCamelName %>"
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      type="text"
      value={target.<%= field.name.lowerCamelName %> || ''}
      fullWidth
      variant="standard"
      {...register('<%= field.name.lowerCamelName %>', {
        onChange: e => syncTarget({<%= field.name.lowerCamelName %>: e.target.value})
      })}
    />
    <%_ } -%>
    <%_ if (field.editType === 'string' && field.name.lowerCamelName !== 'id') { -%>
    <TextField
      error={!!errors.<%= field.name.lowerCamelName %>}
      helperText={errors.<%= field.name.lowerCamelName %>?.message?.toString()}
      margin="dense"
      id="<%= field.name.lowerCamelName %>"
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      type="text"
      value={target.<%= field.name.lowerCamelName %> || ''}
      fullWidth
      variant="standard"
      {...register('<%= field.name.lowerCamelName %>', {
        onChange: e => syncTarget({<%= field.name.lowerCamelName %>: e.target.value})
      })}
    />
    <%_ } -%>
    <%_ if (field.editType === 'textarea') { -%>
    <TextField
      error={!!errors.<%= field.name.lowerCamelName %>}
      helperText={errors.<%= field.name.lowerCamelName %>?.message?.toString()}
      margin="dense"
      id="<%= field.name.lowerCamelName %>"
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      type="text"
      value={target.<%= field.name.lowerCamelName %> || ''}
      fullWidth
      multiline
      minRows={4}
      variant="standard"
      {...register('<%= field.name.lowerCamelName %>', {
        onChange: e => syncTarget({<%= field.name.lowerCamelName %>: e.target.value})
      })}
    />
    <%_ } -%>
    <%_ if (field.editType === 'number' && field.name.lowerCamelName === 'id') { -%>
    <TextField
      error={!!errors.<%= field.name.lowerCamelName %>}
      helperText={errors.<%= field.name.lowerCamelName %>?.message?.toString()}
      disabled={!isNew}
      margin="dense"
      id="<%= field.name.lowerCamelName %>"
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      type="number"
      inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
      value={target.<%= field.name.lowerCamelName %> || target.<%= field.name.lowerCamelName %> === 0 ? target.<%= field.name.lowerCamelName %> : ''}
      fullWidth
      variant="standard"
      {...register('<%= field.name.lowerCamelName %>', {
        onChange: e => syncTarget({<%= field.name.lowerCamelName %>: e.target.value === '' ? undefined : Number(e.target.value)})
      })}
    />
    <%_ } -%>
    <%_ if (field.editType === 'number' && field.name.lowerCamelName !== 'id') { -%>
    <TextField
      error={!!errors.<%= field.name.lowerCamelName %>}
      helperText={errors.<%= field.name.lowerCamelName %>?.message?.toString()}
      margin="dense"
      id="<%= field.name.lowerCamelName %>"
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      type="number"
      inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
      value={target.<%= field.name.lowerCamelName %> || target.<%= field.name.lowerCamelName %> === 0 ? target.<%= field.name.lowerCamelName %> : ''}
      fullWidth
      variant="standard"
      {...register('<%= field.name.lowerCamelName %>', {
        onChange: e => syncTarget({<%= field.name.lowerCamelName %>: e.target.value === '' ? undefined : Number(e.target.value)})
      })}
    />
    <%_ } -%>
    <%_ if (field.editType === 'time') { -%>
    <DateTimeForm
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      dateTime={target.<%= field.name.lowerCamelName %>}
      syncDateTime={dateTime => syncTarget({<%= field.name.lowerCamelName %>: dateTime})}
    />
    <%_ } -%>
    <%_ if (field.editType === 'bool') { -%>
    <Controller
      name="<%= field.name.lowerCamelName %>"
      control={control}
      render={({field: {onChange}}) => (
        <FormControl error={!!errors.<%= field.name.lowerCamelName %>}>
          <FormControlLabel
            control={
              <Switch
                checked={!!target.<%= field.name.lowerCamelName %>}
                onChange={e => {
                  syncTarget({<%= field.name.lowerCamelName %>: e.target.checked})
                  onChange(e)
                }}
              />
            }
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          />
          <FormHelperText>{errors.<%= field.name.lowerCamelName %>?.message?.toString()}</FormHelperText>
        </FormControl>
      )}
    />
    <%_ } -%>
    <%_ if (field.editType === 'image' && field.dataType === 'string') { -%>
    <ImageForm
      imageURL={target.<%= field.name.lowerCamelName %> || null}
      dir="<%= struct.name.lowerCamelName %>/<%= field.name.lowerCamelName %>"
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      onChange={(value: string | null) => syncTarget({<%= field.name.lowerCamelName %>: value || undefined})}
    />
    <%_ } -%>
    <%_ if (field.editType === 'array-image') { -%>
    <ImageArrayForm
      imageURLs={target.<%= field.name.lowerCamelName %> || null}
      dir="<%= struct.name.lowerCamelName %>/<%= field.name.lowerCamelName %>"
      label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
      onChange={(value: string[] | null) => syncTarget({<%= field.name.lowerCamelName %>: value || undefined})}
    />
    <%_ } -%>
    <%_ if (field.editType === 'array-string' || field.editType === 'array-textarea' || field.editType === 'array-number' || field.editType === 'array-time' || field.editType === 'array-bool') { -%>
    <Expansion label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>一覧">
      <%_ if (field.childType === 'string') { -%>
      <ArrayForm
        items={target.<%= field.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= field.name.lowerCamelName %>: items})}
        initial={''}
        form={(editTarget, updatedForm, index) => (
          <TextField
            error={!!errors.<%= field.name.lowerCamelName %>?.[index]}
            helperText={errors.<%= field.name.lowerCamelName %>?.[index]?.message?.toString()}
            margin="dense"
            id="<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            type="text"
            value={editTarget || ''}
            fullWidth
            variant="standard"
            {...register(`<%= field.name.lowerCamelName %>.${index}`, {
              onChange: e => updatedForm(e.target.value)
            })}
          />
        )}
      />
      <%_ } -%>
      <%_ if (field.childType === 'textarea') { -%>
      <ArrayForm
        items={target.<%= field.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= field.name.lowerCamelName %>: items})}
        initial={''}
        form={(editTarget, updatedForm, index) => (
          <TextField
            error={!!errors.<%= field.name.lowerCamelName %>?.[index]}
            helperText={errors.<%= field.name.lowerCamelName %>?.[index]?.message?.toString()}
            margin="dense"
            id="<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            type="text"
            value={editTarget || ''}
            fullWidth
            multiline
            minRows={4}
            variant="standard"
            {...register(`<%= field.name.lowerCamelName %>.${index}`, {
              onChange: e => updatedForm(e.target.value)
            })}
          />
        )}
      />
      <%_ } -%>
      <%_ if (field.childType === 'number') { -%>
      <ArrayForm
        items={target.<%= field.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= field.name.lowerCamelName %>: items})}
        initial={0}
        form={(editTarget, updatedForm, index) => (
          <TextField
            error={!!errors.<%= field.name.lowerCamelName %>?.[index]}
            helperText={errors.<%= field.name.lowerCamelName %>?.[index]?.message?.toString()}
            margin="dense"
            id="<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            type="number"
            inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
            value={editTarget || editTarget === 0 ? editTarget : ''}
            fullWidth
            variant="standard"
            {...register(`<%= field.name.lowerCamelName %>.${index}`, {
              onChange: e => updatedForm(e.target.value === '' ? undefined : Number(e.target.value))
            })}
          />
        )}
      />
      <%_ } -%>
      <%_ if (field.childType === 'bool') { -%>
      <ArrayForm
        items={target.<%= field.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= field.name.lowerCamelName %>: items})}
        initial={false}
        form={(editTarget, updatedForm, index) => (
          <Controller
            name={`<%= field.name.lowerCamelName %>.${index}`}
            control={control}
            render={({field: {onChange}}) => (
              <FormControl error={!!errors.<%= field.name.lowerCamelName %>?.[index]}>
                <FormControlLabel
                  control={
                    <Switch
                      checked={!!editTarget}
                      onChange={e => {
                        updatedForm(e.target.checked)
                        onChange(e)
                      }}
                    />
                  }
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                />
                <FormHelperText>{errors.<%= field.name.lowerCamelName %>?.[index]?.message?.toString()}</FormHelperText>
              </FormControl>
            )}
          />
        )}
      />
      <%_ } -%>
      <%_ if (field.childType === 'time') { -%>
      <ArrayForm
        items={target.<%= field.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= field.name.lowerCamelName %>: items})}
        initial={dayjs().format()}
        form={(editTarget, updatedForm, index) => (
          <DateTimeForm
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            dateTime={editTarget}
            syncDateTime={dateTime => updatedForm(dateTime)}
          />
        )}
      />
      <%_ } -%>
    </Expansion>
    <%_ } -%>
    <%_ if (field.editType === 'array-struct') { -%>
    <Expansion label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>">
      <StructArrayForm
        items={target.<%= field.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= field.name.lowerCamelName %>: items})}
        initial={INITIAL_<%= field.structName.upperSnakeName %>}
        table={(items, pageInfo, changePageInfo, openEntryForm, removeRow) => (
          <<%= field.structName.pascalName %>DataTable
            items={items}
            pageInfo={pageInfo}
            hasParent={true}
            onChangePageInfo={changePageInfo}
            onClickAdd={openEntryForm}
            onClickRow={openEntryForm}
            onRemove={removeRow}
          />
        )}
        form={(isNew, open, setOpen, editTarget, syncTarget, updatedForm, removeForm) => (
          <<%= field.structName.pascalName %>EntryForm
            open={open}
            setOpen={setOpen}
            target={editTarget}
            syncTarget={syncTarget}
            hasParent={true}
            isNew={isNew}
            updated={updatedForm}
            remove={removeForm}
          />
        )}
      />
    </Expansion>
    <%_ } -%>
    <%_ if (field.editType === 'struct') { -%>
    <Expansion label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>">
      {target.<%= field.name.lowerCamelName %> ? (
        <<%= field.structName.pascalName %>EntryForm
          target={target.<%= field.name.lowerCamelName %>!}
          syncTarget={item => syncTarget({
            <%= field.name.lowerCamelName %>: {
              ...target.<%= field.name.lowerCamelName %>,
              ...item
            }
          })}
          isEmbedded={true}
          hasParent={true}
        />
      ) : (
        <InitForm
          initial={cloneDeep(INITIAL_<%= field.structName.upperSnakeName %>)}
          syncTarget={item => syncTarget({<%= field.name.lowerCamelName %>: item})}
        />
      )}
    </Expansion>
    <%_ } -%>
    <%_ if (field.name.lowerCamelName === 'id') { -%>
  ), [isNew, target.<%= field.name.lowerCamelName %>, errors.<%= field.name.lowerCamelName %>, syncTarget])
    <%_ } else if (field.editType.startsWith('array')) { -%>
  ), [target.<%= field.name.lowerCamelName %>, ...(Array.isArray(errors.<%= field.name.lowerCamelName %>) ? errors.<%= field.name.lowerCamelName %> : [errors.<%= field.name.lowerCamelName %>]), syncTarget])
    <%_ } else { -%>
  ), [target.<%= field.name.lowerCamelName %>, errors.<%= field.name.lowerCamelName %>, syncTarget])
    <%_ } -%>

  <%_ }) -%>
  return (
    <>
      {!isEmbedded && (
        <DialogTitle><%= struct.screenLabel || struct.name.pascalName %>{isNew ? '追加' : '編集'}</DialogTitle>
      )}
      <DialogContent>
        <Grid container spacing={2}>
        <%_ struct.fields.forEach(function (field, key) { -%>
          <%_ if (field.editType === 'none') { return } -%>
          <Grid item xs={12}>{<%= field.name.lowerCamelName %>Form}</Grid>
        <%_ }) -%>
        </Grid>
      </DialogContent>
      {!isEmbedded && (
        <DialogActions>
          <Button onClick={close}>キャンセル</Button>
          <Button onClick={remove}>削除</Button>
          <Button onClick={handleSubmit(save, validateError)}>保存</Button>
        </DialogActions>
      )}
    </>
  )
}

export default <%= struct.name.pascalName %>EntryForm
