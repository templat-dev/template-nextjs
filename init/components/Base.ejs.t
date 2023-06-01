---
to: <%= rootDirectory %>/<%= projectName %>/components/common/Base.ts
---

export interface SingleSearchCondition<T> {
  enabled: boolean
  value: T
}

export interface BaseSearchCondition {
  [key: string]: SingleSearchCondition<string | number | boolean>
}

export const NEW_INDEX = -1
