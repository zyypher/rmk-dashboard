import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function GET() {
  try {
    const rules = await prisma.trainerSchedulingRule.findMany({
      include: {
        trainer: true,
      },
    })
    return NextResponse.json(rules)
  } catch (error) {
    console.error('GET error:', error)
    return NextResponse.json({ error: 'Failed to fetch rules' }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const data = await req.json()
    const existing = await prisma.trainerSchedulingRule.findUnique({
      where: { trainerId: data.trainerId },
    })
    
    if (existing) {
      return NextResponse.json(
        { error: 'A rule already exists for this trainer.' },
        { status: 400 }
      )
    }
    
    const rule = await prisma.trainerSchedulingRule.create({
      data: {
        trainerId: data.trainerId,
        maxSessionsPerDay: Number(data.maxSessionsPerDay),
        daysOff: data.daysOff,
        allowOverlap: data.allowOverlap,
      },
    })
    return NextResponse.json(rule, { status: 201 })
  } catch (error) {
    console.error('POST error:', error)
    return NextResponse.json({ error: 'Failed to create rule' }, { status: 500 })
  }
}
