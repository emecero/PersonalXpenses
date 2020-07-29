import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/widgets/adaptive_flatbutton.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
//-----1.Nueva funcion para pasar datos
final Function addTx;


  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
final _titleController = TextEditingController();
final _amountController = TextEditingController();
DateTime _selectedDate;

  void _submitData(){
    if (_amountController.text.isEmpty){
      return;
    }
     //----3.Metodo para agregar nuevos valores -- convertimos el string a double en el valor amount
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    //validar que no esten vacios los campos para evitar que se ejecute addTx()
    if(enteredTitle.isEmpty || enteredAmount <= 0 ||  _selectedDate == null){
      return;
    }

    widget.addTx(
      enteredTitle, 
      enteredAmount,
      _selectedDate,
      );

      Navigator.of(context).pop();
  }

  void _presentDatePicker(){

    showDatePicker(
   
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now()
      )
      .then((pickedDate) {
        if (pickedDate == null){
          return;
        }
        setState(() {
        _selectedDate = pickedDate;
        });

      }
      );
  }

  @override
  Widget build(BuildContext context) {
    return 
     SingleChildScrollView(
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(decoration: InputDecoration(
                    labelText: 'Title'
                  ),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
/*                 onChanged: (val) {
                    titleInput = val;
                  }, */
                  ),
                  TextField(decoration: InputDecoration(
                    labelText: 'Amount'
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  // (_)pasamos como valor el _ para que no truene
                  onSubmitted: (_) => _submitData(),
                 // onChanged: (val) => amountInput = val,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                      Expanded(
                       child: Text(
                          _selectedDate == null 
                          ? 'No hay fecha' 
                          : 'Fecha: ${DateFormat.yMMMMd().format(_selectedDate)}',
                          ),
                      ),
                      //widget personalizado para adaptar botones
                      AdaptiveFlatButton('Seleccionar Fecha', _presentDatePicker)
                    ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Agregar transacción'),
                    color: Theme.of(context).primaryColor,
                    //textColor: Theme.of(context).textTheme.button.color,
                    textColor: Colors.white,
                    onPressed: _submitData,
                  ),
                 ],
                ),
              ),
            ),
     );
  }
}