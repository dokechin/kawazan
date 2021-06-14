import 'package:flutter/material.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/widget/graph.dart';
import 'package:kawazan/widget/table.dart';
import 'package:kawazan/widget/edit.dart';
import 'package:provider/provider.dart';

class CustomPage2 extends StatelessWidget {
  var index = 0;
  CustomPage2(int index){
    this.index = index;
  }
  @override
  Widget build(BuildContext context) {
    final photofolioList = context.select((PhotofolioStore s) =>
    s.photofolioList);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.lightBlue[100],
            labelColor: const Color(0xFF3baee7),
            indicatorWeight: 4,
            indicatorColor: Colors.blue[100],
            tabs:
            [new Tab(text: 'Graph'),
              new Tab(text: 'Table'),
              new Tab(text: 'Edit')]
        ),
        body: TabBarView(
            children:
            [ new GraphPage(this.index),
              new TablePage(this.index), new Edit(this.index)]
        ),
      ),
    );
  }
}
