
import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function GET() {
  try {
    const trainers = await prisma.trainer.findMany({
      include: {
        languages: true,
        courses: true,
      },
    })
    const formatted = trainers.map((trainer) => ({
      ...trainer,
      languages: trainer.languages.map((lang) => lang.name),
    }))
    return NextResponse.json(formatted)
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch trainers' }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const data = await req.json()
    const { name, email, phone, languages, availableDays } = data

    const created = await prisma.trainer.create({
      data: {
        name,
        email,
        phone,
        availableDays,
        languages: {
          connect: languages.map((lang: string) => ({ name: lang })),
        },
      },
    })
    return NextResponse.json(created, { status: 201 })
  } catch (error) {
    return NextResponse.json({ error: 'Failed to create trainer' }, { status: 500 })
  }
}