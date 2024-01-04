// ViewModel class

import 'package:sausage_shop/extensions/date_time.dart';
import 'package:sausage_shop/models/sausage.dart';

// Meal time enum based on the current time
enum MealTime {
  breakfast,
  lunch,
  snack,
  dinner,
  closed,
}
// Meal time message based on the current time
extension MealTimeExtension on MealTime {
  String get message {
    final String msg;
    switch (this) {
      case MealTime.breakfast:
        msg = "It's a breakfast time";
        break;
      case MealTime.lunch:
        msg = "It's a lunch time";
        break;
      case MealTime.snack:
        msg = "It's a snack time";
        break;
      case MealTime.dinner:
        msg = "It's a dinner time";
        break;
      case MealTime.closed:
        msg =
            "Sorry the shop is closed. Please come back on opening times from 9:00 to 22:00";
        break;
    }
    return msg;
  }
}

/* This class model is used to display data in shop detail 
and user inputs are also stored in this such as isSelectedEatInType, orderQty
Data is then stored and retrieved in form of this model in cart list */

class SausageRollViewModel {
  // not final because its mutable when saving data with random factor
  int itemId;
  final String itemCode;
  final String shopCode;
  final String availabilityDetail;
  final String itemName;
  final double eatInPrice;
  final double eatOutPrice;
  // not final because its mutable from user input
  bool isSelectedEatInType;
  final String internalDesc;
  final String customerDesc;
  final String imgUrl;
  final String thumbImgUrl;
  // not final because its mutable from user input
  int orderQty;

  SausageRollViewModel({
    this.itemId = 0,
    required this.itemCode,
    required this.shopCode,
    required this.availabilityDetail,
    required this.itemName,
    required this.eatInPrice,
    required this.eatOutPrice,
    required this.internalDesc,
    required this.customerDesc,
    required this.imgUrl,
    required this.thumbImgUrl,
    this.isSelectedEatInType = true,
    this.orderQty = 0,
  });

  // for copying the reference
  SausageRollViewModel copyWith({
  int? itemId, 
  final String? itemCode,
  final String? shopCode,
  final String? availabilityDetail,
  final String? itemName,
  final double? eatInPrice,
  final double? eatOutPrice,
  bool? isSelectedEatInType,
  final String? internalDesc,
  final String? customerDesc,
  final String? imgUrl,
  final String? thumbImgUrl,
  int? orderQty,
  }) {
    return SausageRollViewModel(
    itemId: itemId ?? this.itemId,
    itemCode: itemCode ?? this.itemCode,
    shopCode: shopCode ?? this.shopCode,
    availabilityDetail: availabilityDetail ?? this.availabilityDetail,
    itemName: itemName ?? this.itemName,
    eatInPrice: eatInPrice ?? this.eatInPrice,
    eatOutPrice: eatOutPrice ?? this.eatOutPrice,
    internalDesc: internalDesc ?? this.internalDesc,
    customerDesc: customerDesc ?? this.customerDesc,
    imgUrl: imgUrl ?? this.imgUrl,
    thumbImgUrl: thumbImgUrl ?? this.thumbImgUrl,
    isSelectedEatInType: isSelectedEatInType ?? this.isSelectedEatInType,
    orderQty: orderQty ?? this.orderQty,
  );
  }

  // Conversion of the data from SausageRoll to SausageRollViewModel
  factory SausageRollViewModel.fromSausageRoll(SausageRoll sausageRoll) {
    return SausageRollViewModel(
        itemCode: sausageRoll.articleCode,
        shopCode: sausageRoll.shopCode,
        availabilityDetail: _getAvailabilityDetails(sausageRoll),
        itemName: sausageRoll.articleName,
        eatInPrice: sausageRoll.eatInPrice,
        eatOutPrice: sausageRoll.eatOutPrice,
        internalDesc: sausageRoll.internalDescription,
        customerDesc: sausageRoll.customerDescription,
        imgUrl: sausageRoll.imageUri,
        thumbImgUrl: sausageRoll.thumbnailUri);
  }

  // Conversion of the data from Json to SausageRollViewModel
  factory SausageRollViewModel.fromJson(Map<String, dynamic> json) {
    return SausageRollViewModel(
      itemCode: json['itemCode'],
      shopCode: json['shopCode'],
      availabilityDetail: json['availabilityDetail'],
      itemName: json['itemName'],
      eatInPrice: json['eatInPrice'].toDouble(),
      eatOutPrice: json['eatOutPrice'].toDouble(),
      internalDesc: json['internalDesc'],
      customerDesc: json['customerDesc'],
      imgUrl: json['imgUrl'],
      thumbImgUrl: json['thumbImgUrl'],
      isSelectedEatInType: json['isSelectedEatInType'] ?? true,
      orderQty: json['orderQty'] ?? 0,
      itemId: json['itemId'] ?? 0,
    );
  }

  // Conversion of the data from SausageRollViewModel to Map
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemCode': itemCode,
      'shopCode': shopCode,
      'availabilityDetail': availabilityDetail,
      'itemName': itemName,
      'eatInPrice': eatInPrice,
      'eatOutPrice': eatOutPrice,
      'isSelectedEatInType': isSelectedEatInType,
      'internalDesc': internalDesc,
      'customerDesc': customerDesc,
      'imgUrl': imgUrl,
      'thumbImgUrl': thumbImgUrl,
      'orderQty': orderQty,
    };
  }

  // Check the availability of the sausage and meal time
  static String _getAvailabilityDetails(SausageRoll sausageRoll) {
    final isAvailable = _checkAvailability(
        sausageRoll.availableFrom, sausageRoll.availableUntil);
    final partOfMeal = _checkPartOfTheDay();
    final String mealMsg;
    if (partOfMeal == MealTime.closed) {
      mealMsg = MealTime.closed.message;
    } else if (isAvailable == false) {
      mealMsg = "Sorry this item is not available today";
    } else {
      mealMsg = "Yes, This item is available today and ${partOfMeal.message}";
    }
    return mealMsg;
  }

  // Check the availability of the sausage based on current date time
  static bool _checkAvailability(DateTime fromDate, DateTime toDate) {
    final todayDate = DateTime.now();
    return todayDate.isBetween(from: fromDate, to: toDate);
  }

  // dynamically check the part of the meal
  static MealTime _checkPartOfTheDay() {
    final hour = DateTime.now().hour;

    final Map<MealTime, List<int>> timeRanges = {
      MealTime.breakfast: [5, 11],
      MealTime.lunch: [11, 16],
      MealTime.snack: [16, 19],
      MealTime.dinner: [19, 22],
    };

    final meal = timeRanges.entries.firstWhere(
      (entry) => hour >= entry.value[0] && hour < entry.value[1],
      orElse: () => const MapEntry(MealTime.closed, [0, 0]),
    );

    return meal.key;
  }

  // dynamically get total price based on the calculation
  double get totalPrice {
    final selectedPrice = isSelectedEatInType ? eatInPrice : eatOutPrice;
    return selectedPrice * orderQty;
  }
}

// dynamically get total price from list of model
extension SausageListExtension on List<SausageRollViewModel> {
  double get totalPrice {
    return fold(0, (total, sausage) => total + sausage.totalPrice);
  }
}
