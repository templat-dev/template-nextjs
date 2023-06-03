---
to: <%= rootDirectory %>/<%= project.name %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.tsx
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
<%_ if (struct.structType !== 'struct') { -%>
import {useResetRecoilState, useSetRecoilState} from 'recoil'
<%_ } -%>
import {formatISO} from 'date-fns'
<%_ if (struct.structType !== 'struct') { -%>
import {loadingState} from '@/state/App'
<%_ } -%>
import DateTimeForm from '@/components/form/DateTimeForm'
<%_ if (struct.exists.image) { -%>
import ImageForm from '@/components/form/ImageForm'
<%_ } -%>
<%_ if (struct.exists.arrayImage) { -%>
import ImageArrayForm from '@/components/form/ImageArrayForm'
<%_ } -%>
import {
  <%_ if (struct.structType !== 'struct') { -%><%= h.changeCase.upperCaseFirst(struct.name.lowerCamelName) %>Api,
  <% } -%>Model<%= struct.pascalName %>,
<%_ struct.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.editType === 'array-struct' || property.editType === 'struct') { -%>
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
<%_ struct.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.editType === 'struct') { -%>
    <%_ importInitForm = true -%>
    <%_ importExpansion = true -%>
    <%_ importEntryFormSet.add(property.structType) -%>
  <%_ } -%>
  <%_ if (property.editType === 'array-struct') { -%>
    <%_ importInitForm = true -%>
    <%_ importExpansion = true -%>
    <%_ importStructArrayForm = true -%>
    <%_ importEntryFormSet.add(property.structType) -%>
    <%_ importDataTableSet.add(property.structType) -%>
  <%_ } -%>
  <%_ if (property.editType === 'array-string' || property.editType === 'array-textarea' || property.editType === 'array-number' || property.editType === 'array-time' || property.editType === 'array-bool') { -%>
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

export const INITIAL_<%= struct.name.upperSnakeName %>: Model<%= struct.name.pascalName %> = {
<%_ struct.fields.forEach(function (property, key) { -%>
  <%_ if (property.editType === 'struct') { -%>
  <%= property.name.lowerCamelName %>: INITIAL_<%= h.changeCase.constant(property.structType) %>,
  <%_ } -%>
  <%_ if (property.editType.startsWith('array')) { -%>
  <%= property.name.lowerCamelName %>: [],
  <%_ } -%>
  <%_ if (property.editType === 'string' || property.editType === 'textarea' || property.editType === 'time') { -%>
  <%= property.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (property.editType === 'bool') { -%>
  <%= property.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (property.editType === 'number') { -%>
  <%= property.name.lowerCamelName %>: undefined,
  <%_ } -%>
<%_ }) -%>
}

export interface <%= struct.name.pascalName %>EntryFormProps {
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
  /** 編集状態 (true: 新規, false: 更新) */
  isNew?: boolean,
  /** 更新コールバック */
  updated?: () => void,
  /** 削除コールバック */
  remove?: () => void
}

const <%= struct.name.pascalName %>EntryForm = ({open = true, setOpen = () => {}, target, syncTarget, isEmbedded = false, hasParent = false, isNew = true, updated = () => {}, remove = () => {}}: <%= struct.name.pascalName %>EntryFormProps) => {
<%_ if (struct.structType !== 'struct') { -%>
  const showLoading = useSetRecoilState<boolean>(loadingState)
  const hideLoading = useResetRecoilState(loadingState)

<%_ } -%>
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

  <%_ struct.fields.forEach(function (property, key) { -%>
    <%_ if (property.editType === 'none') { return } -%>
  const <%= property.name.lowerCamelName %>Form = useMemo(() => (
    <%_ if (property.editType === 'string' && property.name.lowerCamelName === 'id') { -%>
    <TextField
      disabled={!isNew}
      margin="dense"
      id="<%= property.name.lowerCamelName %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      type="text"
      value={target.<%= property.name.lowerCamelName %> || ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name.lowerCamelName %>: e.target.value})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'string' && property.name.lowerCamelName !== 'id') { -%>
    <TextField
      margin="dense"
      id="<%= property.name.lowerCamelName %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      type="text"
      value={target.<%= property.name.lowerCamelName %> || ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name.lowerCamelName %>: e.target.value})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'textarea') { -%>
    <TextField
      margin="dense"
      id="<%= property.name.lowerCamelName %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      type="text"
      value={target.<%= property.name.lowerCamelName %> || ''}
      fullWidth
      multiline
      minRows={4}
      variant="standard"
      onChange={e => syncTarget({<%= property.name.lowerCamelName %>: e.target.value})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'number' && property.name.lowerCamelName === 'id') { -%>
    <TextField
      disabled={!isNew}
      margin="dense"
      id="<%= property.name.lowerCamelName %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      type="number"
      inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
      value={target.<%= property.name.lowerCamelName %> || target.<%= property.name.lowerCamelName %> === 0 ? target.<%= property.name.lowerCamelName %> : ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name.lowerCamelName %>: e.target.value === '' ? undefined : Number(e.target.value)})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'number' && property.name.lowerCamelName !== 'id') { -%>
    <TextField
      margin="dense"
      id="<%= property.name.lowerCamelName %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      type="number"
      inputProps={{inputMode: 'numeric', pattern: '[0-9]*'}}
      value={target.<%= property.name.lowerCamelName %> || target.<%= property.name.lowerCamelName %> === 0 ? target.<%= property.name.lowerCamelName %> : ''}
      fullWidth
      variant="standard"
      onChange={e => syncTarget({<%= property.name.lowerCamelName %>: e.target.value === '' ? undefined : Number(e.target.value)})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'time') { -%>
    <DateTimeForm
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      dateTime={target.<%= property.name.lowerCamelName %> ? new Date(target.<%= property.name.lowerCamelName %>) : null}
      syncDateTime={dateTime => syncTarget({<%= property.name.lowerCamelName %>: dateTime ? formatISO(dateTime) : undefined})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'bool') { -%>
    <FormControlLabel
      control={
        <Switch
          checked={!!target.<%= property.name.lowerCamelName %>}
          onChange={e => syncTarget({<%= property.name.lowerCamelName %>: e.target.checked})}
        />
      }
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
    />
    <%_ } -%>
    <%_ if (property.editType === 'image' && property.dataType === 'string') { -%>
    <ImageForm
      imageURL={target.<%= property.name.lowerCamelName %> || null}
      dir="<%= struct.name.lowerCamelName %>/<%= property.name.lowerCamelName %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      onChange={value => syncTarget({<%= property.name.lowerCamelName %>: value || undefined})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'array-image') { -%>
    <ImageArrayForm
      imageURLs={target.<%= property.name.lowerCamelName %> || null}
      dir="<%= struct.name.lowerCamelName %>/<%= property.name.lowerCamelName %>"
      label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
      onChange={value => syncTarget({<%= property.name.lowerCamelName %>: value || undefined})}
    />
    <%_ } -%>
    <%_ if (property.editType === 'array-string' || property.editType === 'array-textarea' || property.editType === 'array-number' || property.editType === 'array-time' || property.editType === 'array-bool') { -%>
    <Expansion label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>一覧">
      <%_ if (property.childType === 'string') { -%>
      <ArrayForm
        items={target.<%= property.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= property.name.lowerCamelName %>: items})}
        initial={''}
        form={(editTarget, updatedForm) => (
          <TextField
            margin="dense"
            id="<%= property.name.lowerCamelName %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
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
        items={target.<%= property.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= property.name.lowerCamelName %>: items})}
        initial={''}
        form={(editTarget, updatedForm) => (
          <TextField
            margin="dense"
            id="<%= property.name.lowerCamelName %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
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
        items={target.<%= property.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= property.name.lowerCamelName %>: items})}
        initial={0}
        form={(editTarget, updatedForm) => (
          <TextField
            margin="dense"
            id="<%= property.name.lowerCamelName %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
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
        items={target.<%= property.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= property.name.lowerCamelName %>: items})}
        initial={false}
        form={(editTarget, updatedForm) => (
          <FormControlLabel
            control={
              <Switch
                checked={!!editTarget}
                onChange={e => updatedForm(e.target.checked)}
              />
            }
            label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
          />
        )}
      />
      <%_ } -%>
      <%_ if (property.childType === 'time') { -%>
      <ArrayForm
        items={target.<%= property.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= property.name.lowerCamelName %>: items})}
        initial={formatISO(new Date())}
        form={(editTarget, updatedForm) => (
          <DateTimeForm
            label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            dateTime={editTarget ? new Date(editTarget) : null}
            syncDateTime={dateTime => updatedForm(dateTime ? formatISO(dateTime) : undefined)}
          />
        )}
      />
      <%_ } -%>
    </Expansion>
    <%_ } -%>
    <%_ if (property.editType === 'array-struct') { -%>
    <Expansion label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>">
      <StructArrayForm
        items={target.<%= property.name.lowerCamelName %> || []}
        syncItems={items => syncTarget({<%= property.name.lowerCamelName %>: items})}
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
    <%_ if (property.editType === 'struct') { -%>
    <Expansion label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>">
      {target.<%= property.name.lowerCamelName %> ? (
        <<%= h.changeCase.pascal(property.structType) %>EntryForm
          target={target.<%= property.name.lowerCamelName %>!}
          syncTarget={item => syncTarget({<%= property.name.lowerCamelName %>: item})}
          isEmbedded={true}
          hasParent={true}
        />
      ) : (
        <InitForm
          initial={INITIAL_<%= h.changeCase.constant(property.structType) %>}
          syncTarget={item => syncTarget({<%= property.name.lowerCamelName %>: item})}
        />
      )}
    </Expansion>
    <%_ } -%>
    <%_ if (property.name.lowerCamelName === 'id') { -%>
  ), [isNew, target.<%= property.name.lowerCamelName %>, syncTarget])
    <%_ } else { -%>
  ), [target.<%= property.name.lowerCamelName %>, syncTarget])
    <%_ } -%>

  <%_ }) -%>
  return (
    <>
      {!isEmbedded && (
        <DialogTitle><%= struct.label || struct.name.upperSnakeName %>{isNew ? '追加' : '編集'}</DialogTitle>
      )}
      <DialogContent>
        <Grid container spacing={2}>
        <%_ struct.editProperties.forEach(function (property, key) { -%>
          <%_ if (property.editType === 'none') { return } -%>
          <Grid item xs={12}>{<%= property.name.lowerCamelName %>Form}</Grid>
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

export default <%= struct.name.pascalName %>EntryForm
