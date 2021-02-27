// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  Employee({
    this.name,
    this.contactno,
    this.email,
    this.imageUrl,
  });

  String name;
  String contactno;
  String email;
  String imageUrl;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        name: json["name"],
        contactno: json["contactno"],
        email: json["email"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "contactno": contactno,
        "email": email,
        "imageUrl": imageUrl,
      };
}
