// hooks/usePermissions.ts
import { useMemo } from 'react'
import { permissions } from '@/lib/permissions'

export function usePermissions(role: keyof typeof permissions) {
  return useMemo(() => permissions[role] || permissions.VIEWER, [role])
}
