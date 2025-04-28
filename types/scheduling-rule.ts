// types/scheduling-rule.ts
import { Day } from '@/lib/constants'

export interface TrainerSchedulingRule {
  id: string
  trainerId: string
  trainer: {
    name: string
  }
  availableDays: Day[]
  maxSessionsPerDay: number
  notes?: string
  allowOverlap: boolean
  daysOff: Day[] //
}
