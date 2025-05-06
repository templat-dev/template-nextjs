---
to: <%= rootDirectory %>/app/page.tsx
force: true
---
import React from 'react';
import { Typography, Box, Container, Paper, Grid } from '@mui/material';

export default function Home() {
  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Grid container spacing={3}>
        <Grid item xs={12}>
          <Paper
            sx={{
              p: 2,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              textAlign: 'center',
              minHeight: 240,
              justifyContent: 'center',
            }}
          >
            <Typography variant="h4" component="h1" gutterBottom>
              Welcome to <%= project.name %>
            </Typography>
            <Typography variant="body1">
              This is a Next.js 15.3.1 project with App Router and Material UI.
            </Typography>
            <Box sx={{ mt: 4 }}>
              <Typography variant="body2" color="text.secondary">
                Get started by editing <code>app/page.tsx</code>
              </Typography>
            </Box>
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
} 