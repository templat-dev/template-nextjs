---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/lib/firebase.ts` : null %>"
force: true
---
import {initializeApp} from 'firebase/app'
import f, {getAuth} from 'firebase/auth'
import {initializeAnalytics} from 'firebase/analytics'
import {auth} from 'firebaseui'
import 'firebaseui/dist/firebaseui.css'

// Your web app's Firebase configuration
<%- project.plugins.find(p => p.name === 'auth')?.parameter %>

const firebaseApp = initializeApp(firebaseConfig)

let firebaseAuth: f.Auth, firebaseAuthUI: auth.AuthUI
if (firebaseApp.name && typeof window !== 'undefined') {
  initializeAnalytics(firebaseApp)
  firebaseAuth = getAuth(firebaseApp)
  const firebaseui = require('firebaseui')
  firebaseAuthUI = new firebaseui.auth.AuthUI(firebaseAuth)
}

export {firebaseAuth, firebaseAuthUI}