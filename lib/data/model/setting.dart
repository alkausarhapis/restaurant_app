class Setting {
  final bool notificationEnable;
  final bool isDarkTheme;
  final int notificationHour;
  final int notificationMinute;

  Setting({
    this.notificationEnable = false,
    this.isDarkTheme = false,
    this.notificationHour = 11,
    this.notificationMinute = 0,
  });

  Setting copyWith({
    bool? notificationEnable,
    bool? isDarkTheme,
    int? notificationHour,
    int? notificationMinute,
  }) {
    return Setting(
      notificationEnable: notificationEnable ?? this.notificationEnable,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
    );
  }
}
