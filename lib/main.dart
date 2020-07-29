import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gastos/widgets/chart.dart';
import 'package:gastos/widgets/new_transaction.dart';
import 'package:gastos/widgets/transaction_list.dart';
import 'package:gastos/models/transaction.dart';



void main() {
/*   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
    ]); */
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gastos Personales',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.blueGrey[700],
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(headline1: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 18 ),),
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans', 
            fontSize: 20,
            //fontWeight: FontWeight.bold
            ),
        button: TextStyle(color: Colors.white),
            ),           
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

//String titleInput;
//String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

final List<Transaction> _userTransactions = [
/*     Transaction(
       id: 't1', 
       title: 'New Shoes', 
       amount: 69.99, 
       date:  DateTime.now(),),
    Transaction(
       id: 't2', 
       title: 'New Phone', 
       amount: 25.99, 
       date:  DateTime.now(),
       ) */
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7)
          )
        );
    }).toList();
  }

//Metodo para pasar valores al constructor de transaction
  void _addNewTransaction(String txTitle, double txAmount, DateTime choseDate){
    final newTx = Transaction(
      id: DateTime.now().toString(), 
      title: txTitle, 
      amount: txAmount, 
      date: choseDate, 
      );
      setState(() {
        _userTransactions.add(newTx);
      });
  }


void _startAddNewTransaction(BuildContext ctx) {
  showModalBottomSheet(
  context: ctx, 
  builder: (_) {
    return NewTransaction(_addNewTransaction);
  });
}

void _deleteTransaction(String id){
  setState(() {
    _userTransactions.removeWhere((tx) {
      return tx.id == id;
    });
  });

}

Widget _buildAppBar(){
  return Platform.isIOS 
    ? CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        GestureDetector(
          child: Icon(CupertinoIcons.add),
          onTap: () => _startAddNewTransaction(context),)
      ]),
    ) 
    : AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
}

List <Widget> _buildLandscapeContent(
  MediaQueryData mediaQuery, 
  AppBar appBar,
  Widget txListWidget
){
  
  return  [Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Text(
                'Show Chart',
                  style: Theme.of(context).textTheme.bodyText1),
                  Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ), 
              _showChart 
              ?  Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions),
                  )
                : txListWidget 
           ];

}

List <Widget> _buildPorratitContent(
  MediaQueryData mediaQuery, 
  AppBar appBar,
  Widget txListWidget
  ) {

  return [Container(
          height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
             0.3,
          child: Chart(_recentTransactions),
      ), txListWidget];
}

@override
  Widget build(BuildContext context) {
    print('build() MyHomePage');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    //SAfe area para cupertino respete el notch
    final pageBody = SafeArea(child:SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) 
            ... _buildLandscapeContent(
              mediaQuery, 
              appBar, 
              txListWidget),
            if (!isLandscape) 
            ... _buildPorratitContent(
              mediaQuery, 
              appBar, 
              txListWidget),
          ]
        ),
      ),
      );
    return Platform.isIOS 
    ? CupertinoPageScaffold(child: pageBody,
      navigationBar: 
      appBar,) 
    : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //validar si esta en iOS se esconda el floating button
      floatingActionButton: Platform.isIOS 
      ? Container() 
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
