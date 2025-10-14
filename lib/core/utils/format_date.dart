import 'package:intl/intl.dart';

String formatDateBydMMYYYY(DateTime dateTime){
  return DateFormat("d MMM, yyyy").format(dateTime);
}