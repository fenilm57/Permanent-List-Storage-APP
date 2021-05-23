import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'list.dart';

class Const {
  Widget widgetButton({BuildContext context, Function onPress, String title}) {
    return Container(
      width: 300,
      height: 50,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(HexColor('#3EB7FE')),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetTextField(TextEditingController title, bool validate) {
    return Container(
      margin: EdgeInsets.all(20),
      child: TextField(
        autofocus: false,
        style: TextStyle(
          color: HexColor('#414270'),
          fontWeight: FontWeight.bold,
          fontSize: 19,
          letterSpacing: 1,
        ),
        textAlign: TextAlign.center,
        cursorColor: HexColor('#414270'),
        controller: title,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Enter Title',
          hintStyle: TextStyle(
            color: HexColor('#414270'),
            fontWeight: FontWeight.bold,
            fontSize: 19,
            letterSpacing: 1,
          ),
          errorText: validate ? 'Please Enter Details' : null,
        ),
      ),
    );
  }

  void showDownBottomSheet(
      BuildContext context,
      TextEditingController textController,
      String title,
      List<ListData> list,
      int index,
      String head,
      TextInputType type,
      Function onPress) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: 800,
              color: HexColor('#8C84C6'),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Text(
                      head,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#414270'),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: TextField(
                      controller: textController,
                      keyboardType: type,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: title,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 250,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onPress,
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(HexColor('#414270')),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
