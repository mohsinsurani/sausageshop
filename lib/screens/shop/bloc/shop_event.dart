part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopEvent {}

class LoadShopData extends ShopEvent {}

class ShopEatChangeEvent extends ShopEvent {
  final bool isSelectedEatInType;

  const ShopEatChangeEvent({required this.isSelectedEatInType});

  @override
  List<Object> get props => [bool];
}

class OrderQtyChangeEvent extends ShopEvent {
  final bool isIncrement;

  const OrderQtyChangeEvent({required this.isIncrement});

  @override
  List<Object> get props => [bool];
}

class AddSausageEvent extends ShopEvent {
  const AddSausageEvent();

  @override
  List<Object> get props => [];
}
