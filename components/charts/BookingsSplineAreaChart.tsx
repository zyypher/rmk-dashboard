'use client'

import dynamic from 'next/dynamic'
import React from 'react'

const ApexChart = dynamic(() => import('react-apexcharts'), { ssr: false })

type Props = {
  data: {
    labels: string[]
    values: number[]
  }
}

const BookingsSplineAreaChart = ({ data }: Props) => {
  const processedData = {
    labels: data.labels.length < 2 ? [...data.labels, ''] : data.labels,
    values: data.values.length < 2 ? [...data.values, 0] : data.values,
  }

  const options = {
    chart: {
      type: 'area',
      height: 350,
      zoom: { enabled: false },
      toolbar: { show: false },
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: 'smooth',
      width: 3,
    },
    xaxis: {
      categories: processedData.labels,
      title: { text: 'Date' },
    },
    yaxis: {
      title: { text: 'Bookings' },
      min: 0,
    },
    fill: {
      type: 'gradient',
      gradient: {
        shadeIntensity: 1,
        opacityFrom: 0.4,
        opacityTo: 0.1,
        stops: [0, 90, 100],
      },
    },
    tooltip: {
      y: {
        formatter: (val: number) => `${val} Bookings`,
      },
    },
    colors: ['#6366F1'],
  }

  const series = [
    {
      name: 'Bookings',
      data: processedData.values,
    },
  ]

  return <ApexChart options={options} series={series} type="area" height={300} />
}

export default BookingsSplineAreaChart
