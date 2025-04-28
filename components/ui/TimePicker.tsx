'use client'

import React from 'react'
import Datepicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'

interface Props {
  time: Date | null
  onChange: (date: Date | null) => void
}

export const TimePicker = ({ time, onChange }: Props) => {
  return (
    <div>
      <Datepicker
        selected={time}
        onChange={onChange}
        showTimeSelect
        showTimeSelectOnly
        timeIntervals={15}
        timeCaption="Time"
        dateFormat="h:mm aa"
        className="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring"
        placeholderText="Pick a time"
      />
    </div>
  )
}
