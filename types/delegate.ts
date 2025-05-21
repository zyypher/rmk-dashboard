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

  // ✅ Add these fields:
  clientId?: string
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
