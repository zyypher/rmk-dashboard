'use client'

import { useEffect, useState } from 'react'
import { Dialog } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Armchair, Users } from 'lucide-react'
import clsx from 'clsx'
import { Room } from '@/types/room'
import { Delegate } from '@/types/delegate'
import AttendantSheetModal from './AttendantSheetModal'
import DelegateModal from './DelegateModal'
import { uploadToS3 } from '@/lib/s3'
import axios from 'axios'

interface SeatSelectionModalProps {
    isOpen: boolean
    onClose: () => void
    onBack: () => void
    room: Room | undefined
    selectedSeats: string[]
    onSeatChange: (seats: string[]) => void
    onConfirm: (seats: string[]) => void
    delegates: Record<string, Delegate>
    setDelegates: React.Dispatch<React.SetStateAction<Record<string, Delegate>>>
}

interface ClientOption {
    id: string
    name: string
    tradeLicenseNumber?: string
    landline?: string
}

export default function SeatSelectionModal({
    isOpen,
    onClose,
    onBack,
    room,
    selectedSeats,
    onSeatChange,
    onConfirm,
    delegates,
    setDelegates,
}: SeatSelectionModalProps) {
    const [capacity, setCapacity] = useState(0)
    const [isSubmitting, setIsSubmitting] = useState(false)
    const [showSheet, setShowSheet] = useState(false)
    const [delegateModalOpen, setDelegateModalOpen] = useState(false)
    const [activeSeat, setActiveSeat] = useState<string | null>(null)
    const [clientOptions, setClientOptions] = useState<ClientOption[]>([])

    console.log('## 🪑 activeSeat:', activeSeat)
    console.log('## 🎯 selectedSeats before:', selectedSeats)


    useEffect(() => {
        if (room?.capacity) setCapacity(room.capacity)
    }, [room])

    useEffect(() => {
        async function fetchClients() {
          const res = await axios.get('/api/clients')
          setClientOptions(res.data)
        }
        fetchClients()
      }, [])

    const toggleSeat = (seat: string) => {
        setActiveSeat(seat)
        setDelegateModalOpen(false)
        // Wait for modal unmount
        setTimeout(() => {
            setActiveSeat(seat)
            setDelegateModalOpen(true)
        }, 0)
    }

    const handleConfirm = async () => {
        setIsSubmitting(true)
        try {
            await onConfirm(selectedSeats)
        } finally {
            setIsSubmitting(false)
        }
    }

    const getStatus = (seatId: string) => {
        if (!delegates[seatId]) return 'EMPTY'
        return delegates[seatId].status === 'CONFIRMED'
            ? 'CONFIRMED'
            : 'NOT_CONFIRMED'
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
                            const status = getStatus(seatId)

                            const color =
                                status === 'CONFIRMED'
                                    ? 'text-green-600 border-green-600'
                                    : status === 'NOT_CONFIRMED'
                                      ? 'text-yellow-500 border-yellow-500'
                                      : 'text-gray-600 border-gray-400'

                            return (
                                <button
                                    key={seatId}
                                    onClick={() => toggleSeat(seatId)}
                                    className={clsx(
                                        'rounded border p-1 transition',
                                        color,
                                        isSelected
                                            ? 'bg-muted'
                                            : 'hover:scale-105',
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
            onClose={onClose}
            title="Select Seats"
            submitLabel="Confirm"
        >
            <div className="space-y-6">
                <div className="space-y-3">{getRows()}</div>

                <div className="mt-6 flex items-center justify-between gap-4">
                    <Button variant="outline-black" onClick={onBack}>
                        Back
                    </Button>

                    <div className="flex gap-2">
                        <Button
                            variant="outline"
                            onClick={() => setShowSheet(true)}
                            className="text-sm"
                        >
                            <Users className="mr-2 h-4 w-4" /> Attendant Sheet
                        </Button>

                        <Button
                            variant="black"
                            onClick={handleConfirm}
                            disabled={isSubmitting}
                        >
                            {isSubmitting ? 'Saving...' : 'Confirm'}
                        </Button>
                    </div>
                </div>

                <DelegateModal
                    key="delegate-modal"
                    isOpen={delegateModalOpen}
                    onClose={() => {
                        setDelegateModalOpen(false)
                        setActiveSeat(null) // ✅ reset
                    }}
                    seatId={activeSeat || ''}
                    initialData={
                        activeSeat && delegates[activeSeat]
                          ? {
                              name: delegates[activeSeat].name,
                              emiratesId: delegates[activeSeat].emiratesId,
                              phone: delegates[activeSeat].phone,
                              email: delegates[activeSeat].email,
                              photo: null,
                              companyName: delegates[activeSeat].companyName,
                              isCorporate: delegates[activeSeat].isCorporate,
                              status: delegates[activeSeat].status,
                              photoUrl: delegates[activeSeat].photoUrl,
                              addNewClient: false, // ✅ Required field added
                              quotation: '',       // optional but you can include it
                              paid: false,         // optional but safe to include
                            }
                          : undefined
                      }
                      clientOptions={clientOptions}
                      
                      onSave={async (formData) => {
                        if (!activeSeat) return
                        console.log('## ✅ DelegateModal onSave called with:', formData)

                        const seatId = activeSeat
                        if (!seatId) return
                    

                        let photoUrl = delegates[activeSeat]?.photoUrl ?? ''
                        if (formData.photo) {
                            photoUrl = await uploadToS3(formData.photo)
                        }

                        const delegate: Delegate = {
                            id: '',
                            sessionId: '',
                            seatId,
                            name: formData.name || '',
                            emiratesId: formData.emiratesId || '',
                            phone: formData.phone || '',
                            email: formData.email || '',
                            companyName: formData.companyName || '',
                            isCorporate: formData.isCorporate,
                            status: formData.status,
                            photoUrl,
                            quotation: formData.quotation || '',
                            paid: formData.paid ?? false,
                            createdAt: new Date(),
                            updatedAt: new Date(),
                            session: {} as any,
                            photo: '',
                            clientId: formData.clientId || undefined,
                            newClient: formData.addNewClient ? formData.newClient : undefined,
                          }
                          
                          
                        

                          setDelegates((prev) => {
                            console.log('## 🧠 Setting delegates for', activeSeat)
                            return {
                              ...prev,
                              [activeSeat]: delegate,
                            }
                          })
                          

                        if (!selectedSeats.includes(activeSeat)) {
                            console.log('## ➕ Adding seat to selectedSeats:', activeSeat)
                            onSeatChange([...selectedSeats, activeSeat])
                        }

                        setDelegateModalOpen(false)
                    }}
                />

                <AttendantSheetModal
                    isOpen={showSheet}
                    onClose={() => setShowSheet(false)}
                    delegates={delegates}
                    large
                />
            </div>
        </Dialog>
    )
}
