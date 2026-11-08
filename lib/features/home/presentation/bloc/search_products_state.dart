import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';

sealed class SearchProductsState {}

class SearchProductsNotLoaded extends SearchProductsState {}

class SearchProductsLoaded extends SearchProductsState {
  ProductsList result;
  SearchProductsLoaded({required this.result});
}
