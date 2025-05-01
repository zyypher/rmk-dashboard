import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function validateBookingConflicts(data: any): Promise<string[]> {
    const { trainerId, roomId, date, startTime, endTime, id } = data
    const conflicts: string[] = []

    const sessionDate = new Date(date)
    const start = new Date(startTime)
    const end = new Date(endTime)

    // Fetch trainer's daily time slots
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

    // Check if booking falls within any allowed slot
    const fitsInAnySlot = dailySlots?.some((slot) => {
        const slotStart = new Date(
            `${sessionDate.toDateString()} ${slot.start}`,
        )
        const slotEnd = new Date(`${sessionDate.toDateString()} ${slot.end}`)
        return start >= slotStart && end <= slotEnd
    })

    if (!fitsInAnySlot) {
        conflicts.push(`Trainer is not available at the selected time.`)
    }

    // Fetch overlapping sessions on the same date excluding the current one if updating
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

    // Check trainer leave
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
