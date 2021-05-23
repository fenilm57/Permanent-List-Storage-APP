class TextList {
  String id;
  String textTitle;
  int check;
  int price;
  int ind;
  TextList({this.textTitle, this.check, this.id, this.price, this.ind});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'textTitle': textTitle,
      'checked': check,
      'price': price,
      'ind': ind,
    };
  }
}
