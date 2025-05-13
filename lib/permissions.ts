// lib/permissions.ts

type Role = 'ADMIN' | 'EDITOR' | 'VIEWER'
type Action = 'edit' | 'reschedule' | 'publish' | 'delete' | 'view'

export const permissions: Record<Role, Action[]> = {
  ADMIN: ['edit', 'reschedule', 'publish', 'delete'],
  EDITOR: ['edit', 'reschedule', 'publish'],
  VIEWER: ['view'],
}

export function hasPermission(action: Action): boolean {
  const role = localStorage.getItem('userRole')?.toUpperCase() as Role | undefined

  if (!role || !(role in permissions)) return false

  return permissions[role].includes(action)
}
