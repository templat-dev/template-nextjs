---
to: <%= rootDirectory %>/<%= projectName %>/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>EntryForm.tsx
---
import * as React from 'react'
import {useCallback, useMemo} from 'react'
import {
  Button,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControlLabel,
  Grid,
  Switch,
  TextField
} from '@mui/material'
<%_ if (entity.screenType !== 'struct') { -%>
import {useResetRecoilState, useSetRecoilState} from 'recoil'
<%_ } -%>
import {formatISO} from 'date-fns'
<%_ if (entity.screenType !== 'struct') { -%>
import {loadingState} from '@/state/App'
<%_ } -%>
import DateTimeForm from '@/components/form/DateTimeForm'
<%_ if (entity.hasImage === true) { -%>
import ImageForm from '@/components/form/ImageForm'
<%_ } -%>
<%_ if (entity.hasMultiImage === true) { -%>
import ImageArrayForm from '@/components/form/ImageArrayForm'
<%_ } -%>
import {
  <%_ if (entity.screenType !== 'struct') { -%><%= h.changeCase.upperCaseFirst(entity.name) %>Api,
  <% } -%>Model<%= entity.pascalName %>,
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'array-struct' || property.type === 'struct') { -%>
  Model<%= h.changeCase.upperCaseFirst(property.structType) %>,
  <%_ } -%>
<%_ }) -%>
} from '@/apis'
<%_ const importDataTableSet = new Set() -%>
<%_ const importEntryFormSet = new Set() -%>
<%_ let importExpansion = false -%>
<%_ let importStructArrayForm = false -%>
<%_ let importArrayForm = false -%>
<%_ let importInitForm = false -%>
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'struct') { -%>
    <%_ importInitForm = true -%>
    <%_ importExpansion = true -%>
    <%_ importEntryFormSet.add(property.structType) -%>
  <%_ } -%>
  <%_ if (property.type === 'array-struct') { -%>
    <%_ importInitForm = true -%>
    <%_ importExpansion = true -%>
    <%_ importStructArrayForm = true -%>
    <%_ importEntryFormSet.add(property.structType) -%>
    <%_ importDataTableSet.add(property.structType) -%>
  <%_ } -%>
  <%_ if (property.type === 'array-string' || property.type === 'array-textarea' || property.type === 'array-number' || property.type === 'array-time' || property.type === 'array-bool') { -%>
    <%_ importExpansion = true -%>
    <%_ importArrayForm = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ if (importInitForm) { -%>
import InitForm from '@/components/form/InitForm'
<%_ } -%>
<%_ if (importExpansion) { -%>
import Expansion from '@/components/form/Expansion'
<%_ } -%>
<%_ if (importArrayForm) { -%>
import ArrayForm from '@/components/form/ArrayForm'
<%_ } -%>
<%_ if (importStructArrayForm) { -%>
import {NEW_INDEX} from '@/components/common/Base'
import StructArrayForm from '@/components/form/StructArrayForm'
<%_ } -%>
<%_ importEntryFormSet.forEach(function (structType) { -%>
import <%= h.changeCase.pascal(structType) %>EntryForm, {INITIAL_<%= h.changeCase.constant(structType) %>} from '@/components/<%= h.changeCase.camel(structType) %>/<%= h.changeCase.pascal(structType) %>EntryForm'
<%_ }) -%>
<%_ importDataTableSet.forEach(function (structType) { -%>
import <%= h.changeCase.pascal(structType) %>DataTable from '@/components/<%= h.changeCase.camel(structType) %>/<%= h.changeCase.pascal(structType) %>DataTable'
<%_ }) -%>

export const INITIAL_<%= h.changeCase.constant(entity.name) %>: Model<%= h.changeCase.pascal(entity.name) %> = {
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'struct') { -%>
  <%= property.name %>: INITIAL_<%= h.changeCase.constant(property.structType) %>,
  <%_ } -%>
  <%_ if (property.type.startsWith('array')) { -%>
  <%= property.name %>: [],
  <%_ } -%>
  <%_ if (property.type === 'string' || property.type === 'textarea' || property.type === 'time') { -%>
  <%= property.name %>: undefined,
  <%_ } -%>
  <%_ if (property.type === 'bool') { -%>
  <%= property.name %>: undefined,
  <%_ } -%>
  <%_ if (property.type === 'number') { -%>
  <%= property.name %>: undefined,
  <%_ } -%>
<%_ }) -%>
}

