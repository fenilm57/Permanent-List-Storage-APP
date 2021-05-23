import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:list_app/models/list.dart';
import 'package:list_app/screens/aboutus_screen.dart';
import 'package:list_app/screens/single_list_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'homepage_screen.dart';

class NavigationDrawer extends StatefulWidget {
  final List<ListData> list;
  final int listIndex;
  final Future<Database> database;
  final Future<Database> database2;

  NavigationDrawer({this.list, this.database, this.database2, this.listIndex});

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  List<ListData> tempList = [];
  final snackBar = SnackBar(content: Text('Deleted!'));

  Future<List<ListData>> lists() async {
    final db = await widget.database;

    final List<Map<String, dynamic>> maps = await db.query('lists');

    return List.generate(maps.length, (i) {
      return ListData(
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    });
  }

  Future<void> deleteList(String id) async {
    final db = await widget.database;

    await db.delete(
      'lists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  void initState() {
    super.initState();
    display();
  }

  void display() async {
    tempList = await lists();
    setState(() {
      print('Name : ${tempList.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: HexColor('#414270'),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20),
                    child: CircleAvatar(
                      backgroundColor: HexColor('#8C84C6'),
                      child: Icon(
                        Icons.list,
                        size: 35,
                        color: HexColor('#414270'),
                      ),
                      radius: 30,
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        bool isNewRouteSameAsCurrent = false;
                        Navigator.popUntil(context, (route) {
                          if (route.settings.name == HomePage.routeName) {
                            isNewRouteSameAsCurrent = true;
                            Navigator.pop(context);
                          }
                          return true;
                        });
                        if (!isNewRouteSameAsCurrent) {
                          Navigator.popAndPushNamed(
                              context, HomePage.routeName);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'List App',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: tempList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      // splashColor: Colors.amber,
                      onLongPress: () {
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
                                      await deleteList(tempList[index].id);
                                      Navigator.pushReplacementNamed(
                                          context, HomePage.routeName);
                                      //SnackBar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: Text('Yes'),
                                  )
                                ],
                              );
                            }); //Delete List Title
                      },
                      onTap: () {
                        // Navigation
                        if (widget.listIndex == index) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) {
                                return SingleList(tempList, widget.database,
                                    widget.database2, index);
                              },
                            ),
                          ).then(
                            (value) => Navigator.of(context).popUntil((route) {
                              return route.settings.name == HomePage.routeName;
                            }),
                          );
                        }
                      },
                      child: ListTile(
                        leading: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Icon(Icons.double_arrow_outlined),
                        ),
                        title: Container(
                          child: Text(
                            '${(tempList[index].title[0].toUpperCase())}${tempList[index].title.substring(1)}',
                            style: Theme.of(context).textTheme.headline1,
                            // textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () {
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  if (route.settings.name == AboutUs.route) {
                    isNewRouteSameAsCurrent = true;
                    Navigator.pop(context);
                  }
                  return true;
                });
                if (!isNewRouteSameAsCurrent) {
                  Navigator.popAndPushNamed(context, AboutUs.route);
                }
              },
              child: Container(
                color: HexColor('#8C84C6'),
                width: double.maxFinite,
                height: 80,
                child: Center(
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      color: HexColor('#414270'),
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
