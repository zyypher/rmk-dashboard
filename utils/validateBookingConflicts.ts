// lib/validateBookingConflicts.ts
import { prisma } from '@/lib/prisma'
import { TrainingSession } from '@prisma/client'
import type { Day } from '@/lib/constants'

interface BookingInput {
    id?: string
    date: Date
    startTime: Date
    endTime: Date
    roomId: string
    trainerId: string
}

export async function validateBookingConflicts(
    input: BookingInput,
): Promise<string[]> {
    const { id, date, startTime, endTime, roomId, trainerId } = input

    const sessionDate = date.toISOString().split('T')[0] // YYYY-MM-DD
    const start = new Date(startTime)
    const end = new Date(endTime)
    const day = date.toLocaleDateString('en-US', { weekday: 'short' }).toUpperCase() as Day


    const conflicts: string[] = []

    // 1. Room Conflict
    const roomConflicts = await prisma.trainingSession.findMany({
        where: {
            roomId,
            date,
            NOT: id ? { id } : undefined,
            OR: [
                {
                    startTime: { lte: end },
                    endTime: { gte: start },
                },
            ],
        },
    })

    if (roomConflicts.length > 0) {
        conflicts.push('Selected room is already booked during this time.')
    }

    // 2. Trainer Conflict
    const trainerConflicts = await prisma.trainingSession.findMany({
        where: {
            trainerId,
            date,
            NOT: id ? { id } : undefined,
            OR: [
                {
                    startTime: { lte: end },
                    endTime: { gte: start },
                },
            ],
        },
    })

    if (trainerConflicts.length > 0) {
        conflicts.push('Selected trainer is already booked during this time.')
    }

    // 3. Trainer Leave
    const leave = await prisma.trainerLeave.findFirst({
        where: {
            trainerId,
            date,
        },
    })

    if (leave) {
        conflicts.push('Trainer is on leave on the selected date.')
    }

    // 4. Trainer Available Days
    const trainer = await prisma.trainer.findUnique({
        where: { id: trainerId },
    })

    if (trainer) {
        const day = new Date(date)
          .toLocaleString('en-US', { weekday: 'short' })
          .toUpperCase() as Day 
      
        if (!trainer.availableDays.includes(day)) {
          conflicts.push(`Trainer is not available on ${day}.`)
        }
      }

    return conflicts
}
