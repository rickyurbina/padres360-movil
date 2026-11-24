/// Retorna cuánto tiempo ha pasado desde el timestamp
String formatTime(int timestamp) {
  /// La cantidad de milisegundos que han pasado desde el timestamp
  int difference = DateTime.now().millisecondsSinceEpoch - timestamp;
  String result;

  if (difference < 60000) {
    result = countSeconds(difference);
  } else if (difference < 3600000) {
    result = countMinutes(difference);
  } else if (difference < 86400000) {
    result = countHours(difference);
  } else if (difference < 604800000) {
    result = countDays(difference);
  } else if (difference / 1000 < 2419200) {
    result = countWeeks(difference);
  } else if (difference / 1000 < 31536000) {
    result = countMonths(difference);
  } else {
    result = countYears(difference);
  }

  return !result.startsWith("A") ? 'hace $result' : result;
}

/// Convierte la diferencia de tiempo a segundos.
/// Esta función trunca al segundo más bajo.
///   retorna ("Justo ahora" O "X segundos")
String countSeconds(int difference) {
  int count = (difference / 1000).truncate();
  return count > 1 ? '$count segundos' : 'Justo ahora';
}

/// Convierte la diferencia de tiempo a minutos.
/// Esta función trunca al minuto más bajo.
///   retorna ("1 minuto" O "X minutos")
String countMinutes(int difference) {
  int count = (difference / 60000).truncate();
  return count.toString() + (count > 1 ? ' minutos' : ' minuto');
}

/// Convierte la diferencia de tiempo a horas.
/// Esta función trunca a la hora más baja.
///   retorna ("1 hora" O "X horas")
String countHours(int difference) {
  int count = (difference / 3600000).truncate();
  return count.toString() + (count > 1 ? ' horas' : ' hora');
}

/// Convierte la diferencia de tiempo a días.
/// Esta función trunca al día más bajo.
///   retorna ("1 día" O "X días")
String countDays(int difference) {
  int count = (difference / 86400000).truncate();
  return count.toString() + (count > 1 ? ' días' : ' día');
}

/// Convierte la diferencia de tiempo a semanas.
/// Esta función trunca a la semana más baja.
///   retorna ("1 semana" O "X semanas" O "1 mes")
String countWeeks(int difference) {
  int count = (difference / 604800000).truncate();
  if (count > 3) {
    return '1 mes';
  }
  return count.toString() + (count > 1 ? ' semanas' : ' semana');
}

/// Convierte la diferencia de tiempo a meses.
/// Esta función redondea al mes más cercano.
///   retorna ("1 mes" O "X meses" O "1 año")
String countMonths(int difference) {
  int count = (difference / 2628003000).round();
  count = count > 0 ? count : 1;
  if (count > 12) {
    return '1 año';
  }
  return count.toString() + (count > 1 ? ' meses' : ' mes');
}

/// Convierte la diferencia de tiempo a años.
/// Esta función trunca al año más bajo.
///   retorna ("1 año" O "X años")
String countYears(int difference) {
  int count = (difference / 31536000000).truncate();
  return count.toString() + (count > 1 ? ' años' : ' año');
}
