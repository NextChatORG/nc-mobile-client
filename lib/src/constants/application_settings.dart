class ApplicationSettings {
  static const baseAPIUrl = "http://192.168.1.3:3000";

  static final usernameRegexp = RegExp(r'^[a-zA-Z0-9_]*$');
  static final passwordRegexp = RegExp(r'^\S+$');
}
