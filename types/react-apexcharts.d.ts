declare module 'react-apexcharts' {
    import React from 'react';
  
    interface Props {
      options: any
      series: any
      type: 'line' | 'area' | 'bar' | 'radar' | 'histogram' | 'pie' | 'donut' | 'rangeBar' | 'scatter' | 'bubble' | 'heatmap' | 'candlestick' | 'radialBar' | 'boxPlot' | 'polarArea' | 'treemap'
      width?: string | number
      height?: string | number
    }
  
    const Chart: React.FC<Props>
    export default Chart
  }
  