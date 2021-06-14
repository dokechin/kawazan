import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:kawazan/repository.dart';
import 'package:kawazan/photofolio.dart';
import 'package:kawazan/stock.dart';


class PhotofolioStore with ChangeNotifier {

  List<Photofolio> photofolioList = [];
  List<List <Stock>> stockList = [];

  var workPhotofolio = null;
  List<Stock> workStockList = [];

  bool isLoading = true;

  PhotofolioStore(){
    fetchWork();
    fetch();
    notifyListeners();
  }

  void fetchWork() async {
    print("PhotofolioStore fetchWork called");
    workPhotofolio = await Repository.getWorkPhotofolio();
    if (workPhotofolio == null){
      print("workPhotofolio == null");
      Photofolio p = new Photofolio(create_date : DateTime.now(), work_flg : 1);
      await Repository.insertPhotofolio(p);
      workPhotofolio = await Repository.getWorkPhotofolio();
    }
    workStockList = await Repository.getStocks();
    print("get workStockList");
    this.isLoading = false;
  }

  void fetch() async {
    print("PhotofolioStore fetch called");
    photofolioList = await Repository.getPhotofolios();
    stockList.clear();
    if (photofolioList != null){
      for (Photofolio pho in photofolioList) {
        stockList.add( await Repository.getRealStocks(pho.id));
      }
    }
  }

  void updateWorkDate(DateTime setDate){
    workPhotofolio.create_date = setDate;
    Repository.updateWorkPhotofolio(setDate);
    notifyListeners();
  }

  void updateDate(int index, DateTime setDate){
    photofolioList[index].create_date = setDate;
    Repository.updatePhotofolio(photofolioList[index].id, setDate);
    notifyListeners();
  }


  void save() async{
    print("save called");
    await Repository.workToRealPhotofolio();
    await Repository.workToRealStocks(workPhotofolio);
    fetchWork();
    fetch();
    notifyListeners();
  }

  void addWorkStock(Stock stock) async {
    await Repository.insertStock(stock);
    workStockList = await Repository.getStocks();
    notifyListeners();
  }

  void addStock(Stock stock) async {
    await Repository.insertStock(stock);
    await fetch();
    notifyListeners();
  }

  void removeWorkStock(int index) async {
    await Repository.deleteStock(workStockList[index].id);
    workStockList = await Repository.getStocks();
    notifyListeners();
  }

  void removeStock(int id) async {
    await Repository.deleteStock(id);
    this.fetch();
    notifyListeners();
  }

}
