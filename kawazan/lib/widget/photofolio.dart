// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/photofolio.dart';
import 'package:provider/provider.dart';
import 'package:kawazan/store/tabstore.dart';
import 'package:intl/intl.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".

class PhotofolioWidget extends StatelessWidget {
  int index = 0;
  PhotofolioWidget(int index){
    this.index = index;
  }
  @override
  Widget build(BuildContext context) {
    final photofolio = context.select((PhotofolioStore p) => p.photofolioList[this.index]);
    final stockList = context.select((PhotofolioStore p) => p.stockList[this.index]);
    final isLoading = context.select((PhotofolioStore p) => p.isLoading);
    if (isLoading){
      return new Text('Loading ...');
    }
    return Row(children: [
      Text(DateFormat('yyyy-MM-dd').format(photofolio.create_date)),
      IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime
                  .now()
                  .year),
              lastDate: DateTime(DateTime
                  .now()
                  .year + 1),
            );
            if (selectedDate != null) {
              context
                  .read<PhotofolioStore>()
                  .updateDate(photofolio.id, selectedDate);
 }
          }),
      IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            if (stockList.isEmpty){
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Empty Data'),
                  )
              );
            }
        }),
    ]);
  }
}

