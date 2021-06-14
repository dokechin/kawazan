import 'package:flutter/widgets.dart';

class TabStore with ChangeNotifier {
  var index = 0;
  void selectTab(int selectIndex){
    index = selectIndex;
    notifyListeners();
  }
}