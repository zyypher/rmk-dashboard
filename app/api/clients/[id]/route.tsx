import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function PUT(
    req: NextRequest,
    { params }: { params: { id: string } },
) {
    const { id } = params
    try {
        const data = await req.json()
        const client = await prisma.client.update({ where: { id }, data })
        return NextResponse.json(client)
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to update client' },
            { status: 500 },
        )
    }
}

export async function DELETE(
    req: NextRequest,
    { params }: { params: { id: string } },
) {
    const { id } = params
    try {
        await prisma.client.delete({ where: { id } })
        return NextResponse.json({ message: 'Client deleted' })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to delete client' },
            { status: 500 },
        )
    }
}
