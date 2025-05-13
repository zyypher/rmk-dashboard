// hooks/useUserRole.ts
import { useState, useEffect } from 'react'
import { Role } from '@/types/roles'

const VALID_ROLES: Role[] = ['ADMIN', 'EDITOR', 'VIEWER']

export function useUserRole(): Role {
    const [role, setRole] = useState<Role>('VIEWER')

    useEffect(() => {
        const storedRole = localStorage.getItem('userRole')?.toUpperCase()
        if (storedRole && VALID_ROLES.includes(storedRole as Role)) {
            setRole(storedRole as Role)
        }
    }, [])

    return role
}
