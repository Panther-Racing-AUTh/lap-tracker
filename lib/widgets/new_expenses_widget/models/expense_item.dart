import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseItem{
  final String name;
  final double amount;
  final DateTime dateTime;
  final String category;
  final String location;

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.location,
    required this.category,
  });


}

