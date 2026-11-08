sealed class SearchProductsEvent {}

class SearchProducts extends SearchProductsEvent {
  String query;
  SearchProducts({required this.query});
}
