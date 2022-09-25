import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx) {
    // print('constructor new transaction widget');
  }

  @override
  State<NewTransaction> createState() {
    // print('createstate new transaction widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  //records everything on keyboard
  final _textController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  // _NewTransactionState() {
  //   print('constructor new transaction state');
  // }

//   @override
//   void initState() {
//     print('init state ()');
// //used for fetching data some initial data we need in our app or widget of our app.
//     super.initState();  //used in debugging superinit.
//   }

  // @override
  // void didUpdateWidget(NewTransaction oldWidget) {
  //   print('didupdatewidget');
  //   //used less often. for updating
  //   super.didUpdateWidget(oldWidget);
  // }

  // @override
  // void dispose() {
  //   print('disposal ()');
  //   //used for cleaning up data.
  //   super.dispose();
  // }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _textController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
    //even though we dont define context its made availabel because we extend
    //state. context gives access to the context related to widget.
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              right: 10,
              top: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'tle'),
                controller: _textController,
                onSubmitted: (_) => _submitData(),

                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount '),
                controller: _amountController,
                //to display only the number in the soft keypad
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   amountInput = val;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date choosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}'),
                    ),
                    AdaptiveFlatButton('Choose date', _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).textTheme.button?.color,
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: _submitData,
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
