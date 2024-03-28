
class DataFormatter {
  static const Map<int, String> monthNames = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  static int countSentences(String text) {
    if (text.isEmpty) return 0;
    
    final RegExp sentenceEndPattern = RegExp(r'[.!?]');
    final List<String> sentences = text.split(sentenceEndPattern);
    sentences.removeWhere((sentence) => sentence.trim().isEmpty);
    return sentences.length;
  }

  static int calculateAge(String birthDateStr) {
    List<String> parts = birthDateStr.split("-");
    int birthYear = int.parse(parts[0]);
    int birthMonth = int.parse(parts[1]);
    int birthDay = int.parse(parts[2]);

    DateTime today = DateTime.now();
    int currentYear = today.year;
    int currentMonth = today.month;
    int currentDay = today.day;

    int age = currentYear - birthYear;

    if (currentMonth < birthMonth ||
        (currentMonth == birthMonth && currentDay < birthDay)) {
      age--;
    }

    return age;
  }

  static String formatDate(String dateStr) {
    List<String> parts = dateStr.split("-");
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    String monthStr = monthNames[month] ?? "";

    return "$day $monthStr $year";
  }

  static bool isCorrectDateString(String? date) {
    if (date == null) return false;
    RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    
    return regex.hasMatch(date);
  }

  static String getYearFromDate(String date) {
    List<String> parts = date.split('-');

    int year = int.tryParse(parts.first) ?? 0;
    
    if (year == 0) return "Unknown";
    return year.toString();
  }
}
