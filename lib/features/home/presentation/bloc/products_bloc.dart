import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:digi_meh/features/home/domain/use_cases/get_products_use_case.dart';

// events
sealed class ProductsBlocEvent {}

class GetProductsEvent extends ProductsBlocEvent {
  GetProductsEvent({required this.pageNumber});
  int pageNumber;
}

// states
sealed class ProductsBlocState {}

class ProductsInitial extends ProductsBlocState {}

class ProductsLoading extends ProductsBlocState {}

class ProductsLoaded extends ProductsBlocState {
  ProductsList result;
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
          pageNumber: event.pageNumber,
        );
        emit(ProductsLoaded(result: result));
      } on DioException catch (dioException) {
        emit(
          ProductsError(
            message: "$dioException \nUri : ${dioException.requestOptions.uri}",
          ),
        );
      } catch (e) {
        emit(ProductsError(message: e.toString()));
      }
    });
  }
}
