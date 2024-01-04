/* This class model is used to encode and decode data from the json provided */

class SausageRoll {
  String articleCode;
  String shopCode;
  DateTime availableFrom;
  DateTime availableUntil;
  double eatOutPrice;
  double eatInPrice;
  String articleName;
  List<String> dayParts;
  String internalDescription;
  String customerDescription;
  String imageUri;
  String thumbnailUri;

  SausageRoll({
    required this.articleCode,
    required this.shopCode,
    required this.availableFrom,
    required this.availableUntil,
    required this.eatOutPrice,
    required this.eatInPrice,
    required this.articleName,
    required this.dayParts,
    required this.internalDescription,
    required this.customerDescription,
    required this.imageUri,
    required this.thumbnailUri,
  });

  // Converting json to Model
  factory SausageRoll.fromJson(Map<String, dynamic> json) {
    return SausageRoll(
      articleCode: json['articleCode'],
      shopCode: json['shopCode'],
      availableFrom: DateTime.parse(json['availableFrom']),
      availableUntil: DateTime.parse(json['availableUntil']),
      eatOutPrice: json['eatOutPrice'].toDouble(),
      eatInPrice: json['eatInPrice'].toDouble(),
      articleName: json['articleName'],
      dayParts: List<String>.from(json['dayParts']),
      internalDescription: json['internalDescription'],
      customerDescription: json['customerDescription'],
      imageUri: json['imageUri'],
      thumbnailUri: json['thumbnailUri'],
    );
  }

  // Getting Map from the model
  Map<String, dynamic> toJson() {
    return {
      'articleCode': articleCode,
      'shopCode': shopCode,
      'availableFrom': availableFrom.toIso8601String(),
      'availableUntil': availableUntil.toIso8601String(),
      'eatOutPrice': eatOutPrice,
      'eatInPrice': eatInPrice,
      'articleName': articleName,
      'dayParts': dayParts,
      'internalDescription': internalDescription,
      'customerDescription': customerDescription,
      'imageUri': imageUri,
      'thumbnailUri': thumbnailUri,
    };
  }
}
