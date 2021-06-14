// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';
import 'package:kawazan/repository.dart';
import 'package:kawazan/widget/workphotofolio.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/stock.dart';
import 'package:provider/provider.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".

class StockList extends StatelessWidget {
  int index = 0;
  List<Stock> stockList = null;
  StockList(int index){
    this.index = index;
  }
  @override
  Widget build(BuildContext context) {
    this.stockList = context.select((PhotofolioStore p) => p.stockList[this.index]);

    return new ListView.builder(
      shrinkWrap: true,   //追加
      physics: const NeverScrollableScrollPhysics(),  //追加
      itemBuilder: (context, index)  {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < this.stockList.length) {
          return _buildTodoItem(context, this.stockList[index], index);
        }
      },
    );
  }

  void _promptRemoveTodoItem(BuildContext _context, int index) {

    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Delete "${this.stockList[index].code}" ?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    // The alert is actually part of the navigation stack, so to close it, we
                    // need to pop it.
                    onPressed: () => Navigator.of(context).pop()
                ),
                new FlatButton(
                    child: new Text('DELETE'),
                    onPressed: () {
                      _context
                          .read<PhotofolioStore>()
                          .removeStock(this.stockList[index].id);
                      Navigator.of(context).pop();
                    }
                )
              ]
          );
        }
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(BuildContext context, Stock stock, int index) {
    return new ListTile(
        title: new Text(stock.code + ' ' + stock.price + ' ' + stock.amount + ' ' + stock.haitou + ' ' + stock.cagr),
        onTap: () => _promptRemoveTodoItem(context, index)
    );
  }

}

