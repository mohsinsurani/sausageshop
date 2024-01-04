import 'package:flutter_test/flutter_test.dart';
import 'package:sausage_shop/screens/shop/bloc/shop_bloc.dart';
import 'package:sausage_shop/viewmodels/sausage_view_model.dart';
import 'package:mockito/mockito.dart';

class MockShopBloc extends Mock implements ShopBloc {}

double calculateTotalPrice(List<SausageRollViewModel> sausages) {
  double totalPrice = 0.0;
  for (var sausage in sausages) {
    totalPrice += sausage.orderQty *
        (sausage.isSelectedEatInType ? sausage.eatInPrice : sausage.eatOutPrice);
  }
  return totalPrice;
}

void main() {
  group('calculateTotalPrice', () {

    test('should return 0 when the list is empty', () {
      final emptyList = <SausageRollViewModel>[];
      expect(calculateTotalPrice(emptyList), 0.0);
    });

    test('should calculate the correct total price', () async {
      final sausageData = SausageRollViewModel(
          itemCode: '001',
          shopCode: 'Shop01',
          availabilityDetail: 'Available',
          itemName: 'Sausage',
          eatInPrice: 10.0,
          eatOutPrice: 12.0,
          internalDesc: 'Internal Description',
          customerDesc: 'Customer Description',
          imgUrl: 'image-url',
          thumbImgUrl: 'thumb-image-url',
          isSelectedEatInType: true,
          orderQty: 1,
        );
        final sausages = [
          sausageData.copyWith(eatInPrice: 20, isSelectedEatInType: true, orderQty: 1),
          sausageData.copyWith(eatOutPrice: 30, isSelectedEatInType: false, orderQty: 1),
          sausageData.copyWith(eatInPrice: 10, isSelectedEatInType: true, orderQty: 1),
        ];
        expect(calculateTotalPrice(sausages), 60.0);
    });
  });
}
