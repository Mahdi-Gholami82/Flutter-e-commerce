import 'package:digi_meh/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:digi_meh/features/home/domain/use_cases/search_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:stream_transform/stream_transform.dart';

sealed class SearchProductsState {}

class SearchProductsNotLoaded extends SearchProductsState {}

class SearchProductsLoaded extends SearchProductsState {
  ProductsList result;
  SearchProductsLoaded({required this.result});
}

sealed class SearchProductsEvent {}

class SearchProducts extends SearchProductsEvent {
  String query;
  SearchProducts({required this.query});
}

class SearchProductsBloc
    extends Bloc<SearchProductsEvent, SearchProductsState> {
  SearchProductsBloc() : super(SearchProductsNotLoaded()) {
    on<SearchProducts>(
      (event, emit) async {
        emit(SearchProductsNotLoaded());
        var result = await GetIt.instance<SearchProductsUseCase>().execute(
          query: event.query,
        );
        emit(SearchProductsLoaded(result: result));
      },
      transformer: (events, mapper) =>
          events.debounce(const Duration(milliseconds: 300)).switchMap(mapper),
    );
  }
}
