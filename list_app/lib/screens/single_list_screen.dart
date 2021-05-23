import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:list_app/models/const.dart';
import 'package:list_app/models/list.dart';
import 'package:list_app/models/text_list.dart';
import 'package:list_app/screens/navigation_screen.dart';
import 'package:sqflite/sqflite.dart';

// CheckBox Condition 133

class SingleList extends StatefulWidget {
  static const routeName = '/single-list';
  final List<ListData> list;
  final int index;
  final Future<Database> database;
  final Future<Database> database2;

  SingleList(this.list, this.database, this.database2, this.index);

  @override
  _SingleListState createState() => _SingleListState();
}

class _SingleListState extends State<SingleList> {
  TextEditingController textController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final snackBar = SnackBar(content: Text('Deleted!'));
  SnackBar totalSnackbar;

  List<TextList> textList = [];
  List<TextList> tempListData;
  int listIndex = 0;
  int check = 0;
  String title;
  int sum = 0;
  bool sort = false;

  @override
  void initState() {
    super.initState();
    title = widget.list[widget.index].title;
    print(title);
    display();
  }

  void display() async {
    tempListData = await selectTextLists();

    setState(() {
      textList = tempListData.where((element) {
        return element.ind == widget.index;
      }).toList();
    });
    // print('Length : ${textList.length}');
  }

// Adding
  void addTextList(int check, String title) async {
    final addListData = TextList(
      id: DateTime.now().toString(),
      textTitle: title,
      check: check,
      price: 0,
      ind: widget.index,
    );
    // textList.add(addList);

    await insertTextList(addListData);

    print('object');
    // print(addList.textTitle);

    setState(() {
      display();
    });
  }

  //insert into textList
  Future<void> insertTextList(TextList lists) async {
    final db = await widget.database2;
    print('Inserted');
    await db.insert(
      'listtext',
      lists.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//select
  Future<List<TextList>> selectTextLists() async {
    final db = await widget.database2;
    final List<Map<String, dynamic>> maps = await db.query(
      'listtext',
      orderBy: sort ? 'textTitle' : 'checked',
    );
    print('select method');
    return List.generate(maps.length, (i) {
      return TextList(
        id: maps[i]['id'],
        textTitle: maps[i]['textTitle'],
        check: maps[i]['checked'],
        price: maps[i]['price'],
        ind: maps[i]['ind'],
      );
    });
  }

  //update db
  Future<void> updateTextList(TextList lists) async {
    final db = await widget.database2;
    print('lists.check: ${lists.check}');
    print('${lists.id}');
    await db.update(
      'listtext',
      lists.toMap(),
      where: 'id = ?',
      whereArgs: [lists.id],
    );
  }

//delete
  Future<void> deleteTextList(int ind) async {
    final db = await widget.database2;

    await db.delete(
      'listtext',
      where: 'checked = ? AND ind = ?',
      whereArgs: [1, ind],
    );
  }

  void uncheckAll(int i) async {
    await updateTextList(
      TextList(
          id: textList[i].id,
          check: 0,
          ind: textList[i].ind,
          price: textList[i].price,
          textTitle: textList[i].textTitle),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Total':
        sum = 0;
        for (var i = 0; i < textList.length; i++) {
          if (textList[i].price != null) {
            sum = sum + textList[i].price;
          }
        }
        totalSnackbar = SnackBar(content: Text('Total Price :  $sum  Rs'));
        ScaffoldMessenger.of(context).showSnackBar(totalSnackbar);
        print('Total Price: $sum Rs');
        break;
      case 'Clear Check':
        for (var i = 0; i < textList.length; i++) {
          uncheckAll(i);
        }
        display();
        break;
      case 'Delete':
        showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title: Text('Do you want to Delete?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      //Delete Text from List

                      await deleteTextList(widget.index);

                      setState(() {
                        display();
                      });
                      // textList.removeWhere((element) {
                      //   return (widget.list[widget.index].title == title &&
                      //       element.check == 1);
                      // });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  )
                ],
              );
            });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${(widget.list[widget.index].title[0].toUpperCase())}${widget.list[widget.index].title.substring(1)}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              handleClick(value);
            },
            itemBuilder: (BuildContext context) {
              return {'Total', 'Clear Check', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      backgroundColor: HexColor('#414270'),
      drawer: NavigationDrawer(
        list: widget.list,
        database2: widget.database2,
        database: widget.database,
        listIndex: widget.index,
      ),
      body: textList.length == 0
          ? Center(
              child: Text(
                'No List Yet For ${title[0].toUpperCase()}${title.substring(1)}!',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: textList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      // SUM Money

                      Const().showDownBottomSheet(
                          context,
                          priceController,
                          'Enter ${textList[index].textTitle}\'s Price',
                          widget.list,
                          index,
                          'Add Price',
                          TextInputType.number, () async {
                        setState(() {
                          textList[index].price =
                              int.parse(priceController.text);
                          Navigator.pop(context);
                        });
                        await updateTextList(
                          TextList(
                            id: textList[index].id,
                            check: textList[index].check,
                            price: textList[index].price,
                            ind: widget.index,
                            textTitle: textList[index].textTitle,
                          ),
                        );
                        setState(() {
                          display();
                        });
                        priceController.clear();
                      });
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: HexColor('#ffffff'),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: HexColor('#8C84C6'),
                        ),
                        subtitle: textList[index].price == 0
                            ? null
                            : Text(
                                //TiTle
                                '${textList[index].price}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20,
                                  decoration: textList[index].check == 1
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationThickness: 2,
                                  decorationColor: Colors.red,
                                ),
                              ),
                        title: Text(
                          //TiTle
                          '${textList[index].textTitle}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor('#414270'),
                            fontSize: 30,
                            decoration: textList[index].check == 1
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 2,
                            decorationColor: Colors.red,
                          ),
                        ),
                        trailing: InkWell(
                          splashColor: Colors.redAccent,
                          onTap: () async {
                            print('Click');

                            // CheckBox Condition Here
                            setState(() {
                              if (textList[index].check == 1) {
                                textList[index].check = 0;
                                check = 0;
                              } else {
                                textList[index].check = 1;
                                check = 1;
                              }
                            });
                            await updateTextList(
                              TextList(
                                id: textList[index].id,
                                check: check,
                                price: textList[index].price,
                                ind: widget.index,
                                textTitle: textList[index].textTitle,
                              ),
                            );
                            setState(() {
                              display();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              textList[index].check == 1
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //insert code
          Const().showDownBottomSheet(
            context,
            textController,
            'Enter ${widget.list[widget.index].title[0].toUpperCase()}${widget.list[widget.index].title.substring(1)}\'s List',
            widget.list,
            widget.index,
            'Add Item',
            TextInputType.text,
            () {
              print('Clicked! ${textController.text}');
              String upper =
                  '${(textController.text[0].toUpperCase())}${textController.text.substring(1)}';

              setState(() {
                //adding to list
                addTextList(check, upper);
                print('Check: $check');
                print(textList.length);
              });

              textController.clear();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
