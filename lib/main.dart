// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_new/components/bottom_navigation.dart';
import 'package:flutter_new/screens/second_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'components/drawer.dart';
import 'screens/main_page.dart';
import 'components/icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BaseModel()),
        ],
        child: MyApp(),
      ),

      );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging ;

  _register() async {
    await FirebaseMessaging.instance.subscribeToTopic('delmar_topic_fcm');
    // _firebaseMessaging.getToken().then((token) => print("Tokennnn ${token}"));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _register();
    // getMessage();
  }
  // void getMessage(){
  //   _firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) async {
  //         print('on message $message');
  //         setState(() => _message = message["notification"]["title"]);
  //       }, onResume: (Map<String, dynamic> message) async {
  //     print('on resume $message');
  //     setState(() => _message = message["notification"]["title"]);
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     print('on launch $message');
  //     setState(() => _message = message["notification"]["title"]);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Del Mar a Mi Mesa',
      theme: ThemeData(
        fontFamily: "Montserratwh",
        primarySwatch: Colors.blue,
      ),
      home: FadeTransitionSample(),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/page1': (context) => MyHome(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/page2': (context) => SecondPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class FadeTransitionSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Fade();
}

class _Fade extends State<FadeTransitionSample> with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: Duration(seconds: 4),);
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        animation.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        animation.forward();
      }
    });
    animation.forward();
    Timer(
        Duration(seconds: 5),
            () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => MyHome()
            )
        )
    );
  }
  @override
  dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeInFadeOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: size.height * 0.2,),
                Container(
                    width: size.width,
                    height: 200,
                    child: Center(
                      child: SvgPicture.asset(splashIcon1),
                    )
                ),
                SizedBox(height: size.height * 0.02,),
                Container(
                  height: 100,
                    width: size.width,
                    child: Center(
                      child: SvgPicture.asset(splashIcon2,color: Colors.white,cacheColorFilter: false,),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
