import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

export async function GET() {
  try {
    const leaves = await prisma.trainerLeave.findMany({
      include: { trainer: true },
      orderBy: { date: 'desc' },
    });
    return NextResponse.json(leaves);
  } catch {
    return NextResponse.json({ error: 'Failed to fetch leaves' }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
    try {
      const { trainerId, date, reason } = await req.json()
  
      if (!trainerId || !date) {
        return NextResponse.json({ error: 'Trainer ID and Date are required' }, { status: 400 })
      }
  
      const leave = await prisma.trainerLeave.create({
        data: {
          trainerId,
          date: new Date(date),
          reason,
        },
      })
  
      return NextResponse.json(leave, { status: 201 })
    } catch (error) {
      console.error('POST /api/trainer-leaves error:', error)
      return NextResponse.json({ error: 'Failed to create trainer leave' }, { status: 500 })
    }
  }