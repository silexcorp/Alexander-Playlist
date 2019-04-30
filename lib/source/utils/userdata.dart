import 'package:flutter/material.dart';

class UserData {
  String name;
  String mail;
  String pass;
  bool isActive;

  UserData({
    this.name = '',
    this.mail = '',
    this.pass = '',
    this.isActive = false,
  });
}