import 'package:flutter/material.dart';
import 'package:flutter_new/components/bottom_navigation.dart';
import 'package:flutter_new/components/front_logo.dart';
import 'package:flutter_new/screens/main_page.dart';

import '../main.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Navv(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top:2.0),
            child: Column(
              children: [
                Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FrontLogo(),
                          ],
                        ),
                        SizedBox(height: size.height / 4,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => MyHome()
                                    )
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh, size: 30,),
                                  SizedBox(width: 30),
                                  Text(
                                    'Connection Failed. PLease check\n Your Internet',
                                    style: TextStyle(
                                        fontSize: size.width * 0.04, fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
Widget Internet(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Scaffold(
      bottomNavigationBar: Navv(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:28.0),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FrontLogo(),
                        ],
                      ),
                      SizedBox(height: size.height / 4,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => MyHome()
                                  )
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.refresh, size: 30,),
                                SizedBox(width: 30),
                                Text(
                                  'Connection Failed. PLease check\n Your Internet',
                                  style: TextStyle(
                                      fontSize: size.width * 0.04, fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )
  );
}
