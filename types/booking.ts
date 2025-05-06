import { Delegate } from './delegate'

export interface Booking {
  id: string
  courseId: string
  roomId: string
  date: string
  startTime: string
  endTime: string
  trainerId: string
  locationId?: string
  language?: string
  status: 'SCHEDULED' | 'COMPLETED' | 'CANCELLED' | 'RESCHEDULED'
  participants?: number
  notes?: string
  selectedSeats?: any[]
  course: {
    title: string
    trainers: { name: string }[]
  }
  room: {
    name: string
  }
  trainer: {
    name: string
  }
  delegates: Delegate[] 
}
