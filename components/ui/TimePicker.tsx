'use client'

import React from 'react'
import Datepicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'

interface Props {
  time: Date | null
  onChange: (date: Date | null) => void
  placeholderText?: string
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
        placeholderText="Pick a time"
        className="w-full border border-gray-300 rounded-md px-3 py-2 text-sm text-gray-900 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>
  )
}
