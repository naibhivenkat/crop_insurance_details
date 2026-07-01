import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerModel {
  final String id;

  final int slNo;

  final String name;

  final String address;

  final String mobile;

  final Timestamp date;

  final double totalAmount;

  final String status;

  final String ackNo;

  final String remarks;
  final String paymentMethod;

  FarmerModel({
    required this.id,
    required this.slNo,
    required this.name,
    required this.address,
    required this.mobile,
    
    required this.date,
    required this.totalAmount,
    this.status = "Pending",
    this.ackNo = "",
    this.remarks = "", 
     required this.paymentMethod,

  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "slNo": slNo,
      "name": name,
      "address": address,
      "mobile": mobile,
      "date": date,
      "totalAmount": totalAmount,

      // New fields
      "status": status,
      "ackNo": ackNo,
      "remarks": remarks,
    };
  }

  factory FarmerModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return FarmerModel(
      id: map["id"],
      slNo: map["slNo"],
      name: map["name"],
      address: map["address"],
      mobile: map["mobile"],
      date: map["date"],
      totalAmount:
          (map["totalAmount"] as num).toDouble(),

      status: map["status"] ?? "Pending",

      ackNo: map["ackNo"] ?? "",

      remarks: map["remarks"] ?? "",
      paymentMethod: map["paymentMethod"] ?? ""
    );
  }

  Map<String, dynamic> toExcelMap() {
    return {
      "ID": id,
      "Sl No": slNo,
      "Name": name,
      "Address": address,
      "Mobile": mobile,
      "Date": date,
      "Total Amount": totalAmount,
      "Status": status,
      "Acknowledgement": ackNo,
      "Remarks": remarks,
    };
  }
}