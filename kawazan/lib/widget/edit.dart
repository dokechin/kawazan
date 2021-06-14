// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';
import 'package:kawazan/photofolio.dart';
import 'package:kawazan/widget/photofolio.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/stock.dart';
import 'package:kawazan/widget/stocklist.dart';
import 'package:provider/provider.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".

final _formKey = GlobalKey<FormState>();

class Edit extends StatelessWidget {
  var _code;
  var _price;
  var _amount;
  var _haitou;
  var _cagr;
  var index;
  Photofolio photofolio;
  Edit(int index){
    this.index = index;
  }
  @override
  Widget build(BuildContext context) {
    final parent_context = context;
    this.photofolio = context.select((PhotofolioStore p) => p.photofolioList[this.index]);

    return new Scaffold(
      body: Column (
        mainAxisSize: MainAxisSize.max,
        children : [
          Column( children: [
            new PhotofolioWidget(this.index),
            new StockList(this.index)]),
          new FloatingActionButton(
              onPressed: (){
                Navigator.of(context).push(
                  // MaterialPageRoute will automatically animate the screen entry, as well as adding
                  // a back button to close it
                    new MaterialPageRoute(
                        builder: (context) {

                          return new Scaffold(
                            appBar: new AppBar(
                                title: new Text('Add a new task')
                            ),
                            body:  Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [ new TextFormField(
                                  autofocus: true,
                                  decoration: new InputDecoration(
                                      labelText : '証券コード',
                                      contentPadding: const EdgeInsets.all(16.0)
                                  ),
                                  onSaved:(String value) {this._code = value;},
                                ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText : '購入時株価',
                                        contentPadding: const EdgeInsets.all(16.0)
                                    ),
                                    onSaved:(String value) {this._price = value;},
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText : '株数',
                                        contentPadding: const EdgeInsets.all(16.0)
                                    ),
                                    onSaved:(String value) {this._amount = value;},
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText : '一株配当',
                                        contentPadding: const EdgeInsets.all(16.0)
                                    ),
                                    onSaved:(String value) {this._haitou = value;},
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText : 'CAGR',
                                        contentPadding: const EdgeInsets.all(16.0)
                                    ),
                                    onSaved:(String value) {this._cagr = value;},
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // 各Fieldのvalidatorを呼び出す
                                          if (_formKey.currentState.validate()) {
                                            // 入力データが正常な場合の処理
                                            _formKey.currentState.save();

                                            Stock stock = new Stock(photofolio_id: this.photofolio.id, code: this._code,price : this._price,
                                                amount: this._amount,haitou: this._haitou,cagr: this._cagr);
                                            Navigator.pop(context); // Close the add todo screen
                                            parent_context
                                                .read<PhotofolioStore>()
                                                .addStock(stock);
                                          }
                                        },
                                        child: Text('Submit'),
                                      )
                                  ),
                                ],

                              ),
                            ),
                          );
                        }
                    )
                );
              },
              tooltip: 'Add task',
              child: new Icon(Icons.add)
          )],
      ),
    );
  }


}

