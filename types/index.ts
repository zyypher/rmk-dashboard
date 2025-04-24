import { Day } from '@/lib/constants'

export interface Trainer {
  id: string
  name: string
  email: string
  phone: string
  languages: string[]
  availableDays: Day[]
  timeSlots: { start: string; end: string }[]
  courses: { id: string; title: string }[]
}