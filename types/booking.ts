export interface Booking {
    id: string
    courseId: string
    roomId: string
    date: string
    startTime: string
    endTime: string
    locationId?: string
    language?: string
    status: 'SCHEDULED' | 'COMPLETED' | 'CANCELLED' | 'RESCHEDULED'
    participants?: number
    notes?: string
    selectedSeats?: any[]
    course: {
      title: string
      trainer: {
        name: string
      }
    }
    room: {
      name: string
    }
  }
  