import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sausage_shop/viewmodels/sausage_view_model.dart';
import 'package:sausage_shop/utils/shared_preferences_util.dart';
import '../../../utils/event_bus.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  late List<SausageRollViewModel> sausageList;

  CartBloc() : super(CartInitial()) {
    on<CartInitialEvent>((event, emit) async {
      await _onLoadItems(event, emit);
    });
    on<RemoveItems>((event, emit) async {
      await _removeItems(event, emit, event.sausageRollViewModel);
    });
    on<ClearItems>((event, emit) async {
      await _clearItems(event, emit);
    });
    on<RefreshCarts>((event, emit) async {
      await _onLoadItems(event, emit);
    });

    eventBus.stream.listen((event) async {
      if (event is RefreshCarts) {
        add(const RefreshCarts());
      }
    }); // Listening to Refreshcart state when emmited from shop detail screen
  }

  // disposing event bus
  @override
  Future<void> close() {
    eventBus.dispose();
    return super.close();
  }

    // Loading data from shared preferences
  Future _onLoadItems(CartEvent event, Emitter<CartState> emit) async {
    sausageList = await SharedPreferencesService().fetchSausages();
    emit(CartLoaded(sausageList: sausageList));
  }

  // Loading removing items as per user action
  Future<void> _removeItems(CartEvent event, Emitter<CartState> emit,
      SausageRollViewModel sausageRollViewModel) async {
    sausageList.removeWhere(
        (element) => element.itemId == sausageRollViewModel.itemId);
    await SharedPreferencesService().saveSausageList(sausageList);
    emit(CartLoaded(sausageList: sausageList));
  }

  // Removing all data from shared preferences
  Future<void> _clearItems(CartEvent event, Emitter<CartState> emit) async {
    sausageList.clear();
    try {
      final isCleared = await SharedPreferencesService().clearData();
      if (isCleared) {
        emit(CartLoaded(sausageList: sausageList));
      } else {
        emit(const CartErrorState(errorMsg: "Something went wrong!"));
      }
    } catch (e) {
      emit(CartErrorState(errorMsg: "Something went wrong! $e"));
    }
  }
}
