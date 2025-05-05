export type DelegateStatus = 'CONFIRMED' | 'NOT_CONFIRMED'

// types/delegate.ts

export interface Delegate {
  id: string
  sessionId: string
  name: string
  emiratesId: string
  phone: string
  seatId: string 
  email: string
  companyName: string
  isCorporate: boolean
  photoUrl: string
  status: 'CONFIRMED' | 'NOT_CONFIRMED'
  createdAt: Date
  updatedAt: Date
  session: any
  photo: string 
}
