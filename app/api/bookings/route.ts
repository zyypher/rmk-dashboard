import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'
import { validateBookingConflicts } from '@/utils/validateBookingConflicts'

export const dynamic = 'force-dynamic'
const prisma = new PrismaClient()

export async function GET() {
    try {
        const sessions = await prisma.trainingSession.findMany({
            include: {
                course: { include: { trainers: true } },
                room: true,
            },
        })

        return NextResponse.json(sessions)
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to fetch sessions' },
            { status: 500 },
        )
    }
}

export async function POST(req: NextRequest) {
    try {
        const body = await req.json()

        const date = new Date(body.date)
        const startTime = new Date(body.startTime)
        const endTime = new Date(body.endTime)

        // Destructure and remove unwanted nested object (e.g., room)
        const {
            room, // ❌ Prisma doesn't allow nested object here
            course,
            trainer,
            ...rest
        } = body

        // Optional: Validation for time/location conflicts
        // const conflictReasons = await validateBookingConflicts({
        //     id: undefined,
        //     trainerId: body.trainerId,
        //     roomId: body.roomId,
        //     date,
        //     startTime,
        //     endTime,
        // })
        // if (conflictReasons.length > 0) {
        //     return NextResponse.json(
        //         { error: 'Booking conflict detected', reasons: conflictReasons },
        //         { status: 409 }
        //     )
        // }

        const session = await prisma.trainingSession.create({
            data: {
                ...rest,
                date,
                startTime,
                endTime,
                participants: body.selectedSeats?.length || 0,
                selectedSeats: body.selectedSeats || [],
            },
        })

        return NextResponse.json(session, { status: 201 })
    } catch (error) {
        console.error('Error creating session:', error)
        return NextResponse.json(
            { error: 'Failed to create session' },
            { status: 500 },
        )
    }
}
