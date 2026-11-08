import 'package:digi_meh/features/cart/presentation/bloc/prefs_cart_bloc_event.dart';
import 'package:digi_meh/features/cart/presentation/bloc/prefs_cart_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:digi_meh/core/data/repositories/preferences_repository.dart';
import 'package:digi_meh/features/cart/domain/entities/cart_item_entity.dart';

class PrefsCartBloc extends Bloc<PrefsCartBlocEvent, PrefsCartBlocState> {
  PrefsCartBloc() : super(CartBlocInitial()) {
    on<PrefsCartBlocLoad>((event, emit) async {
      final PreferencesRepository prefsRepo =
          GetIt.instance<PreferencesRepository>();
      List<Future<CartItem>> cartItemsLoading = prefsRepo.getCartItems();
      emit(
        CartBlocPrefsLoading(
          cartItemsLoading: cartItemsLoading,
          lenght: cartItemsLoading.length,
        ),
      );
      final List<CartItem> result = await Future.wait(cartItemsLoading);
      emit(PrefsCartBlocFullyLoaded(cartItems: result));
    });
  }
}
