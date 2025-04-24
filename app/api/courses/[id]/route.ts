import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function DELETE(
    _: NextRequest,
    { params }: { params: { id: string } },
) {
    try {
        await prisma.course.delete({ where: { id: params.id } })
        return NextResponse.json({ message: 'Course deleted' })
    } catch (error) {
        return NextResponse.json(
            { error: 'Failed to delete course' },
            { status: 500 },
        )
    }
}

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
    try {
      const data = await req.json();
      const course = await prisma.course.update({
        where: { id: params.id },
        data,
      });
      return NextResponse.json(course);
    } catch (error) {
      return NextResponse.json({ error: 'Failed to update course' }, { status: 500 });
    }
  }
