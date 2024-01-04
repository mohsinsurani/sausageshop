part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartInitialEvent extends CartEvent {}

class RefreshCarts extends CartEvent {
  const RefreshCarts();

  @override
  List<Object> get props => [];
}

class AddItems extends CartEvent {}

class RemoveItems extends CartEvent {
  final SausageRollViewModel sausageRollViewModel;
  const RemoveItems({required this.sausageRollViewModel});

  @override
  List<Object> get props => [SausageRollViewModel];
}

class ClearItems extends CartEvent {}
