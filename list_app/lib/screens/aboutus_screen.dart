import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'navigation_screen.dart';

class AboutUs extends StatelessWidget {
  static const route = '/about-us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      drawer: NavigationDrawer(),
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
            Text(
              'To My Family',
              style: TextStyle(
                fontSize: 40,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
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
