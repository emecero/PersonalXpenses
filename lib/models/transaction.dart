import 'package:flutter/foundation.dart';

//Clase
class Transaction{
  //Parametros a recibir
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  //constructor
  Transaction({
    //parametros
   @required this.id, 
   @required this.title, 
   @required this.amount, 
   @required this.date});
}