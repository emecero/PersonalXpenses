import 'package:flutter/material.dart';
import 'package:gastos/models/transaction.dart';
import 'package:intl/intl.dart';
import './transaction_item.dart';


class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() Transaction List');
    return   transactions.isEmpty ? 
    LayoutBuilder(builder: (ctx, constraints) {
        return Column(
         children: <Widget>[
            SizedBox(height: 20,),
            Container(
              height: constraints.maxHeight * 0.4,
              child: Image.asset(
                'assets/images/waiting.png', 
                //fit: BoxFit.cover
                )
                ),
             Text('No hay transacciones aún',
             //style: Theme.of(context).textTheme.headline6,
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontWeight: FontWeight.normal,
                fontSize: 18,
                decoration: TextDecoration.none
              )
            ),
             ],
           );
          
    })
       
            : ListView.builder(
             itemBuilder: (context, index) {
               return TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
             },
             itemCount: transactions.length,
          );
  }
}


