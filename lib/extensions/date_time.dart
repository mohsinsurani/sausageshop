/* data extension to dynamically check the availability of the items in this case */
extension DateTimeExtension on DateTime {
  bool isAfterOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isAfter(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isBefore(other);
  }
  
  bool isBetween({required DateTime from, required DateTime to}) {
    return isAfterOrEqual(from) && isBeforeOrEqual(to);
  }
}