export interface <%= h.changeCase.pascal(entity.name) %>EntryFormProps {
  /** 表示状態 */
  open?: boolean
  /** 表示状態設定コールバック */
  setOpen?: (open: boolean) => void,
  /** 編集対象 */
  target: Model<%= h.changeCase.pascal(entity.name) %>,
  /** 編集対象同期コールバック */
  syncTarget: (target: Model<%= h.changeCase.pascal(entity.name) %>) => void,
  /** 表示方式 (true: 埋め込み, false: ダイアログ) */
  isEmbedded?: boolean,
  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  hasParent?: boolean,
  /** 編集状態 (true: 新規, false: 更新) */
  isNew?: boolean,
  /** 更新コールバック */
  updated?: () => void,
  /** 削除コールバック */
  remove?: () => void
}

const <%= h.changeCase.pascal(entity.name) %>EntryForm = ({open = true, setOpen = () => {}, target, syncTarget, isEmbedded = false, hasParent = false, isNew = true, updated = () => {}, remove = () => {}}: <%= h.changeCase.pascal(entity.name) %>EntryFormProps) => {
<%_ if (entity.screenType !== 'struct') { -%>
  const showLoading = useSetRecoilState<boolean>(loadingState)
  const hideLoading = useResetRecoilState(loadingState)

<%_ } -%>
  const close = useCallback(() => {
    if (!isEmbedded) {
      setOpen(false)
    }
  }, [isEmbedded, setOpen])

<%_ if (entity.screenType !== 'struct') { -%>
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
        await new <%= h.changeCase.pascal(entity.name) %>Api().create<%= h.changeCase.pascal(entity.name) %>({
          body: target
        })
      } else {
        // 更新の場合
        await new <%= h.changeCase.pascal(entity.name) %>Api().update<%= h.changeCase.pascal(entity.name) %>({
          id: target.id!,
          body: target
        })
      }
      close()
    } finally {
      hideLoading()
    }
    updated()
  }, [hasParent, isNew, target, close, updated, showLoading, hideLoading])
