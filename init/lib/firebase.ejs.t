---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/lib/firebase.ts` : null %>"
force: true
---
import { initializeApp } from "firebase/app";

// Your web app's Firebase configuration
<%- struct.authParameter %>

export const app = initializeApp(firebaseConfig)