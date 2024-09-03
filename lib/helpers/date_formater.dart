import 'package:intl/intl.dart';

class DateFormater{
  static String formatOrderDate(String date){
     var inputFormat = DateTime.parse(date);
    var outputFormat = DateFormat('hh:mm a yyyy/MM/dd');
    var outputDate = outputFormat.format(inputFormat);
    return outputDate;
  }
}