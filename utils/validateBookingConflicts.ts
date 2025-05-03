import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function validateBookingConflicts(data: any): Promise<string[]> {
    const { trainerId, roomId, date, startTime, endTime, id } = data
    const conflicts: string[] = []

    const sessionDate = new Date(date)
    const start = new Date(startTime)
    const end = new Date(endTime)

    // 1. Fetch trainer info (including time slots)
    const trainer = await prisma.trainer.findUnique({
        where: { id: trainerId },
        select: { dailyTimeSlots: true },
    })

    if (!trainer) {
        conflicts.push('Trainer not found.')
        return conflicts
    }

    const dailySlots = trainer.dailyTimeSlots as {
        start: string
        end: string
    }[]

    // 2. Validate the booking time fits within one of the trainer's available time slots
    const fitsInAnySlot = dailySlots?.some((slot) => {
        const slotStart = new Date(
            `${sessionDate.toDateString()} ${slot.start}`,
        )
        const slotEnd = new Date(`${sessionDate.toDateString()} ${slot.end}`)
        return start >= slotStart && end <= slotEnd
    })

    if (!fitsInAnySlot) {
        conflicts.push('Trainer is not available at the selected time.')
    }

    // 3. Check overlapping sessions for the same date (excluding this session if editing)
    const overlappingSessions = await prisma.trainingSession.findMany({
        where: {
            date: sessionDate,
            ...(id && { NOT: { id } }),
        },
    })

    for (const session of overlappingSessions) {
        const sessionStart = new Date(session.startTime)
        const sessionEnd = new Date(session.endTime)
        const overlaps = start < sessionEnd && end > sessionStart

        if (overlaps && session.trainerId === trainerId) {
            conflicts.push(
                `Trainer is already booked from ${sessionStart.toLocaleTimeString()} to ${sessionEnd.toLocaleTimeString()}.`,
            )
        }

        if (overlaps && session.roomId === roomId) {
            conflicts.push(
                `Room is already booked from ${sessionStart.toLocaleTimeString()} to ${sessionEnd.toLocaleTimeString()}.`,
            )
        }
    }

    // 4. Check if the trainer is on leave that day
    const leave = await prisma.trainerLeave.findFirst({
        where: {
            trainerId,
            date: sessionDate,
        },
    })

    if (leave) {
        conflicts.push(`Trainer is on leave on ${sessionDate.toDateString()}.`)
    }

    return conflicts
}
