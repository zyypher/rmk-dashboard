import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

export const dynamic = 'force-dynamic'

const prisma = new PrismaClient();

// DELETE /api/languages/[id]
export async function DELETE(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { id } = params;

    await prisma.language.delete({
      where: { id },
    });

    return NextResponse.json({ message: 'Language deleted successfully' });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to delete language' }, { status: 500 });
  }
}
