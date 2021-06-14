import 'package:flutter/material.dart';
import 'package:kawazan/widget/new.dart';
import 'package:kawazan/widget/custom.dart';
import 'package:kawazan/store/photofoliostore.dart';
import 'package:kawazan/store/tabstore.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(new TodoApp());
}
// Every component in Flutter is a widget, even the whole app itself
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Kawazan',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TabStore>(create: (_) => TabStore()),
          ChangeNotifierProvider<PhotofolioStore>(create: (_) => PhotofolioStore()),
        ],
        child: HomePage(),
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  static List<Widget> _pageList = [
    New(),
    CustomPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kawazan'),
      ),
      body: _pageList[context.select((TabStore store) => store.index)],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            title: Text('New'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Chart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('Search'),
          ),
        ],
        currentIndex: context.select((TabStore store) => store.index),
        onTap: context
            .read<TabStore>()
            .selectTab,
      ),
    );
  }
}

