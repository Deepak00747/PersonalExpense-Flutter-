import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/transaction_list.dart';
import './widgets/new_Transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // to fix the rotation of the devive
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Personal Expenses',
      theme: ThemeData(
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          //for body
          bodyText2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          //for button
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.amber),
      ),
      //floating action button isinternally configured to take accent color and
      //if not available then to fall back to primary color.
      home: MyHomePage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'NewShoes',
      amount: 58.54,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Laptop',
      amount: 100.97,
      date: DateTime.now(),
    ),
    // Transaction(
    //   id: 't3',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't4',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't5',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't6',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't7',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't8',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't9',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't10',
    //   title: 'NewShoes',
    //   amount: 58.54,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = true;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//calculating the date and time from now for chart bar filling.
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

//Adding new transcation to the _userTransaction.
  void _addNewTransaction(
      String Txtitle, double TxAmount, DateTime choosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: Txtitle,
        amount: TxAmount,
        date: choosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

//to add when clicked on the + icon on the screen
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        //to move the entire show modal to top when soft keyboard is open.

        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

//when viewed in landscape mode

  List<Widget> _buildLandScapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart'),
          //switch creates a switch on screen
          Switch.adaptive(
              //.adaptive converts between android and ios automatically depending on the system it is at runtime
              activeColor: Theme.of(context).colorScheme.secondary,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),

      //logic to show the chart based on the switch
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  //when device in portrait mode
  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

//Appbar logic
  Widget _buildAppbar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('IOS app'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: (() => _startAddNewTransaction(context)),
                child: const Icon(CupertinoIcons.add),
              )
            ]),
          )
        : AppBar(
            title: const Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                onPressed: (() => _startAddNewTransaction(context)),
                icon: const Icon(Icons.add),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    // print("build myhome page state");
    // backgroundColor: Colors.black,
    //Orientation is enum provided by material.dart which has value 0 or 1.
    //it is recalculated whenever flutter rebuilds UI.
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = _buildAppbar();

    //logic for list view of transaction items on screen
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    //contains the logic for the body of the app to tell it if to build in landscape
    //or portrait mode
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //column always takes the size of its brodest/ widest child.
          children: <Widget>[
            // ignore: sized_box_for_whitespace

            if (isLandScape)
              //this if statement is special. it doesnot takecurly braces
              //its a speccial if inside a list syntax.
              ..._buildLandScapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandScape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
            //Adding the spread operator to tell dart that we want to pull all the elements out
            //and merge them as single elements into that surrounding list which we have here.
            //basically means instead of adding list to a list we are adding all the items of the
            //list as a single item.
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            backgroundColor: Colors.tealAccent,
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform
                    .isIOS //to check if the platform is IOS or Android and render the button accordingly
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: (() => _startAddNewTransaction(context)),
                  ),
          );
  }
}
