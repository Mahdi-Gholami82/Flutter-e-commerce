sealed class ProductsPagingEvent {
  const ProductsPagingEvent();
}

final class ProductsPagingFetchNext extends ProductsPagingEvent {}

final class ProductsPagingRefresh extends ProductsPagingEvent {}
