part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

final class ShopInitialState extends ShopState {

  const ShopInitialState();
  
  @override
  List<Object> get props => [];
}

final class NoDataState extends ShopState {
  final String msg;

  const NoDataState({required this.msg});
  
  @override
  List<Object> get props => [String];
}

final class ShopLoaded extends ShopState {
  final SausageRollViewModel sausageRollModel;

  const ShopLoaded({required this.sausageRollModel});

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class SausageCartState extends ShopState {
  final bool isSuccess;
  final String? errorMsg;

  const SausageCartState({required this.isSuccess, this.errorMsg});

  @override
  List<Object> get props => [bool];
}