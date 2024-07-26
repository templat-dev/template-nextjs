---
to: <%= rootDirectory %>/components/form/Expansion.tsx
force: true
---
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import {Accordion, AccordionDetails, AccordionSummary, Box, Typography} from '@mui/material'
import * as React from 'react'
import {ReactNode} from 'react'

type ExpansionProps = {
  /** 画面表示ラベル */
  label: string
  /** 描画内容 */
  children?: ReactNode
}
export const Expansion = ({label, children}: ExpansionProps) => {
  return (
    <Accordion>
      <AccordionSummary expandIcon={<ExpandMoreIcon/>}>
        <Typography>{label}</Typography>
      </AccordionSummary>
      <AccordionDetails sx={{p: '12px', backgroundColor: '#EEE'}}>
        <Box sx={{backgroundColor: '#FFF'}}>
          {children}
        </Box>
      </AccordionDetails>
    </Accordion>
  )
}
export default Expansion

