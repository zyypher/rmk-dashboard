'use client'

import { useEffect, useState } from 'react'
import { Dialog } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Armchair } from 'lucide-react'
import axios from 'axios'
import clsx from 'clsx'
import { Skeleton } from '@/components/ui/skeleton'

interface SeatSelectionModalProps {
    isOpen: boolean
    onClose: () => void
    onBack: () => void
    roomId: string
    selectedSeats: string[]
    onSeatChange: (seats: string[]) => void
    onConfirm: (seats: string[]) => void
    initialCapacity?: number 
}

export default function SeatSelectionModal({
    isOpen,
    onClose,
    onBack,
    roomId,
    selectedSeats,
    onSeatChange,
    onConfirm,
    initialCapacity
}: SeatSelectionModalProps) {
    console.log('##selectedSeats', selectedSeats)
    const [capacity, setCapacity] = useState(0)
    const [loading, setLoading] = useState(false)
    const [prefillCount, setPrefillCount] = useState<number>(0)
    const [isSubmitting, setIsSubmitting] = useState(false)

    useEffect(() => {
        if (initialCapacity) {
          setCapacity(initialCapacity)
          return
        }
      
        const fetchRoom = async () => {
          setLoading(true)
          try {
            const res = await axios.get(`/api/rooms/${roomId}`)
            setCapacity(res.data.capacity || 0)
          } catch {
            setCapacity(0)
          } finally {
            setLoading(false)
          }
        }
      
        if (roomId) fetchRoom()
      }, [roomId, initialCapacity])
      

    const toggleSeat = (seat: string) => {
        const updated = selectedSeats.includes(seat)
            ? selectedSeats.filter((s) => s !== seat)
            : [...selectedSeats, seat]
        onSeatChange(updated)
    }

    const handleConfirm = async () => {
        setIsSubmitting(true)
        try {
            await onConfirm(selectedSeats)
        } finally {
            setIsSubmitting(false)
        }
    }

    const handlePrefillSeats = () => {
        if (capacity === 0 || prefillCount <= 0) return

        const allSeatIds = Array.from(
            { length: capacity },
            (_, i) => `S${i + 1}`,
        )
        const availableSeats = allSeatIds.filter(
            (id) => !selectedSeats.includes(id),
        )
        const shuffled = [...availableSeats].sort(() => 0.5 - Math.random())
        const chosen = shuffled.slice(0, prefillCount)

        onSeatChange([...selectedSeats, ...chosen])
    }

    const handleClose = () => {
        setPrefillCount(0)
        onClose()
    }

    const getRows = () => {
        const perRow = 6
        const rows = []
        for (let i = 0; i < capacity; i += perRow) {
            rows.push(
                <div key={i} className="flex justify-center gap-2">
                    {Array.from({ length: Math.min(perRow, capacity - i) }).map(
                        (_, j) => {
                            const seatId = `S${i + j + 1}`
                            const isSelected = selectedSeats.includes(seatId)
                            return (
                                <button
                                    key={seatId}
                                    onClick={() => toggleSeat(seatId)}
                                    className={clsx(
                                        'rounded border p-1 transition',
                                        isSelected
                                            ? 'text-blue-600 border-blue-600'
                                            : 'text-gray-500 hover:text-gray-700',
                                    )}
                                >
                                    <Armchair
                                        className="h-6 w-6"
                                        style={{ transform: 'scaleX(-1)' }}
                                    />
                                </button>
                            )
                        },
                    )}
                </div>,
            )
        }
        return rows
    }

    return (
        <Dialog
            isOpen={isOpen}
            onClose={handleClose}
            title="Select Seats"
            submitLabel="Confirm"
        >
            <div className="space-y-6">
                {loading ? (
                    <div className="animate-pulse space-y-3">
                        {Array.from({ length: 5 }).map((_, rowIdx) => (
                            <div
                                key={rowIdx}
                                className="flex justify-center gap-2"
                            >
                                {Array.from({ length: 6 }).map((_, seatIdx) => (
                                    <div
                                        key={seatIdx}
                                        className="h-10 w-10 rounded-md bg-gray-200 dark:bg-gray-700"
                                    />
                                ))}
                            </div>
                        ))}
                    </div>
                ) : capacity > 0 ? (
                    <>
                        <div className="space-y-3">{getRows()}</div>

                        <div className="flex items-center justify-center gap-4 pt-4">
                            <Input
                                type="number"
                                min={1}
                                max={capacity}
                                placeholder="Enter count"
                                value={prefillCount}
                                onChange={(e) =>
                                    setPrefillCount(parseInt(e.target.value))
                                }
                                className="w-24"
                            />
                            <Button
                                variant="outline"
                                onClick={handlePrefillSeats}
                            >
                                Pre-fill
                            </Button>
                            <Button onClick={() => onSeatChange([])}>
                                Clear All
                            </Button>
                        </div>

                        <div className="mt-6 flex justify-end gap-4">
                            <Button variant="outline-black" onClick={onBack}>
                                Back
                            </Button>
                            <Button
                                variant="black"
                                onClick={handleConfirm}
                                disabled={isSubmitting}
                            >
                                {isSubmitting ? (
                                    <span className="loader" />
                                ) : (
                                    'Confirm'
                                )}
                            </Button>
                        </div>
                    </>
                ) : (
                    <p className="text-sm text-gray-500">
                        Room capacity not available.
                    </p>
                )}
            </div>
        </Dialog>
    )
}
