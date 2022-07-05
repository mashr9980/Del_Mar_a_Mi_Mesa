import 'package:flutter/material.dart';
import 'package:flutter_new/screens/main_page.dart';
import 'package:flutter_new/screens/second_page.dart';

import 'front_logo.dart';

class DrawerPage extends StatefulWidget {
  bool  drawer;
  DrawerPage({Key key, this.drawer}) : super(key: key);
  // this.drawer=this.show_drawer;
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.only(top:28.0),
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  // width: size.width * 8,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: Color(0xff188D8D),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FrontLogo(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0,right: 15),
                          child: SizedBox.fromSize(
                            size: Size(56,56), // button width and height
                            child: ClipOval(
                              child: Material(
                                color: Color(0xffE84616), // button color
                                child: InkWell(
                                  splashColor: Colors.green, // splash color
                                  onTap: () {

                                    setState(() {
                                      widget.drawer=false;
                                    });
                                    // scaffoldKey.currentState!.openEndDrawer();
                                  }, // button pressed
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(image: AssetImage('assets/images/cross.png'),width: 60,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Image(image: AssetImage('assets/images/Vector.png')),
                              SizedBox(width: 30),
                              Text(
                                'Inicio                    ',
                                style: TextStyle(
                                    fontSize: size.width * 0.04, fontWeight: FontWeight.w500, color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.navigate_next_rounded, color: Colors.white, size: 30,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Divider(
                        thickness: 2,
                        color: Color(0xffFFFFFF).withOpacity(0.2),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (BuildContext context) => SecondPage()
                            )
                        );
                        setState(() {
                          widget.drawer=!widget.drawer;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Image(image: AssetImage('assets/images/s2.png')),
                              SizedBox(width: 30),
                              Text(
                                'Caletas de Chile',
                                style: TextStyle(
                                    fontSize: size.width * 0.04, fontWeight: FontWeight.w500, color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.navigate_next_rounded, color: Colors.white, size: 30,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Divider(
                        thickness: 2,
                        color: Color(0xffFFFFFF).withOpacity(0.2),
                      ),
                    ),
                    InkWell(
                      onTap: () {print('Buscar Caleta');},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Image(image: AssetImage('assets/images/s3.png')),
                              SizedBox(width: 30),
                              Text(
                                'Buscar Caleta    ',
                                style: TextStyle(
                                    fontSize: size.width * 0.04, fontWeight: FontWeight.w500, color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.navigate_next_rounded, color: Colors.white, size: 30,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    // );
  }
}
