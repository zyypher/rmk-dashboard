import { prisma } from '@/lib/prisma'
import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
    const { searchParams } = new URL(req.url)
    const query = searchParams.get('q')?.trim()

    if (!query) {
        const all = await prisma.client.findMany({
            orderBy: { createdAt: 'desc' },
        })
        return NextResponse.json(all)
    }

    const filtered = await prisma.client.findMany({
        where: {
            OR: [
                { name: { contains: query, mode: 'insensitive' } },
                { email: { contains: query, mode: 'insensitive' } },
                { phone: { contains: query, mode: 'insensitive' } },
                { contactPersonName: { contains: query, mode: 'insensitive' } },
                {
                    tradeLicenseNumber: {
                        contains: query,
                        mode: 'insensitive',
                    },
                },
                { landline: { contains: query, mode: 'insensitive' } },
                {
                    contactPersonPosition: {
                        contains: query,
                        mode: 'insensitive',
                    },
                },
            ],
        },
        orderBy: { createdAt: 'desc' },
    })

    return NextResponse.json(filtered)
}
