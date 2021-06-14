class Stock {
  int id;
  String code;
  String price;
  String amount;
  String haitou;
  String cagr;
  int photofolio_id;
  Stock ({this.id, this.code, this.price, this.amount, this.haitou, this.cagr,this.photofolio_id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'price': price,
      'amount': amount,
      'haitou': haitou,
      'cagr': cagr,
      'photofolio_id': photofolio_id
    };
  }
}