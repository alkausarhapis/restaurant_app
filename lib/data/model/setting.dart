class Setting {
  final bool notificationEnable;
  final bool isDarkTheme;

  Setting({required this.notificationEnable, required this.isDarkTheme});

  Setting copyWith({bool? notificationEnable, bool? isDarkTheme}) {
    return Setting(
      notificationEnable: notificationEnable ?? this.notificationEnable,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }
}
