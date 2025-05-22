import type { Client } from './client'

export interface Delegate {
    id: string
    sessionId: string
    seatId: string
    name: string
    emiratesId: string
    phone: string
    email: string
    companyName: string
    isCorporate: boolean
    photoUrl: string
    status: 'CONFIRMED' | 'NOT_CONFIRMED'
    quotation?: string
    paid?: boolean
    createdAt: Date
    updatedAt: Date
    session: any
    photo: string

    clientId?: string
    client?: Client // ✅ Add this line
    addNewClient?: boolean
    newClient?: {
        name: string
        phone?: string
        landline?: string
        email?: string
        contactPersonName?: string
        contactPersonPosition?: string
        tradeLicenseNumber?: string
    }
}
