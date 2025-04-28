'use client'

import React from 'react'

interface TimeSelectorProps {
  value?: Date
  onChange: (date: Date) => void
}

export const TimeSelector = ({ value, onChange }: TimeSelectorProps) => {
  const [hour, setHour] = React.useState(value?.getHours() ?? 12)
  const [minute, setMinute] = React.useState(value?.getMinutes() ?? 0)

  const update = (h: number, m: number) => {
    const newTime = new Date()
    newTime.setHours(h)
    newTime.setMinutes(m)
    newTime.setSeconds(0)
    onChange(newTime)
  }

  return (
    <div className="flex gap-2">
      <select
        className="border rounded px-2 py-1"
        value={hour}
        onChange={(e) => {
          const h = parseInt(e.target.value, 10)
          setHour(h)
          update(h, minute)
        }}
      >
        {Array.from({ length: 24 }, (_, i) => (
          <option key={i} value={i}>{String(i).padStart(2, '0')}</option>
        ))}
      </select>
      <span>:</span>
      <select
        className="border rounded px-2 py-1"
        value={minute}
        onChange={(e) => {
          const m = parseInt(e.target.value, 10)
          setMinute(m)
          update(hour, m)
        }}
      >
        {Array.from({ length: 60 }, (_, i) => (
          <option key={i} value={i}>{String(i).padStart(2, '0')}</option>
        ))}
      </select>
    </div>
  )
}
