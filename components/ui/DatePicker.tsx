'use client'

import React from 'react'
import Datepicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'

interface Props {
  date: Date | null
  onChange: (date: Date | null) => void
}

export const DatePicker = ({ date, onChange }: Props) => {
  return (
    <div>
      <Datepicker
        selected={date}
        onChange={onChange}
        dateFormat="PPP"
        placeholderText="Pick a date"
        className="w-full border border-gray-300 rounded-md px-3 py-2 text-sm text-gray-900 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>
  )
}
