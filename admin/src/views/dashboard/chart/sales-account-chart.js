export function SalesAccountChartData() {
  return {
    height: 350,
    type: 'line',
    options: {
      chart: {
        background: 'transparent'
      },
      stroke: {
        width: [3, 3],
        curve: 'smooth'
      },
      plotOptions: {
        bar: {
          columnWidth: '50%'
        }
      },
      colors: ['#167900', '#56d63aff'],
      fill: {
        opacity: [0.85, 1]
      },
      labels: ['Jan 01', 'Feb 01', 'Mar 01', 'Apr 01', 'May 01', 'Jun 01', 'Jul 01', 'Aug 01', 'Sep 01', 'Oct 01', 'Nov 01', 'Dec 01'],
      markers: {
        size: 3,
        colors: '#092c01ff'
      },
      yaxis: {
        min: 0
      },
      grid: {
        strokeDashArray: 0,
        borderColor: '#f5f5f5'
      },
      tooltip: {
        shared: true,
        intersect: false,
        y: {
          formatter(y) {
            if (typeof y !== 'undefined') {
              return `${y.toFixed(0)} người`;
            }
            return y;
          }
        }
      },
      legend: {
        fontWeight: 700,
        fontSize: '14px',
        labels: {
          useSeriesColors: true
        },
        markers: {
          customHTML() {
            return '';
          }
        }
      },
      theme: {
        mode: 'light'
      }
    },
    series: [
      {
        name: 'Trung bình',
        type: 'line',
        data: [23, 11, 22, 27, 13, 22, 37, 21, 44, 22, 30, 40]
      },
      {
        name: 'Tổng',
        type: 'line',
        data: [30, 25, 36, 30, 45, 35, 64, 52, 59, 36, 39, 51]
      }
    ]
  };
}
