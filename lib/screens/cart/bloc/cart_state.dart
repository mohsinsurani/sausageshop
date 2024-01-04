part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartErrorState extends CartState {
  final String errorMsg;
  const CartErrorState({required this.errorMsg});

  @override
  List<Object> get props => [String];
}


final class CartLoaded extends CartState {
  final List<SausageRollViewModel> sausageList;
  const CartLoaded({required this.sausageList});

  @override
  List<Object> get props => [identityHashCode(this)];
}
