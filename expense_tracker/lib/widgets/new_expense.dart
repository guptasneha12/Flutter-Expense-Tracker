import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // to generate the formatted date

final formatter = DateFormat.yMd(); //it is the utility object

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
//   var _enteredTitle='';
// void _saveTitleInput(String inputValue){
// // input value is the value passed by the user
// _enteredTitle=inputValue;
// }

  final _titleController =
      TextEditingController(); // for handeling the user input

  final _amountController =
      TextEditingController(); // for handeling the amount input by the user

  DateTime?
      _selectedDate; //it means either to store selected date or store nothing

// to manage category manually
  Category _selectedCategory = Category.leisure;

// function to create date picker
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, initialDate: now, firstDate: firstDate, lastDate: now
        // )            .then((value){}// this function is executed once we pick a date value
        );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

// for validation of input fields
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController
        .text); // try parse is the method to convert the string to a number to double or it return null if it is not able to convert it
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;

// validate the data selected by user
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      // show error message
      // it shows some pop up
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered...'),
          actions: [
            // buttons on dialog box used to close the dialog
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );

      return;
    }

    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );

// after adding a new expense it is must that overlay is closed
Navigator.pop(context);

  }

  @override
// this is the method to tell flutter that dispose texteditingcontroller when overlay closes
  void dispose() {
    _titleController
        .dispose(); // to tell the flutter that this is not needed anymore
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
   final keyboardSpace=MediaQuery.of(context).viewInsets.bottom;  // it gives the info about amount of space taken by keyboard form bottom
    return LayoutBuilder(builder: (ctx,constraints){
    final width=constraints.maxWidth; 

      return  SizedBox(     // to get the full screen mode of model view
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16,16,16,keyboardSpace+16),
          child: Column(
            children: [
              
              // Row(
              //   crossAxisAlignment:CrossAxisAlignment.start ,
              //   children: [
              //    TextField(
              //   // it is the widget that allow the user to add some text
              //   controller: _titleController,
              //   maxLength: 50,
              //   decoration: const InputDecoration(
              //     // decoration is the widget which is used to set the label of input field
              //     label: Text('Title'),
              //   ),
              // ),
              // const SizedBox(width: 50,),
              //  Expanded(
              //    child: TextField(
              //           // it is the widget that allow the user to add some text
              //           controller: _amountController,
              //           keyboardType: TextInputType.number,
              //           decoration: const InputDecoration(
              //             // decoration is the widget which is used to set the label of input field
              //             prefixText:
              //                 '\$ ', // to add the $ sign before every amount entered
              //             label: Text('Amount'),
              //           ),
              //         ),
              //  )
              // ],
              // )


              
            
              TextField(
                // it is the widget that allow the user to add some text
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  // decoration is the widget which is used to set the label of input field
                  label: Text('Title'),
                ),
              ),
              // adding a date input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      // it is the widget that allow the user to add some text
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        // decoration is the widget which is used to set the label of input field
                        prefixText:
                            '\$ ', // to add the $ sign before every amount entered
                        label: Text('Amount'),
                      ),
                    ),
                  ),
        
                  // date picker
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!),
                        ), // ! tells that it should not be null
                        IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(
                              Icons.calendar_month,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value:
                                  category, // to store the value selected by the user and is not visible to the users
                              child: Text(category.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // pop remove the overlay from the screen
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text(
                        'Save Expense',
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
    });
    

  }
}
