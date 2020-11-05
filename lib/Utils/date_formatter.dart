import 'package:intl/intl.dart';

class DateFormatter{
  static String getCurrentDate(){
    return DateFormat.yMd().format(new DateTime.now());
  }
  static String getFormattedDate(DateTime date){
    return DateFormat.yMd().format(date);
  }
  static DateTime stringToDate(String strDate){
    return new DateFormat("MM/dd/yyyy").parse(strDate);
    // return DateTime.parse(strDate);

  }
}