import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class Transactionitem extends StatefulWidget {
  const Transactionitem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<Transactionitem> createState() => _TransactionitemState();
}

class _TransactionitemState extends State<Transactionitem> {
  Color? _bgColor;
  @override
  void initState() {
    const availableColor = [
      Colors.green,
      Colors.blue,
      Colors.pink,
      Colors.yellow,
      Colors.orange,
    ];
    super.initState();
    _bgColor = availableColor[Random().nextInt(5)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        //displaying the object in a ciecular avatar
        //leading content of card
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount}'),
            ),
          ),
        ),

        //main content of card
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),

        //the trailing content of the card
        trailing: MediaQuery.of(context).size.width > 411
            ? TextButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).errorColor,
                ),
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => widget.deleteTx(widget.transaction.id),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
