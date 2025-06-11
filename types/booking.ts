import { Delegate } from "./delegate"

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
    shortname?: string // ✅ add this
    trainers: { name: string }[]
    category?: {
      id: string
      name: string
    }
  }

  room: {
    id: string
    name: string
    capacity?: number // ✅ add this
    locationId: string
  }

  trainer: {
    name: string
  }

  location?: {
    name: string
    backgroundColor?: string
    textColor?: string
  }

  delegates: Delegate[]
}
