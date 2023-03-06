class OrderSummary {
  final String subtotal;
  final String tax;
  final String deliveryfee;
  final String total;
  final List<OrderItem> items;
  OrderSummary(
      {required this.subtotal,
      required this.tax,
      required this.deliveryfee,
      required this.total,
      required this.items});
  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    var itemsList = json['data']['items'] as List;
    List<OrderItem> items =
        itemsList.map((item) => OrderItem.fromJson(item)).toList();
    return OrderSummary(
        subtotal: json['data']['price breakup']['subtotal'],
        tax: json['data']['price breakup']['tax'],
        deliveryfee: json['data']['price breakup']['delivery_fee'],
        total: json['data']['price breakup']['total'],
        items: items);
  }
}
class OrderItem {
  final String name;
  final String description;
  final String amount;
  final String imageUrl;
  OrderItem(
      {required this.name,
      required this.description,
      required this.amount,
      required this.imageUrl});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        name: json['name'],
        description: json['description'],
        amount: json['amount'],
        imageUrl: json['img']);
  }
}
