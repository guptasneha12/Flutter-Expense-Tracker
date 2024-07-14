// this file is used to describe which kind of data structure of expense should have
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // uuid is the package to generate the unique id dynammically
import 'package:intl/intl.dart'; // to generate the formatted date

final formatter = DateFormat.yMd(); //it is the utility object

const uuid = Uuid();

enum Category { food, travel, leisure, work } // this is the custom type

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

// it is not a widget
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
  // constructor having named parameter
  // we need to create a unique id dynammically
  final String id; // to delete particular expense
  final String title;
  final double amount; // to add decimal no.
  final DateTime date; // to store date information
  final Category category;

// method to format date
  String get formattedDate {
    return formatter.format(date);
  }
}

// we have 1 bucket per category
// to create a bunch of similar category and sum up all and placed it into single container
class ExpenseBucket {
  // constructor
  const ExpenseBucket({required this.category, required this.expenses});


// alenative constructor function to filtering out the expenses that belongs to particular category
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where((expense) =>
            expense.category==category
            ).toList(); // this is the extra constructor function used inside of my current class


  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
