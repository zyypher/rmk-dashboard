'use client'

import React from 'react'
import Datepicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'
import { format } from 'date-fns'

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
        className="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring"
        placeholderText="Pick a date"
      />
    </div>
  )
}
