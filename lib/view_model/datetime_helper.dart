import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String toStringFromDateTime(DateTime pickedDate) {
    String formatedDate = DateFormat("dd/MM/yyyy").format(pickedDate);
    return formatedDate;
  }

  static Timestamp toTimeStampFromDateTime(DateTime pickedDate) {
    Timestamp myTimeStamp = Timestamp.fromDate(pickedDate);
    return myTimeStamp;
  }

  static String toStringFromTimeStamp(Timestamp myTimeStamp) {
    DateTime myDateTime = myTimeStamp.toDate();
    String formatedDate = toStringFromDateTime(myDateTime);
    return formatedDate;
  }
  static DateTime toDateTimeFromTimeStamp(Timestamp myTimeStamp){
    DateTime myDateTime = myTimeStamp.toDate();
    return myDateTime;
  }
}
