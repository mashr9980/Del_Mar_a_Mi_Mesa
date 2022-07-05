// @dart=2.9
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/components/bottom_navigation.dart';
import 'package:flutter_new/components/front_logo.dart';
import 'package:flutter_new/screens/firstpage.dart';
import 'package:flutter_new/screens/no_internet.dart';
import 'package:flutter_new/screens/second_page.dart';
import 'package:flutter_new/screens/third_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter_new/apis/apis.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/gestures.dart';

class MyHome extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}
var top_5 = [];
Set<Marker> markers={};
var long= 71.5430;
var lat=35.6751;
Apis _Apis = Apis();
final navigatorKey = GlobalKey<NavigatorState>();
class HomePageState extends State<MyHome> {
  Completer<GoogleMapController> _controller = Completer();
  bool isloading=true;
  bool isloading_data=true;
  bool network_issue=false;
  bool show_drawer=false;
  var resultFromJson;
  var active1=true;
  var active2=false;
  var active3=false;
  var data_loaded=false;
  ScrollController _scrollController=new ScrollController();
  @override
  void initState() {
    super.initState();
    if(data_loaded==false){
      av();
      setState(() {
        data_loaded=true;
      });
    }
  }
  void av()async{
    var result = await _Apis.getPostsall();
    if(result!=""){
      setState(() {
        resultFromJson = json.decode(result);
      });
    }
    else{
      // print("no int ");
      setState(() {
        network_issue=true;
      });
    }
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return network_issue? NoInternet():resultFromJson==null?Container(color: Colors.white, child:Center(child:CircularProgressIndicator())):
    WillPopScope(
      onWillPop:() => Future.value(false),
      child: Scaffold(
        bottomNavigationBar: resultFromJson==null? null:Navv(posts: resultFromJson,context_: context,),
        body: SafeArea(
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (settings) {
              // print("Settings");
              // print(settings.name);
              return settings.name=="/"?MaterialPageRoute(builder: (_) => new FirstPage(result: resultFromJson,)):MaterialPageRoute(builder: (_) => new SecondPage(post: resultFromJson,));
            },
          ),
        ),



      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.55,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: LatLng(lat,long), zoom: 12),
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
        markers: markers,
      ),
    );
  }
}