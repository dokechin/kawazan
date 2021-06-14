class Photofolio {
  int id;
  String name;
  DateTime create_date;
  int work_flg;
  Photofolio ({this.id, this.name, this.create_date, this.work_flg});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'create_date': create_date.toIso8601String(),
      'work_flg': work_flg,
    };
  }

  @override
  String toString(){
    return "id" + this.id.toString() + "name" + this.name;
  }
}