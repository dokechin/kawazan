import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:kawazan/photofolio.dart';
import 'package:kawazan/stock.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/repository.dart';
import 'package:provider/provider.dart';


class GraphPage extends StatelessWidget {
  int _index;
  @override
  GraphPage(int index){
    this._index = index;
  }
  @override
  Widget build(BuildContext context) {

    final Photofolio photofolio = context.select((PhotofolioStore p) => p.photofolioList[this._index]);
    final List<Stock> stocks = context.select((PhotofolioStore p) => p.stockList[this._index]);

    List<charts.Series<LinearSales, DateTime>> stockdatas = [];

    for (int i=0;i<stocks.length;i++){

      List<LinearSales> datas = [];
      int price = (double.parse(stocks[i].price) * double.parse(stocks[i].amount)).toInt();
      int haitou = 0;
      print (stocks[i].code);
      for(int j=0; j<10;j++) {
          datas.add(new LinearSales(new DateTime(2021 + j,1,1), price + haitou));
          price = (price * ( double.parse(stocks[i].cagr) / 100.0 + 1.0 )).toInt() ;
          haitou = (double.parse(stocks[i].haitou) * double.parse(stocks[i].amount)).toInt();
      }
      try {
        stockdatas.add(charts.Series<LinearSales, DateTime>(
          id: stocks[i].code,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: datas,
        ));
      } on Exception catch (e, s) {
        print(s);
      }
    }
    Widget childWidget;
    childWidget = new charts.TimeSeriesChart(stockdatas,
                  defaultRenderer:
                  new charts.LineRendererConfig(includeArea: true, stacked: true),
                behaviors: [
                new charts.SeriesLegend(
                // Positions for "start" and "end" will be left and right respectively
                // for widgets with a build context that has directionality ltr.
                // For rtl, "start" and "end" will be right and left respectively.
                // Since this example has directionality of ltr, the legend is
                // positioned on the right side of the chart.
                position: charts.BehaviorPosition.end,
                // For a legend that is positioned on the left or right of the chart,
                // setting the justification for [endDrawArea] is aligned to the
                // bottom of the chart draw area.
                outsideJustification: charts.OutsideJustification.endDrawArea,
                // By default, if the position of the chart is on the left or right of
                // the chart, [horizontalFirst] is set to false. This means that the
                // legend entries will grow as new rows first instead of a new column.
                horizontalFirst: false,
                // By setting this value to 2, the legend entries will grow up to two
                // rows before adding a new column.
                desiredMaxRows: 2,
                // This defines the padding around each legend entry.
                cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                // Render the legend entry text with custom styles.
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.Color(r: 127, g: 63, b: 191),
                    fontFamily: 'Georgia',
                    fontSize: 11),
              )
            ],
    );
    return childWidget;
  }
}

/// Sample linear data type.
class LinearSales {
  final DateTime year;
  final int sales;

  LinearSales(this.year, this.sales);
}