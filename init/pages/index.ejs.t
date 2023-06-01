---
to: <%= rootDirectory %>/<%= projectName %>/pages/index.tsx
force: true
---
import * as React from 'react'
import type {NextPage} from 'next'
import {Button, Card, CardActions, CardContent, Container, Divider, Grid, Typography} from '@mui/material'
import PagesIcon from '@mui/icons-material/Pages'
import ArrowForwardIcon from '@mui/icons-material/ArrowForward'
import Link from '@/components/Link'

const Index: NextPage = () => {
  return (
    <Container sx={{padding: 2}}>
      <Grid container spacing={2}>
        {/* メニュー */}
      </Grid>
    </Container>
  )
}

export default Index