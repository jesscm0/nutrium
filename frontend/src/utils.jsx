import i18n from 'i18next';


export function formatDate(item) {
  const language = i18n.language;
  if (language == "en") {
    return formatDateEN(item);
  } else {
    return formatDatePT(item);
  }
}

function formatDateEN(item) {
  const date = new Date(item);
  const day = date.getDate();
  const year = date.getFullYear();

  const month = date.toLocaleDateString('en-GB', { month: 'long' });

  const getSufixo = (d) => {
    if (d > 3 && d < 21) return 'th';
    switch (d % 10) {
      case 1: return "st";
      case 2: return "nd";
      case 3: return "rd";
      default: return "th";
    }
  };

  return `${day}${getSufixo(day)} ${month.toLowerCase()} ${year}`;
}

function formatDatePT(item) {
  return new Date(item).toLocaleDateString("pt-PT", {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  });
}


export function formatHour(item) {
  if (i18n.language == "en") {
    return formatHourEN(item);
  } else {
    return formatHourPT(item);
  }
}


function formatHourEN(item) {
  return new Date(item).toLocaleTimeString('en-US', {
    hour: 'numeric',
    minute: '2-digit',
    hour12: true,
    timeZone: 'Europe/Lisbon'
  }).toLowerCase();
}

function formatHourPT(item) {
  return new Date(item).toLocaleTimeString('pt-PT', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
    timeZone: 'Europe/Lisbon'
  }).toLowerCase();
}