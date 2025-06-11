'use client'

import React from 'react'
import Datepicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'

interface Props {
    date: Date | null
    onChange: (date: Date | null) => void
    placeholderText?: string
    className?: string
}

export const DatePicker = ({ date, onChange, placeholderText, className }: Props) => {
    return (
        <div className={className}>
            <Datepicker
                selected={date}
                onChange={onChange}
                dateFormat="PPP"
                placeholderText="Pick a date"
                className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm text-gray-900 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
        </div>
    )
}
