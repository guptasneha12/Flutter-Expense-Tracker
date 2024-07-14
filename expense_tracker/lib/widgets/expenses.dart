// create main user interface

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

// it is stateful widget because we add new expenses each time
class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

// method overlay on clicking + button of appbar
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,     // to avoid the overlapping of device features with the UI
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ), // this is dispalyed when we click on + button
    );
  }

// to add expense in the list
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

// remove expense internally is called whenever the list is dismiss or swipe out
  void _removeExpense(Expense expense) {
    final expenseIndex=_registeredExpenses.indexOf(expense);    // position of the list to be removed
    setState(() {
      // remove the added expenses
      _registeredExpenses.remove(expense);
    });

ScaffoldMessenger.of(context).clearSnackBars();

    // it is the utility object which is used for showing or hiding certain UI elements
    // it is the message which is dispalyed at the bottom when we delete a list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration:const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (){
            setState(() {
              _registeredExpenses.insert(expenseIndex,expense);     // to undo the deleted list at its original position
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
final width=MediaQuery.of(context).size.width;    // to get the width of screen
// print(MediaQuery.of(context).size.height);    // to get the height of screen


    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        // it is used to set toolbar at the top of body just like header and it allows only limited widgets
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          // it takes the list of widget
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:width <600? Column(
        children: [
          // toolbar with the add button =>Row() widget

          Chart(expenses:_registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ) : Row(children: [
          Expanded(child: Chart(expenses:_registeredExpenses),),
          Expanded(
            child: mainContent,
          ),
      ],),
    );
  }
}
