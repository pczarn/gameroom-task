export function score(num) {
  if(typeof num === 'number') {
    return num
  } else {
    return '—'
  }
}

export const pickerOption = {
  type: 'min',
  week: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
  month: [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September',
    'October', 'November', 'December',
  ],
  format: 'YYYY-MM-DD HH:mm',
}
