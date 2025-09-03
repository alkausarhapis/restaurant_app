enum NavigationRoute {
  mainRoute("/"),
  homeRoute("/home"),
  detailRoute("/detail"),
  searchRoute("/search"),
  settingRoute("/setting"),
  favoriteRoute("/favorite"),
  addReviewRoute("/review");

  const NavigationRoute(this.name);
  final String name;
}
