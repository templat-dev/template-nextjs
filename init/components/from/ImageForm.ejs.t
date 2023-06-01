---
to: "<%= entity.plugins.includes('image') ? `${rootDirectory}/${projectName}/components/form/ImageForm.tsx` : null %>"
force: true
---
import * as React from 'react'
import {DragEvent, FormEvent, Fragment, useCallback, useRef, useState} from 'react'
import {useResetRecoilState, useSetRecoilState} from 'recoil'
import {Box, Button, Fab, Typography} from '@mui/material'
import {red} from '@mui/material/colors'
import AddIcon from '@mui/icons-material/Add'
import DeleteIcon from '@mui/icons-material/Delete'
import {loadingState} from '@/state/App'
import {ImageApi} from '@/apis'
import appUtils from '@/utils/appUtils'

export interface ImageFormProps {
  /** 画面表示ラベル */
  label: string
  /** 画像保存ディレクトリ名 */
  dir: string
  /** 編集対象 */
  imageURL: string | null
  /** サムネイル作成有無 (true: 作成する, false: 作成しない) */
  thumbnail?: boolean
  /** サムネイルのサイズ */
  thumbnailSize?: number
  /** 変更コールバック */
  onChange: (imageURL: string | null) => void
}

export const ImageForm = ({label, dir, imageURL, thumbnail = false, thumbnailSize = 200, onChange}: ImageFormProps) => {
  const showLoading = useSetRecoilState<boolean>(loadingState)
  const hideLoading = useResetRecoilState(loadingState)

  const fileInput = useRef<HTMLElement>(null)

  const [dragOvered, setDragOvered] = useState(false)

  const selectFile = useCallback(() => {
    if (!fileInput.current) {
      return
    }
    fileInput.current.click()
  }, [])

  const uploadImage = useCallback(async (file: File) => {
    const responseImage = await new ImageApi().uploadImage({
      name: appUtils.generateRandomString(8),
      dir: dir,
      image: file,
      thumbnail: thumbnail,
      thumbnailSize: thumbnailSize
    }).then(res => res.data)
    if (responseImage && responseImage.url) {
      onChange(responseImage.url)
    }
  }, [dir, thumbnail, thumbnailSize, onChange])

  const dragOverImage = useCallback((e: DragEvent) => {
    e.preventDefault()
    setDragOvered(true)
  }, [])

  const dragLeaveImage = useCallback((e: DragEvent) => {
    e.preventDefault()
    setDragOvered(false)
  }, [])

  const dropImage = useCallback(async (e: DragEvent) => {
    e.preventDefault()
    setDragOvered(false)
    if (!e.dataTransfer || !e.dataTransfer.files || e.dataTransfer.files.length === 0) {
      return
    }
    try {
      showLoading(true)
      await uploadImage(e.dataTransfer.files[0])
    } finally {
      hideLoading()
    }
  }, [uploadImage, showLoading, hideLoading])

  const selectImage = useCallback(async (e: FormEvent) => {
    const files = (e.target as HTMLInputElement).files
    if (!files || files.length === 0) {
      return
    }
    try {
      showLoading(true)
      await uploadImage(files[0])
    } finally {
      hideLoading()
    }
  }, [uploadImage, showLoading, hideLoading])

  const removeImage = useCallback(() => {
    onChange(null)
  }, [onChange])

  return (
    <Box onDrop={dropImage} onDragOver={dragOverImage} onDragLeave={dragLeaveImage}
         sx={{backgroundColor: dragOvered ? '#EEEEEE' : ''}}>
      <Typography variant="caption" sx={{mb: 1}} component="div">{label}</Typography>
      <Box sx={{display: 'flex'}}>
        {imageURL ? (
          <Box sx={{position: 'relative'}}>
            <Box component="img" src={imageURL} sx={{
              height: '100px',
              width: '100px',
              aspectRatio: '1',
              objectFit: 'cover'
            }}/>
            <Fab color="inherit" sx={[{
              position: 'absolute',
              right: '-6px',
              top: '-6px',
              width: '20px',
              height: '20px',
              minHeight: '0',
              boxShadow: 'none',
              backgroundColor: red.A400,
              color: 'white'
            }, {
              '&:hover': {
                backgroundColor: red.A200,
              }
            }]} onClick={removeImage}>
              <DeleteIcon sx={{fontSize: 12}}/>
            </Fab>
          </Box>
        ) : (
          <Fragment>
            <Box sx={{display: 'none'}} component="input" ref={fileInput}
                 accept="image/x-png,image/gif,image/jpeg" type="file"
                 onChange={selectImage}/>
            <Button variant="contained" disableElevation onClick={selectFile} color="buttonDefault"
                    sx={{
                      height: '100px',
                      width: '100px'
                    }}>
              <AddIcon fontSize="large"/>
            </Button>
          </Fragment>
        )}
      </Box>
    </Box>
  )
}
export default ImageForm
