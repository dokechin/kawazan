import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:kawazan/photofolio.dart';
import 'package:kawazan/stock.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/repository.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TablePage extends StatelessWidget {
  int _index;

  @override
  TablePage(int index) {
    this._index = index;
  }

  @override
  Widget build(BuildContext context) {
    final Photofolio photofolio = context.select((PhotofolioStore p) =>
    p.photofolioList[this._index]);
    final List<Stock> stocks = context.select((PhotofolioStore p) =>
    p.stockList[this._index]);

    List<List<Shisan>> shisansList = [];

    List<Shisan> shisans = [];
    for (int i=0;i<stocks.length;i++) {
      shisans.add(
          new Shisan((double.parse(stocks[i].amount) * double.parse(stocks[i].price)).toInt(),
              0,
            double.parse(stocks[i].haitou),
            double.parse(stocks[i].price) ,
            0
          ));
    }
    shisansList.add(shisans);

    for (int i=0;i<10;i++){

      List<Shisan> shisans = [];
      for(int j=0; j<stocks.length;j++) {
        double price = (shisansList[i][j].price * (1 + double.parse(stocks[j].cagr) / 100));
        int total = (double.parse(stocks[j].amount) * price).toInt();
        shisans.add(
            new Shisan(total,
              (shisansList[i][j].haitou * double.parse(stocks[j].amount)).toInt(),
              (shisansList[i][j].haitou * (1 + double.parse(stocks[j].cagr) / 100)),
              price,
              total - shisansList[i][j].total
            ));
      }
      shisansList.add(shisans);
    }

    List <Center> columns = [];

    columns.add(      Center(child:
      Text('年月', style: TextStyle(fontSize: 20.0))
    ));

    for (int i=0;i< stocks.length;i++){
      columns.add(Center(child:
        Text(stocks[i].code.toString() , style: TextStyle(fontSize: 20.0))
      ));
    }
    columns.add( Center(child:
      Text('配当', style: TextStyle(fontSize: 20.0))
    ));

    columns.add( Center(child:
      Text('CG', style: TextStyle(fontSize: 20.0))
    ));

    columns.add( Center(child:
      Text('Total', style: TextStyle(fontSize: 20.0))
    ));

    DateTime year = photofolio.create_date;

    for (int i=0;i<10;i++) {

      columns.add(Center(child:
        Text(DateFormat('yyyy-MM').format(year))
      ));
      int payHaitou = 0;
      int total = 0;
      int capital = 0;
      for(int j=0; j<stocks.length;j++) {

        columns.add(
        Center(child:
          Text(shisansList[i][j].total.toString())
        ));
        payHaitou += shisansList[i][j].payHaitou;
        capital += shisansList[i][j].capital;
        total += shisansList[i][j].total;
      }

      columns.add(
          Center(child:
            Text(payHaitou.toString())
          ));

      columns.add(
          Center(child:
            Text(capital.toString())
          ));

      columns.add(
          Center(child:
            Text(total.toString())
          ));

      year = year.add(Duration(days:366));
    }

    int col = 1+ stocks.length+3;
    int row = 11;
    List<Center> inverse = [...columns];
    columns.asMap().forEach((index,item) => inverse[(index / col ).toInt() + row * (index % col)] = item);

    Widget childWidget;
    childWidget = GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      scrollDirection: Axis.horizontal,
      shrinkWrap: false,
      crossAxisCount: 11,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: 1.10,


      // Generate 100 widgets that display their index in the List.
      children: inverse,
    );
      return childWidget;
  }
}

class Shisan {
  final int total;
  final int payHaitou;
  final double haitou;
  final double price;
  final int capital;

  Shisan(this.total, this.payHaitou, this.haitou, this.price, this.capital);
}