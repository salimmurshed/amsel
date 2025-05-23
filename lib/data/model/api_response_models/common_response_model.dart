class CommonResponseModel {
  bool? status;
  String? message;

  CommonResponseModel({
    this.status,
    this.message,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}