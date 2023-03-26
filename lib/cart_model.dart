

class CartModal{

  late final int? id;
  late final int? productId;
  late final String? productName;
  late final int? initialPrice;
  late final int? productPrice;
  late final int? productQuantity;
  late final String? unitTag;
  late final String? productImage;

  CartModal({
    this.id,
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.productQuantity,
    required this.unitTag,
    required this.productImage
  });

  // CartModal.fromMap(Map<dynamic, dynamic> res)
  // : id = res['id'],
  // productId = res['productId'],
  // productName = res['productName'],
  // initialPrice = res['initialPrice'],
  // productPrice = res['productPrice'],
  // productQuantity = res['productQuantity'],
  // unitTag = res['unitTag'],
  // productImage = res['productImage'];

  factory CartModal.fromJson(Map<String, dynamic> map) {
    return CartModal(
        id : map['Id'] as int,
        productId: map['productId'] as int,
        productName: map['productName'] as String,
        initialPrice: map['initialPrice'] as int,
        productPrice: map['productPrice'] as int,
        productQuantity: map['productQuantity'] as int,
        unitTag: map['unitTag'] as String,
        productImage: map['productImage'] as String
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'unitTag': unitTag,
      'productImage': productImage
    };
  }
}
