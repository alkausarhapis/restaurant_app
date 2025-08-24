enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  searchRoute("/search"),
  addReviewRoute("/review");

  const NavigationRoute(this.name);
  final String name;
}
