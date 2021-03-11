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
    this.photoUrl,
  });

  String name;
  String contactno;
  String email;
  String photoUrl;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        name: json["name"],
        contactno: json["contactno"],
        email: json["email"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "contactno": contactno,
        "email": email,
        "photoUrl": photoUrl,
      };
}
