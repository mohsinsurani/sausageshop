import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sausage_shop/constant.dart';
import 'package:sausage_shop/models/sausage.dart';
import 'package:sausage_shop/viewmodels/sausage_view_model.dart';

import '../../../utils/shared_preferences_util.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  late SausageRollViewModel sausageRollViewModel;

  ShopBloc() : super(const ShopInitialState()) {
    on<ShopInitial>((event, emit) async {
      await _loadShopData(emit);
    });
    on<ShopEatChangeEvent>((event, emit) async {
      _eatChange(event, emit, event.isSelectedEatInType);
    });
    on<OrderQtyChangeEvent>((event, emit) async {
      _orderQtyChange(event, emit, event.isIncrement);
    });
    on<AddSausageEvent>((event, emit) {
      _saveSausage(event, emit);
    });
  }

  // saving sausages from the shop detail screen
  void _saveSausage(ShopEvent event, Emitter<ShopState> emit) async {
    try {
      sausageRollViewModel.itemId = Random().nextInt(100) + 1; //random Item Id 
      SharedPreferencesService().saveSausage(sausageRollViewModel);
      emit(const SausageCartState(isSuccess: true));
    } catch (e) {
      emit(
          SausageCartState(isSuccess: false, errorMsg: "Fail to add data: $e"));
    }
  }

  // loading shop data from the json provided
  Future<void> _loadShopData(Emitter<ShopState> emit) async {
    try {
      final sausageData = await loadSausageData();
      if (sausageData == null) {
        emit(const NoDataState(msg: "No data to load sausage"));
      } else {
        sausageRollViewModel = sausageData;
        emit(ShopLoaded(sausageRollModel: sausageData));
      }
    } catch (e) {
      emit(NoDataState(msg: 'Failed to load sausage data: $e'));
    }
  }

  // eat in type change from the screen
  void _eatChange(
      ShopEvent event, Emitter<ShopState> emit, bool selectedIndex) {
    sausageRollViewModel.isSelectedEatInType = selectedIndex;
    emit(ShopLoaded(sausageRollModel: sausageRollViewModel));
  }

  // order quantity change
  void _orderQtyChange(
      ShopEvent event, Emitter<ShopState> emit, bool toIncrement) {
    sausageRollViewModel.orderQty =
        sausageRollViewModel.orderQty + (toIncrement ? 1 : -1);
    emit(ShopLoaded(sausageRollModel: sausageRollViewModel));
  }

  // loading sausage data from the shared preference
  Future<SausageRollViewModel?> loadSausageData() async {
    try {
      final String response =
          await rootBundle.loadString(GregData.sausage.json);
      final data = await json.decode(response) as Map<String, dynamic>;
      final sausageRollDataModel = SausageRoll.fromJson(data);
      final sausageRollVM =
          SausageRollViewModel.fromSausageRoll(sausageRollDataModel);
      return sausageRollVM;
    } catch (ex) {
      if (kDebugMode) {
        print('exception: $ex');
      }
      rethrow;
    }
  }
}