<%_ } -%>
<%_ if (entity.screenType === 'struct') { -%>
  const save = useCallback(async () => {
    updated()
    close()
  }, [updated, close])
<%_ } -%>

  <%_ entity.editProperties.forEach(function (property, key) { -%>
    <%_ if (property.type === 'none') { return } -%>
  const <%= property.name %>Form = useMemo(() => (
    <%_ if (property.type === 'string' && property.name === 'id') { -%>
    <TextField
      disabled={!isNew}
      margin="dense"
      id="<%= property.name %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      type="text"
      value={target.<%= property.name %> || ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name %>: e.target.value})}
    />
    <%_ } -%>
    <%_ if (property.type === 'string' && property.name !== 'id') { -%>
    <TextField
      margin="dense"
      id="<%= property.name %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      type="text"
      value={target.<%= property.name %> || ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name %>: e.target.value})}
    />
    <%_ } -%>
    <%_ if (property.type === 'textarea') { -%>
    <TextField
      margin="dense"
      id="<%= property.name %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      type="text"
      value={target.<%= property.name %> || ''}
      fullWidth
      multiline
      minRows={4}
      variant="standard"
      onChange={e => syncTarget({<%= property.name %>: e.target.value})}
    />
    <%_ } -%>
    <%_ if (property.type === 'number' && property.name === 'id') { -%>
    <TextField
      disabled={!isNew}
      margin="dense"
      id="<%= property.name %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      type="number"
      inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
      value={target.<%= property.name %> || target.<%= property.name %> === 0 ? target.<%= property.name %> : ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name %>: e.target.value === '' ? undefined : Number(e.target.value)})}
    />
    <%_ } -%>
    <%_ if (property.type === 'number' && property.name !== 'id') { -%>
    <TextField
      margin="dense"
      id="<%= property.name %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      type="number"
      inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
      value={target.<%= property.name %> || target.<%= property.name %> === 0 ? target.<%= property.name %> : ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name %>: e.target.value === '' ? undefined : Number(e.target.value)})}
    />
    <%_ } -%>
    <%_ if (property.type === 'time') { -%>
    <DateTimeForm
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      dateTime={target.<%= property.name %> ? new Date(target.<%= property.name %>) : null}
      syncDateTime={dateTime => syncTarget({<%= property.name %>: dateTime ? formatISO(dateTime) : undefined})}
    />
    <%_ } -%>
    <%_ if (property.type === 'bool') { -%>
    <FormControlLabel
      control={
        <Switch
          checked={!!target.<%= property.name %>}
          onChange={e => syncTarget({<%= property.name %>: e.target.checked})}
        />
      }
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
    />
    <%_ } -%>
    <%_ if (property.type === 'image' && property.dataType === 'string') { -%>
    <ImageForm
      imageURL={target.<%= property.name %> || null}
      dir="<%= entity.name %>/<%= property.name %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      onChange={value => syncTarget({<%= property.name %>: value || undefined})}
    />
    <%_ } -%>
    <%_ if (property.type === 'array-image') { -%>
    <ImageArrayForm
      imageURLs={target.<%= property.name %> || null}
      dir="<%= entity.name %>/<%= property.name %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name %>"
      onChange={value => syncTarget({<%= property.name %>: value || undefined})}
    />
    <%_ } -%>
    <%_ if (property.type === 'array-string' || property.type === 'array-textarea' || property.type === 'array-number' || property.type === 'array-time' || property.type === 'array-bool') { -%>
    <Expansion label="<%= property.screenLabel ? property.screenLabel : property.name %>一覧">
      <%_ if (property.childType === 'string') { -%>
      <ArrayForm
        items={target.<%= property.name %> || []}
        syncItems={items => syncTarget({<%= property.name %>: items})}
        initial={''}
        form={(editTarget, updatedForm) => (
          <TextField
            margin="dense"
            id="<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            type="text"
            value={editTarget || ''}
            fullWidth
            variant="standard"
            onChange={e => updatedForm(e.target.value)}
          />
        )}
      />
      <%_ } -%>
      <%_ if (property.childType === 'textarea') { -%>
      <ArrayForm
        items={target.<%= property.name %> || []}
        syncItems={items => syncTarget({<%= property.name %>: items})}
        initial={''}
        form={(editTarget, updatedForm) => (
          <TextField
            margin="dense"
            id="<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            type="text"
            value={editTarget || ''}
            fullWidth
            multiline
            minRows={4}
            variant="standard"
            onChange={e => updatedForm(e.target.value)}
          />
        )}
      />
      <%_ } -%>
      <%_ if (property.childType === 'number') { -%>
      <ArrayForm
        items={target.<%= property.name %> || []}
        syncItems={items => syncTarget({<%= property.name %>: items})}
        initial={0}
        form={(editTarget, updatedForm) => (
          <TextField
            margin="dense"
            id="<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            type="number"
            inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
            value={editTarget || editTarget === 0 ? editTarget : ''}
            fullWidth
            variant="standard"
            onChange={e => updatedForm(e.target.value === '' ? undefined : Number(e.target.value))}
          />
        )}
      />
      <%_ } -%>
      <%_ if (property.childType === 'bool') { -%>
      <ArrayForm
        items={target.<%= property.name %> || []}
        syncItems={items => syncTarget({<%= property.name %>: items})}
        initial={false}
        form={(editTarget, updatedForm) => (
          <FormControlLabel
            control={
              <Switch
                checked={!!editTarget}
                onChange={e => updatedForm(e.target.checked)}
              />
            }
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
          />
        )}
      />
      <%_ } -%>
      <%_ if (property.childType === 'time') { -%>
      <ArrayForm
        items={target.<%= property.name %> || []}
        syncItems={items => syncTarget({<%= property.name %>: items})}
        initial={formatISO(new Date())}
        form={(editTarget, updatedForm) => (
          <DateTimeForm
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            dateTime={editTarget ? new Date(editTarget) : null}
            syncDateTime={dateTime => updatedForm(dateTime ? formatISO(dateTime) : undefined)}
          />
        )}
      />
      <%_ } -%>
    </Expansion>
    <%_ } -%>
    <%_ if (property.type === 'array-struct') { -%>
    <Expansion label="<%= property.screenLabel ? property.screenLabel : property.name %>">
      <StructArrayForm
        items={target.<%= property.name %> || []}
        syncItems={items => syncTarget({<%= property.name %>: items})}
        initial={INITIAL_<%= h.changeCase.constant(property.structType) %>}
        table={(items, pageInfo, changePageInfo, openEntryForm, removeRow) => (
          <<%= h.changeCase.pascal(property.structType) %>DataTable
            items={items}
            pageInfo={pageInfo}
            hasParent={true}
            onChangePageInfo={changePageInfo}
            onOpenEntryForm={openEntryForm}
            onRemove={removeRow}
          />
        )}
        form={(editIndex, open, setOpen, editTarget, syncTarget, updatedForm, removeForm) => (
          <<%= h.changeCase.pascal(property.structType) %>EntryForm
            open={open}
            setOpen={setOpen}
            target={editTarget}
            syncTarget={syncTarget}
            hasParent={true}
            isNew={editIndex === NEW_INDEX}
            updated={updatedForm}
            remove={removeForm}
          />
        )}
      />
    </Expansion>
    <%_ } -%>
    <%_ if (property.type === 'struct') { -%>
    <Expansion label="<%= property.screenLabel ? property.screenLabel : property.name %>">
      {target.<%= property.name %> ? (
        <<%= h.changeCase.pascal(property.structType) %>EntryForm
          target={target.<%= property.name %>!}
          syncTarget={item => syncTarget({<%= property.name %>: item})}
          isEmbedded={true}
          hasParent={true}
        />
      ) : (
        <InitForm
          initial={INITIAL_<%= h.changeCase.constant(property.structType) %>}
          syncTarget={item => syncTarget({<%= property.name %>: item})}
        />
      )}
    </Expansion>
    <%_ } -%>
    <%_ if (property.name === 'id') { -%>
  ), [isNew, target.<%= property.name %>, syncTarget])
    <%_ } else { -%>
  ), [target.<%= property.name %>, syncTarget])
    <%_ } -%>

  <%_ }) -%>
  return (
    <>
      {!isEmbedded && (
        <DialogTitle><%= entity.label || h.changeCase.constant(entity.name) %>{isNew ? '追加' : '編集'}</DialogTitle>
      )}
      <DialogContent>
        <Grid container spacing={2}>
        <%_ entity.editProperties.forEach(function (property, key) { -%>
          <%_ if (property.type === 'none') { return } -%>
          <Grid item xs={12}>{<%= property.name %>Form}</Grid>
        <%_ }) -%>
        </Grid>
      </DialogContent>
      {!isEmbedded && (
        <DialogActions>
          <Button onClick={close}>キャンセル</Button>
          <Button onClick={remove}>削除</Button>
          <Button onClick={save}>保存</Button>
        </DialogActions>
      )}
    </>
  )
}

export default <%= h.changeCase.pascal(entity.name) %>EntryForm
