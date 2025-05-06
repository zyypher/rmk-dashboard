import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

export async function PUT(
    req: NextRequest,
    { params }: { params: { id: string } },
) {
    try {
        const data = await req.json()
        const updated = await prisma.trainerLeave.update({
            where: { id: params.id },
            data,
        })
        return NextResponse.json(updated)
    } catch {
        return NextResponse.json(
            { error: 'Failed to update leave' },
            { status: 500 },
        )
    }
}

export async function DELETE(
    _: NextRequest,
    { params }: { params: { id: string } },
) {
    try {
        await prisma.trainerLeave.delete({ where: { id: params.id } })
        return NextResponse.json({ success: true })
    } catch {
        return NextResponse.json(
            { error: 'Failed to delete leave' },
            { status: 500 },
        )
    }
}
