import 'package:flutter/material.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/widget/graph.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kawazan/widget/custom2.dart';

class CustomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final photofolioList = context.select((PhotofolioStore s) => s.photofolioList);
    return  DefaultTabController(
        length: photofolioList.length,
        child: Scaffold(
          appBar: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.lightBlue[100],
            labelColor: const Color(0xFF3baee7),
            indicatorWeight: 4,
            indicatorColor: Colors.blue[100],
            tabs:
              List.generate(photofolioList.length, (i) {
              return Tab( text : DateFormat('yyyy-MM-dd').format(photofolioList[i].create_date));
              }
            ),
          ),
          body: TabBarView(
            children:
            List.generate(photofolioList.length, (i) {
            return CustomPage2(i);
            }),
          ),
        ),
    );
  }
}
