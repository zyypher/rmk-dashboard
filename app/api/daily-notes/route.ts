import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'
import dayjs from 'dayjs'

// GET: Fetch daily notes (can fetch all or by specific date)
export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const dateParam = searchParams.get('date')

    if (dateParam) {
      // Fetch a specific note by date - ensure we use local timezone
      const date = dayjs(dateParam).startOf('day').toDate()
      const note = await prisma.dailyNote.findUnique({
        where: {
          date: date,
        },
      })
      return NextResponse.json(note)
    } else {
      // Fetch all notes (or a paginated list if needed later, but for now, all)
      const notes = await prisma.dailyNote.findMany({
        orderBy: {
          date: 'asc',
        },
      })
      return NextResponse.json(notes)
    }
  } catch (error) {
    console.error('Failed to fetch daily notes:', error)
    return NextResponse.json({ error: 'Failed to fetch daily notes' }, { status: 500 })
  }
}

// POST: Create a new daily note
export async function POST(req: NextRequest) {
  try {
    const { date: dateString, note } = await req.json()

    if (!dateString || !note) {
      return NextResponse.json({ error: 'Date and note are required' }, { status: 400 })
    }

    // Create date in local timezone by setting the time to noon to avoid timezone issues
    // This ensures the date stays the same regardless of timezone
    const [year, month, day] = dateString.split('-').map(Number)
    const localDate = new Date(year, month - 1, day, 12, 0, 0, 0) // Set to noon local time
    
    console.log('##Date string received:', dateString)
    console.log('##Local date created:', localDate)
    console.log('##Local date ISO string:', localDate.toISOString())

    const newNote = await prisma.dailyNote.create({
      data: {
        date: localDate,
        note: note,
      },
    })

    return NextResponse.json(newNote, { status: 201 })
  } catch (error) {
    console.error('Failed to create daily note:', error)
    return NextResponse.json({ error: 'Failed to create daily note' }, { status: 500 })
  }
}

// PUT: Update an existing daily note by date
export async function PUT(req: NextRequest) {
  try {
    const { date: dateString, note } = await req.json()

    if (!dateString || !note) {
      return NextResponse.json({ error: 'Date and note are required' }, { status: 400 })
    }

    // Create date in local timezone by setting the time to noon to avoid timezone issues
    const [year, month, day] = dateString.split('-').map(Number)
    const localDate = new Date(year, month - 1, day, 12, 0, 0, 0) // Set to noon local time

    const updatedNote = await prisma.dailyNote.update({
      where: {
        date: localDate,
      },
      data: {
        note: note,
      },
    })

    return NextResponse.json(updatedNote)
  } catch (error) {
    console.error('Failed to update daily note:', error)
    return NextResponse.json({ error: 'Failed to update daily note' }, { status: 500 })
  }
}

// DELETE: Delete a daily note by date
export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const dateParam = searchParams.get('date')

    if (!dateParam) {
      return NextResponse.json({ error: 'Date is required' }, { status: 400 })
    }

    // Create date in local timezone by setting the time to noon to avoid timezone issues
    const [year, month, day] = dateParam.split('-').map(Number)
    const localDate = new Date(year, month - 1, day, 12, 0, 0, 0) // Set to noon local time

    await prisma.dailyNote.delete({
      where: {
        date: localDate,
      },
    })

    return NextResponse.json({ message: 'Daily note deleted' })
  } catch (error) {
    console.error('Failed to delete daily note:', error)
    return NextResponse.json({ error: 'Failed to delete daily note' }, { status: 500 })
  }
} 