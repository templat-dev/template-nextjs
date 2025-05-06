---
to: <%= rootDirectory %>/app/api/hello/route.ts
force: true
---
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({ message: 'Hello from Next.js 15.3.1 API Route Handler!' });
} 