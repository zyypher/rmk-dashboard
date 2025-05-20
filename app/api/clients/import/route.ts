import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function POST(req: NextRequest) {
    try {
        const clients = await req.json()

        if (!Array.isArray(clients)) {
            throw new Error(
                'Invalid data format. Expected an array of clients.',
            )
        }

        const parsed = clients.map((c: any, i: number) => {
            const row = i + 2
            if (!c.name || !c.phone) {
                throw new Error(
                    `Row ${row}: Missing required fields (name or phone)`,
                )
            }

            return {
                name: String(c.name).trim(),
                phone: String(c.phone).trim(),
                email: c.email ? String(c.email).trim() : '',
                contactPersonName: c.contactPersonName
                    ? String(c.contactPersonName).trim()
                    : '',
                tradeLicenseNumber: c.tradeLicenseNumber
                    ? String(c.tradeLicenseNumber).trim()
                    : '',
                landline: c.landline ? String(c.landline).trim() : '',
                contactPersonPosition: c.contactPersonPosition
                    ? String(c.contactPersonPosition).trim()
                    : '',
            }
        })

        await prisma.client.createMany({
            data: parsed,
            skipDuplicates: true,
        })

        return NextResponse.json({ success: true })
    } catch (err: any) {
        console.error('Client Import Error:', err)
        return NextResponse.json(
            { error: err?.message || 'Failed to import clients' },
            { status: 400 },
        )
    }
}
