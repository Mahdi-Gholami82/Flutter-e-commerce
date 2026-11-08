import 'package:digi_meh/features/home/domain/use_cases/search_products_use_case.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_event.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:stream_transform/stream_transform.dart';

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
