'use client'

import { useEffect } from 'react'
import { useForm, Controller } from 'react-hook-form'
import { Dialog } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { DatePicker } from '@/components/ui/DatePicker'
import { TimePicker } from '@/components/ui/TimePicker'
import { SessionStatus } from '@prisma/client'
import { Course } from '@/types/course'
import { Trainer } from '@/types'
import { Room } from '@/types/room'
import { Language } from '@/types/language'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'

interface BookingModalProps {
    isOpen: boolean
    onClose: () => void
    onNext: (data: any) => void
    onSubmit: (data: any) => void   // ✅ Add this line
    loading?: boolean
    initialData?: any
    courses: Course[]
    trainers: Trainer[]
    rooms: Room[]
    languages: Language[]
  }
  

type BookingFormValues = {
  courseId: string
  trainerId: string
  roomId: string
  date: Date | null
  startTime: Date | null
  endTime: Date | null
  language: string
  status: SessionStatus
  notes: string
}

export default function BookingModal({
  isOpen,
  onClose,
  onNext,
  loading,
  initialData,
  courses,
  trainers,
  rooms,
  languages,
}: BookingModalProps) {
  const {
    register,
    control,
    handleSubmit,
    setValue,
    watch,
    reset,
    formState: { errors },
  } = useForm<BookingFormValues>({
    defaultValues: {
      courseId: '',
      trainerId: '',
      roomId: '',
      date: null,
      startTime: null,
      endTime: null,
      language: '',
      status: undefined,
      notes: '',
    },
  })

  useEffect(() => {
    if (initialData) {
      reset({
        ...initialData,
        date: initialData.date ? new Date(initialData.date) : null,
        startTime: initialData.startTime ? new Date(initialData.startTime) : null,
        endTime: initialData.endTime ? new Date(initialData.endTime) : null,
      })
    }
  }, [initialData, reset])

  return (
    <Dialog
      isOpen={isOpen}
      onClose={onClose}
      title={initialData ? 'Edit Booking' : 'Add Booking'}
      onSubmit={handleSubmit(onNext)}
    >
      <div className="space-y-4">
        {/* All input/select fields */}
        {/* ... same as before ... */}

        <Select value={watch('courseId')} onValueChange={(val) => setValue('courseId', val)}>
          <SelectTrigger><SelectValue placeholder="Select Course" /></SelectTrigger>
          <SelectContent>
            {courses.map((course) => (
              <SelectItem key={course.id} value={course.id}>{course.title}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select value={watch('trainerId')} onValueChange={(val) => setValue('trainerId', val)}>
          <SelectTrigger><SelectValue placeholder="Select Trainer" /></SelectTrigger>
          <SelectContent>
            {trainers.map((trainer) => (
              <SelectItem key={trainer.id} value={trainer.id}>{trainer.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select value={watch('roomId')} onValueChange={(val) => setValue('roomId', val)}>
          <SelectTrigger><SelectValue placeholder="Select Room" /></SelectTrigger>
          <SelectContent>
            {rooms.map((room) => (
              <SelectItem key={room.id} value={room.id}>{room.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Label>Date</Label>
        <Controller
          name="date"
          control={control}
          render={({ field }) => (
            <DatePicker date={field.value} onChange={(val) => field.onChange(val)} />
          )}
        />

        <Label>Start Time</Label>
        <Controller
          name="startTime"
          control={control}
          render={({ field }) => (
            <TimePicker time={field.value} onChange={(val) => field.onChange(val)} />
          )}
        />

        <Label>End Time</Label>
        <Controller
          name="endTime"
          control={control}
          render={({ field }) => (
            <TimePicker time={field.value} onChange={(val) => field.onChange(val)} />
          )}
        />

        <Select value={watch('language')} onValueChange={(val) => setValue('language', val)}>
          <SelectTrigger><SelectValue placeholder="Select Language" /></SelectTrigger>
          <SelectContent>
            {languages.map((lang) => (
              <SelectItem key={lang.id} value={lang.name}>{lang.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select value={watch('status')} onValueChange={(val) => setValue('status', val as SessionStatus)}>
          <SelectTrigger><SelectValue placeholder="Select Status" /></SelectTrigger>
          <SelectContent>
            {Object.values(SessionStatus).map((status) => (
              <SelectItem key={status} value={status}>{status}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Textarea placeholder="Notes" {...register('notes')} />

        <div className="flex justify-end pt-4">
          <Button type="submit" disabled={loading}>
            {loading ? 'Loading...' : 'Next'}
          </Button>
        </div>
      </div>
    </Dialog>
  )
}
