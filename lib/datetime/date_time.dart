// devuelve la fecha de hoy como: yyyymmdd
String todaysDateFormatted() {
  // hoy
  var dateTimeObject = DateTime.now();

  // Año en el formato yyyy
  String year = dateTimeObject.year.toString();

  // Mes en el formato mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // Día en el formato dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // formato final
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

//Convierte el string yyyymmdd a un objeto DateTime
DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

// Convierte el objeto DateTime a String yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
  // Año en formato yyyy
  String year = dateTime.year.toString();

  // Mes en formato mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // Día en fomato dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // Formato final
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}