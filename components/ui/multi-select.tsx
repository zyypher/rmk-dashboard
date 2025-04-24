'use client'

import * as React from 'react'
import { CheckIcon } from 'lucide-react'

interface MultiSelectContextProps {
  selected: string[]
  toggle: (value: string) => void
}

const MultiSelectContext = React.createContext<MultiSelectContextProps | null>(null)

interface MultiSelectProps {
  defaultValue?: string[]
  onChange?: (values: string[]) => void
  children: React.ReactNode
  label?: string
}

export function MultiSelect({ defaultValue = [], onChange, children, label }: MultiSelectProps) {
  const [selected, setSelected] = React.useState<string[]>(defaultValue)

  const toggle = (value: string) => {
    const updated = selected.includes(value)
      ? selected.filter((v) => v !== value)
      : [...selected, value]

    setSelected(updated)
    onChange?.(updated)
  }

  return (
    <MultiSelectContext.Provider value={{ selected, toggle }}>
      <div className="rounded border px-3 py-2">
        {label && (
          <div className="mb-2 text-sm font-medium text-gray-700">{label}</div>
        )}
        <div className="flex flex-wrap gap-2">{children}</div>
      </div>
    </MultiSelectContext.Provider>
  )
}

interface MultiSelectItemProps {
  value: string
  children: React.ReactNode
}

export function MultiSelectItem({ value, children }: MultiSelectItemProps) {
  const context = React.useContext(MultiSelectContext)

  if (!context) {
    throw new Error('MultiSelectItem must be used inside MultiSelect')
  }

  const { selected, toggle } = context
  const isActive = selected.includes(value)

  return (
    <button
      type="button"
      onClick={() => toggle(value)}
      className={`rounded-full border px-3 py-1 text-sm transition ${
        isActive
          ? 'bg-blue-500 text-white border-blue-500'
          : 'border-gray-300 text-gray-700 hover:border-blue-500'
      }`}
    >
      {children}
      {isActive && <CheckIcon className="ml-2 inline h-4 w-4" />}
    </button>
  )
}
