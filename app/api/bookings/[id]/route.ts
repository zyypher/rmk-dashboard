import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

export const dynamic = 'force-dynamic'

const prisma = new PrismaClient()

export async function PUT(
    req: NextRequest,
    { params }: { params: { id: string } },
) {
    try {
        const formData = await req.formData()

        const rawData = formData.get('data') as string
        const body = JSON.parse(rawData)

        const photoMap = new Map<string, File>()
        formData.forEach((value, key) => {
            if (value instanceof File) {
                photoMap.set(key, value)
            }
        })

        const date = new Date(body.date)
        const startTime = new Date(body.startTime)
        const endTime = new Date(body.endTime)

        if (
            isNaN(date.getTime()) ||
            isNaN(startTime.getTime()) ||
            isNaN(endTime.getTime())
        ) {
            return NextResponse.json(
                { error: 'Invalid date/time values' },
                { status: 400 },
            )
        }

        const { course, trainer, room, delegates = [], ...cleaned } = body

        const updated = await prisma.trainingSession.update({
            where: { id: params.id },
            data: {
                ...cleaned,
                date,
                startTime,
                endTime,
                participants: cleaned.selectedSeats?.length || 0,
                selectedSeats: cleaned.selectedSeats ?? [],
            },
        })

        await prisma.delegate.deleteMany({ where: { sessionId: params.id } })

        if (delegates.length > 0) {
            await prisma.delegate.createMany({
                data: delegates.map((d: any) => ({
                    sessionId: params.id,
                    seatId: d.seatId,
                    name: d.name,
                    emiratesId: d.emiratesId,
                    phone: d.phone,
                    email: d.email,
                    companyName: d.companyName,
                    isCorporate: d.isCorporate,
                    photoUrl: d.photoUrl,
                    status: d.status,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                })),
            })
        }

        return NextResponse.json(updated)
    } catch (error) {
        console.error('Error updating booking:', error)
        return NextResponse.json(
            { error: 'Failed to update booking' },
            { status: 500 },
        )
    }
}

export async function DELETE(
    req: NextRequest,
    { params }: { params: { id: string } },
) {
    try {
        await prisma.trainingSession.delete({
            where: { id: params.id },
        })

        return NextResponse.json({ success: true })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to delete session' },
            { status: 500 },
        )
    }
}
