import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/use_cases/get_products_use_case.dart';

// events
sealed class ProductsBlocEvent {}

class GetProductsEvent extends ProductsBlocEvent {
  GetProductsEvent({required this.limit, required this.skip});
  int limit;
  int skip;
}

// states
sealed class ProductsBlocState {}

class ProductsInitial extends ProductsBlocState {}

class ProductsLoading extends ProductsBlocState {}

class ProductsLoaded extends ProductsBlocState {
  List<Product> result;
  ProductsLoaded({required this.result});
}

class ProductsError extends ProductsBlocState {
  ProductsError({required this.message});
  String message;
}

class ProductsBloc extends Bloc<ProductsBlocEvent, ProductsBlocState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      try {
        var result = await GetIt.instance<GetProductsUseCase>().execute(
          limit: event.limit,
          skip: event.skip,
        );
        emit(ProductsLoaded(result: result));
      } on Exception catch (e) {
        emit(ProductsError(message: e.toString()));
      }
    });
  }
}
