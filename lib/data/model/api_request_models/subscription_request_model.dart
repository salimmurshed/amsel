class SubscriptionData {
  final String productId, transactionId,  nextProductId;
  final String? purchaseToken, status;
  final DateTime? expiryDate;

  SubscriptionData({required this.productId,
    required this.transactionId, this.purchaseToken,
    required this.nextProductId, this.status, this.expiryDate
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      productId: json["productId"],
      transactionId: json["transactionId"],
      purchaseToken: json["purchaseToken"],
      nextProductId: json["nextProductId"],
      status: json["status"],
      expiryDate: json["expiryDate"] != null ? DateTime.parse(json["expiryDate"]) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "transactionId": transactionId,
      "purchaseToken": purchaseToken,
      "nextProductId": nextProductId,
      "status": status,
      "expiryDate": expiryDate?.toIso8601String()
    };
  }
}
