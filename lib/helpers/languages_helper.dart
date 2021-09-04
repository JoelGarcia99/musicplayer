enum AvailableLan {
  Spanish,
  English
}

class LanguageHelper {

  static String getLanNameByPrefix(String prefix) {
    switch(prefix) {
      case "es": return "Español";
      case "en": return "English";
      default: return "English";
    }
  }

  static String getLanName(AvailableLan lan) {
    switch(lan) {
      case AvailableLan.Spanish: return "Español";
      case AvailableLan.English: return "English";
    }
  }

  static String getLanPrefix(AvailableLan lan) {
    switch(lan) {
      case AvailableLan.Spanish: return "es";
      case AvailableLan.English: return "en";
    }
  }
}