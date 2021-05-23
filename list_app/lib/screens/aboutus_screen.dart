import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:list_app/models/list.dart';
import 'package:sqflite/sqlite_api.dart';
import 'navigation_screen.dart';

class AboutUs extends StatelessWidget {
  static const route = '/about-us';
  final List<ListData> list;
  final int listIndex;
  final Future<Database> database;
  final Future<Database> database2;

  AboutUs({this.list, this.database, this.database2, this.listIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      drawer: NavigationDrawer(
        database: database,
        database2: database2,
        list: list,
      ),
      body: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: HexColor('#414270'),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 300,
              child: Image.asset(
                'images/list.jpg',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'To World\'s Best Family',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'by- Fenil Mehta',
              style: TextStyle(
                fontSize: 25,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
