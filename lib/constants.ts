export type Day = 'MON' | 'TUE' | 'WED' | 'THU' | 'FRI' | 'SAT' | 'SUN'

export const daysList: Day[] = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']

export function formatDayList(days: Day[] | undefined | null): string {
  if (!days || !Array.isArray(days)) return ''
  
  const map = {
    MON: 'Mon',
    TUE: 'Tue',
    WED: 'Wed',
    THU: 'Thu',
    FRI: 'Fri',
    SAT: 'Sat',
    SUN: 'Sun',
  }
  return days.map((day) => map[day as Day]).join(', ')
}
