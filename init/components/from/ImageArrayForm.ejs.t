---
to: "<%= entity.plugins.includes('image') ? `${rootDirectory}/${projectName}/components/form/ImageArrayForm.tsx` : null %>"
force: true
---
import * as React from 'react'
import {DragEvent, FormEvent, useCallback, useEffect, useRef, useState} from 'react'
import {useResetRecoilState, useSetRecoilState} from 'recoil'
import {Box, Button, Fab, Typography} from '@mui/material'
import {red} from '@mui/material/colors'
import AddIcon from '@mui/icons-material/Add'
import DeleteIcon from '@mui/icons-material/Delete'
import {loadingState} from '@/state/App'
import {ImageApi} from '@/apis'
import appUtils from '@/utils/appUtils'

export interface ImageArrayFormProps {
  /** 画面表示ラベル */
  label: string
  /** 画像保存ディレクトリ名 */
  dir: string
  /** 編集対象 */
  imageURLs: string[] | null
  /** サムネイル作成有無 (true: 作成する, false: 作成しない) */
  thumbnail?: boolean
  /** サムネイルのサイズ */
  thumbnailSize?: number
  /** 変更コールバック */
  onChange: (imageURLs: string[] | null) => void
}

export const ImageArrayForm = ({label, dir, imageURLs, thumbnail = false, thumbnailSize = 200, onChange}: ImageArrayFormProps) => {
  const showLoading = useSetRecoilState<boolean>(loadingState)
  const hideLoading = useResetRecoilState(loadingState)

  const fileInput = useRef<HTMLElement>(null)
  const currentValues = useRef<string[] | null>(null)

  const [dragOvered, setDragOvered] = useState(false)

  useEffect(() => {
    currentValues.current = imageURLs
  }, [imageURLs])

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
      if (currentValues.current) {
        currentValues.current = [...currentValues.current, responseImage.url]
      } else {
        currentValues.current = [responseImage.url]
      }
      onChange(currentValues.current)
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

  const dropImages = useCallback(async (e: DragEvent) => {
    e.preventDefault()
    setDragOvered(false)
    if (!e.dataTransfer || !e.dataTransfer.files || e.dataTransfer.files.length === 0) {
      return
    }
    try {
      showLoading(true)
      for (const file of Array.from(e.dataTransfer.files)) {
        await uploadImage(file)
      }
    } finally {
      hideLoading()
    }
  }, [uploadImage, showLoading, hideLoading])

  const selectImages = useCallback(async (e: FormEvent) => {
    const files = (e.target as HTMLInputElement).files
    if (!files || files.length === 0) {
      return
    }
    try {
      showLoading(true)
      for (const file of Array.from(files)) {
        await uploadImage(file)
      }
    } finally {
      hideLoading()
    }
  }, [uploadImage, showLoading, hideLoading])

  const removeImage = useCallback((index: number) => {
    if (!imageURLs) {
      return
    }
    currentValues.current = imageURLs.filter((_, i) => i !== index)
    onChange(currentValues.current)
  }, [imageURLs, onChange])

  return (
    <Box onDrop={dropImages} onDragOver={dragOverImage} onDragLeave={dragLeaveImage}
         sx={{backgroundColor: dragOvered ? '#EEEEEE' : ''}}>
      <Typography variant="caption" sx={{mb: 1}} component="div">{label}</Typography>
      <Box sx={{display: 'flex', flexWrap: 'wrap'}}>
        {imageURLs && imageURLs.map((value, index) => (
          <Box sx={{position: 'relative', mb: 2, mr: 2}} key={index}>
            <Box component="img" src={value} sx={{
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
            }]} onClick={() => removeImage(index)}>
              <DeleteIcon sx={{fontSize: 12}}/>
            </Fab>
          </Box>
        ))}
        <Box sx={{display: 'none'}} component="input" ref={fileInput}
             accept="image/x-png,image/gif,image/jpeg" type="file" multiple
             onChange={selectImages}/>
        <Button variant="contained" disableElevation onClick={selectFile} color="buttonDefault"
                sx={{
                  mb: 2,
                  mr: 2,
                  height: '100px',
                  width: '100px',
                }}>
          <AddIcon fontSize="large"/>
        </Button>
      </Box>
    </Box>
  )
}
export default ImageArrayForm
