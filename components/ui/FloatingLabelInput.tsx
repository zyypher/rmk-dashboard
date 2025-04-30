'use client'

import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { cn } from "@/lib/utils"
import { useEffect, useState } from "react"

interface FloatingLabelInputProps {
  label: string
  value?: string
  onChange?: (val: string) => void
  name: string
  error?: string
  type?: string
  placeholder?: string
  onKeyDown?: (e: React.KeyboardEvent<HTMLInputElement>) => void
}

export function FloatingLabelInput({
  label,
  value = '',
  onChange,
  name,
  error,
  type = 'text',
  placeholder,
  onKeyDown
}: FloatingLabelInputProps) {
  const [isFocused, setIsFocused] = useState(false)

  const hasValue = value?.toString().length > 0

  return (
    <div className="relative w-full">
      <Input
        id={name}
        name={name}
        value={value}
        type={type}
        placeholder={placeholder}
        onFocus={() => setIsFocused(true)}
        onBlur={() => setIsFocused(false)}
        onChange={(e) => onChange?.(e.target.value)}
        className="peer placeholder-transparent pt-5"
        onKeyDown={onKeyDown} 
      />
      <Label
        htmlFor={name}
        className={cn(
          "absolute left-3 text-sm text-muted-foreground transition-all duration-200",
          {
            'top-1 text-xs scale-90': isFocused || hasValue,
            'top-3.5': !isFocused && !hasValue,
          }
        )}
      >
        {label}
      </Label>

      {error && <p className="text-red-600 text-sm mt-1">{error}</p>}
    </div>
  )
}
