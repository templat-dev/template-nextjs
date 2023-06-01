---
to: <%= rootDirectory %>/<%= projectName %>/styles/theme.ts
force: true
---
import {red} from '@mui/material/colors'
import {createTheme} from '@mui/material/styles'

declare module '@mui/material/styles' {
  interface Palette {
    buttonDefault: Palette['primary']
  }

  interface PaletteOptions {
    buttonDefault: PaletteOptions['primary']
  }
}

declare module '@mui/material/Button' {
  interface ButtonPropsColorOverrides {
    buttonDefault: true;
  }
}

// Create a theme instance.
const theme = createTheme({
  palette: {
    primary: {
      main: '#556cd6',
    },
    secondary: {
      main: '#19857b',
    },
    error: {
      main: red.A400,
    },
    buttonDefault: {
      main: '#F5F5F5',
      contrastText: '#757575',
    },
  }
})

export default theme
