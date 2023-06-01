---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/lib/firebase.ts` : null %>"
force: true
---
import { initializeApp } from "firebase/app";

// Your web app's Firebase configuration
<%- entity.authParameter %>

export const app = initializeApp(firebaseConfig)