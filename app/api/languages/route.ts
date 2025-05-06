import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

// GET /api/languages
export async function GET() {
    try {
        const languages = await prisma.language.findMany({
            orderBy: {
                createdAt: 'desc',
            },
        })
        return NextResponse.json(languages)
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to fetch languages' },
            { status: 500 },
        )
    }
}

// POST /api/languages
export async function POST(req: NextRequest) {
    try {
        const { name } = await req.json()
        if (!name) {
            return NextResponse.json(
                { error: 'Language name is required' },
                { status: 400 },
            )
        }

        const newLanguage = await prisma.language.create({
            data: { name },
        })

        return NextResponse.json(newLanguage, { status: 201 })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to create language' },
            { status: 500 },
        )
    }
}
