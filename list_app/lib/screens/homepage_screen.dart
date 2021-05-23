import 'package:flutter/material.dart';
import 'package:list_app/list_function.dart';
import 'package:list_app/models/const.dart';
import 'package:list_app/models/list.dart';
import 'package:list_app/models/validate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'navigation_screen.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  final List<ListData> list;
  final Future<Database> database;
  final Future<Database> database2;
  HomePage(this.list, this.database, this.database2);

  static const routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final snackBar = SnackBar(content: Text('Added!'));

  ListFunction listFunction;

  bool _validate = false;

  void display() {
    for (var i = 0; i < widget.list.length; i++) {
      print(widget.list[i].title);
    }
  }

  Future<bool> onBackPress() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Do you want to Exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: HexColor('#414270'),
        appBar: AppBar(
          title: Text('List App'),
        ),
        drawer: NavigationDrawer(
          list: widget.list,
          database: widget.database,
          database2: widget.database2,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 150,
              alignment: Alignment.centerLeft,
              child: Text(
                'List Title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: HexColor('#8C84C6'),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 380,
                          child: Const()
                              .widgetTextField(_titleController, _validate),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Const().widgetButton(
                          context: context,
                          title: 'Add Title',
                          onPress: () {
                            // TextField Regulations
                            setState(() {
                              _validate = Validate()
                                  .validateTextField(_titleController.text);
                            });
                            if (_validate == false) {
                              ListFunction(widget.database)
                                  .addList(widget.list, _titleController.text);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              // display();
                              _titleController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
