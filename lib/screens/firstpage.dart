import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/components/front_logo.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/components/bottom_navigation.dart';
import 'package:flutter_new/components/front_logo.dart';
import 'package:flutter_new/components/icons.dart';
import 'package:flutter_new/components/players.dart';
import 'package:flutter_new/screens/second_page.dart';
import 'package:flutter_new/screens/third_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter_new/apis/apis.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';
import 'package:flutter/services.dart';

class FirstPage extends StatefulWidget {
final result;
  const FirstPage({Key key,this.result}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}
var top_5 = [];
Set<Marker> markers={};
var long= 71.5430;
var lat=35.6751;
Apis _Apis = Apis();
class _FirstPageState extends State<FirstPage> {
  GlobalKey<AutoCompleteTextFieldState<Players>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();
var data_loaded=false;
  // _AutoCompleteState();

  void _loadData() async {
    await PlayersViewModel.loadPlayers(widget.result);
  }
  int _current = 0;
  bool _mapLoading=true;
  // _animateToIndex(i,length) => _scrollController.animateTo(length * i, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  GoogleMapController _controller;
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }
  bool isloading=true;
  bool isloading_data=true;
  bool network_issue=false;
  bool show_drawer=false;
  var no_image="https://drive.google.com/uc?id=1llCDd3RjVgOGtEJN32xfS__AwVn8nQz_";
  var resultFromJson;
  var length=143;
  var active1=true;
  var active2=false;
  var active3=false;
  // BaseModel bookModel;
  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat=position.longitude;
      long=position.longitude;
    });

  }
  ScrollController _scrollController=new ScrollController();
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    if(top_5.length==0){

      av(true);

      setState(() {
        data_loaded=true;

      });
    }
    else{
      av(false);
      setState(() {
        data_loaded=true;

      });
    }
  }
  void av(flag_)async{
    markers={};
    setState(() {
        resultFromJson = widget.result;
      });
      // if(resultFromJson.length>=5) {
      //    length = ((5 * 43) / 3).round();
      // }
      // else{
      //   length= ((resultFromJson.length * 43) / 3).round();
      // }

    // _scrollController.position.maxScrollExtent
      _scrollController.addListener(() {
        // print("scroller");
        // print(_scrollController.position.maxScrollExtent);
        length=(_scrollController.position.maxScrollExtent/3).round();
        // print("length");
        // print(length);
        var pixel=_scrollController.position.pixels.round();
        // print(pixel);
        // if( pixel % length==0){
          if(pixel<length){
            setState(() {
              active1=true;
              active2=false;
              active3=false;
            });
          }
          else if(pixel>=length && pixel<length*2){
            setState(() {
              active1=false;
              active2=true;
              active3=false;
            });
          }
          else{
            setState(() {
              active1=false;
              active2=false;
              active3=true;
            });
          }
        // }
      });
      var flag=false;
      for(var i=0;i<resultFromJson.length;i++){
        if(resultFromJson[i]['acf']['gallery'].runtimeType==bool){
          resultFromJson[i]['acf']['gallery']=[{"url":no_image}];
        }
        if(i<5){
          flag=true;
          setState(() {
            if(flag_) {
              top_5.add(resultFromJson[i]);
              isloading_data = false;
            }
            else{
              isloading_data = false;
            }
          });
        }
        final query = resultFromJson[i]["acf"]["direccion"];
        // print(query);
        try {
          var addresses = await Geocoder.local.findAddressesFromQuery(
              query);
          var cords = addresses.first.coordinates;
          if (i == 0) {
            setState(() {
              long = cords.longitude;
              lat = cords.latitude;
              // isloading = false;
            });
          }
          setState(() {
            // if(flag_) {
            markers.add(Marker(
              markerId: MarkerId(addresses.first.featureName),
              position: LatLng(cords.latitude, cords.longitude),
              onTap: () {
                // print("on tpapppp  ");
                _customInfoWindowController.hideInfoWindow();
                _customInfoWindowController.addInfoWindow(
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, bottom: 10, right: 10, top: 10),
                      child: Container(
                        // height: 55,
                        // width: 900,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          elevation: 0.0,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ThirdPage(post: resultFromJson[i],navi: "/",)
                                )
                            );
                          },
                          color: Color(0xff188D8D),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${resultFromJson[i]["title"]["rendered"]}',
                                      style: TextStyle(
                                        // fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/Polygon 2.svg'),
                                    )
                                  ],
                                ),
                                Text(
                                  'El Quisco Cove',
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    LatLng(cords.latitude, cords.longitude)
                );
              },

              // infoWindow: InfoWindow(
              //     title: resultFromJson[i]["title"]["rendered"]),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            )
            );
            // }
          });
        }
        catch(error) {
          print("not rendered");
          print(error);
        }
      }
      setState(() {
        isloading=false;
      });
    // }
    // top_5.add(top_5[0]);
    // top_5.add(top_5[1]);
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final BaseModel bookModel= Provider.of(context);
    Size size = MediaQuery.of(context).size;
    // print("Width");
    // print(size.width.round());
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff073655),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40))
          ),
          child: Column(
            children: [
              show_drawer ? Stack(
                children: <Widget>[
                  Container(
                    height: size.height,
                    color: Color(0xff188D8D),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                          show_drawer=false;
                                        });
                                      }, // button pressed
                                      child: Column(
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
                            navigatorKey.currentState.pushNamed("/");
                            setState(() {
                              bookModel.selectedIndex=0;
                            });

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/images/first.svg'),
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
                            navigatorKey.currentState.pushNamed("/page2");
                            setState(() {
                              bookModel.selectedIndex=1;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/images/second.svg'),
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
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              aligment: Alignment.topCenter,
                              // dismissOnTouchOutside:false,
                              dialogType: DialogType.NO_HEADER,
                              dialogBackgroundColor: Colors.transparent.withOpacity(0.0),
                              body: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top :8.0, right: 20),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox.fromSize(
                                        size: Size(56, 56), // button width and height
                                        child: ClipOval(
                                          child: Material(
                                            color: Color(0xffE84616), // button color
                                            child: InkWell(
                                              splashColor: Colors.green, // splash color
                                              onTap: () {
                                                Navigator.of(context, rootNavigator: true).pop();
                                              }, // button pressed
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image(image: AssetImage('assets/images/cross.png'),width: 60,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20,top: 20),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(25)
                                      ),
                                      // width: size.width,
                                      child: Column(children: [
                                        searchTextField = AutoCompleteTextField<Players>(
                                            style: new TextStyle(color: Colors.black, fontSize: 16.0),
                                            decoration: new InputDecoration(

                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                prefixIcon: Icon(Icons.search),
                                                disabledBorder: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Colors.black
                                                ),
                                                contentPadding:
                                                EdgeInsets.all(15),
                                                hintText: "Buscar Caleta..."),
                                            itemSubmitted: (item) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) => ThirdPage(post: item.value,navi: "/")
                                                  )
                                              );
                                              setState(() => searchTextField.textField.controller.text =
                                                  item.autocompleteterm);
                                            },
                                            clearOnSubmit: false,
                                            key: key,
                                            suggestions: PlayersViewModel.players,
                                            itemBuilder: (context, item) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(item.autocompleteterm,
                                                    style: TextStyle(
                                                        fontSize: 16.0
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemSorter: (a, b) {
                                              return a.autocompleteterm.compareTo(b.autocompleteterm);
                                            },
                                            itemFilter: (item, query) {
                                              return item.autocompleteterm
                                                  .toLowerCase()
                                                  .contains(query.toLowerCase());
                                            }),
                                      ],),
                                    ),
                                  ),
                                ],
                              ),
                            )..show();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/images/third.svg'),
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
                  ),
                ],
              ) :
              Column(
                children: [
                  Stack(
                    children: <Widget>[
                      isloading == true? Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Center(child:CircularProgressIndicator()),
                      ): _buildGoogleMap(context),
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
                                  size: Size(56, 56), // button width and height
                                  child: ClipOval(
                                    child: Material(
                                      color: Color(0xffE84616), // button color
                                      child: InkWell(
                                        splashColor: Colors.green, // splash color
                                        onTap: () {
                                          setState(() {
                                            show_drawer=true;
                                          });
                                        }, // button pressed
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.menu, color: Colors.white, size: 30,), // icon// text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(25),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black,
                                    //     spreadRadius: 1,
                                    //     blurRadius: 1,
                                    //   ),
                                    // ]
                              ),
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(30),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.white.withOpacity(0.9),
                              //         spreadRadius: 2,
                              //         blurRadius: 2,
                              //       ),
                              //     ]
                              // ),
                              width: size.width,
                              child: Material(
                            elevation: 50.0,
                            shadowColor: Colors.black,
                            // color: Colors.white,

                            borderRadius: BorderRadius.circular(25),
                                child: TextFormField(
                                  onFieldSubmitted: (e) async{
                                    _customInfoWindowController.hideInfoWindow();
                                    var addresses = await Geocoder.local.findAddressesFromQuery(e);
                                    var first = addresses.first;
                                    var newPosition = CameraPosition(
                                        target: LatLng(first.coordinates.latitude, first.coordinates.longitude),
                                        zoom: 16);
                                    CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);

                                    _controller.moveCamera(update);
                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  },
                                  decoration: new InputDecoration(
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      prefixIcon: Icon(Icons.search,color: Colors.black,),
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                      EdgeInsets.all(15),
                                      hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.black
                                  ),
                                      hintText: "Sector / Location..."),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Caletas Cercanas:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: size.width * 0.055),),
                        Text('Nearby coves:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.width * 0.045,fontStyle: FontStyle.italic,color: Colors.grey),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 15, left: 15, right: 15),
                    child: Divider(
                      thickness: 0.8,
                      color: Color(0xffCCCCCC),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 20, right: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox.fromSize(
                              size: Size(40, 40), // button width and height
                              child: ClipOval(
                                child: Material(
                                  color: Color(0xffE84616), // button color
                                  child: InkWell(
                                    splashColor: Colors.green, // splash color
                                    onTap: () {
                                      navigatorKey.currentState.pushNamed("/page2");
                                      setState(() {
                                        bookModel.selectedIndex=1;
                                      });
                                    }, // button pressed
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.menu, color: Colors.white, size: 20,), // icon// text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Filtro por Región',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700
                                  ),
                                ),
                                Text(
                                  'Filter by region:',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12, fontWeight: FontWeight.w700
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            active1? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 3)],
                              ),
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.white,
                              ),
                            ):InkWell(
                              onTap: (){
                                _scrollController.animateTo(
                                  0.0,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Color(0xFFF7941D),
                              ),
                            ),SizedBox(width: 8,),
                            active2? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 3)],
                              ),
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.white,
                              ),
                            ):InkWell(
                              onTap: (){
                                _scrollController.animateTo(
                                  double.parse(((_scrollController.position.maxScrollExtent/3).round()*2-1).toString()),
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Color(0xFFF7941D),
                              ),
                            ),SizedBox(width: 8,),
                            active3? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 3)],
                              ),
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.white,
                              ),
                            ):InkWell(
                              onTap: (){
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Color(0xFFF7941D),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  isloading_data==true?CircularProgressIndicator():Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 209,
                      child: NotificationListener<ScrollEndNotification>(
                        child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          children: new List.generate(top_5.length, (int index) {
                            // print("index===>> ${top_5[index]}");
                            return InkWell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Container(
                                  width: 150,
                                  height: 209,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(top_5[index]["better_featured_image"]==null ?top_5[index]['acf']['gallery'][0]['url'] : top_5[index]["better_featured_image"]["source_url"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              height: 35,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))
                                              ),
                                              child: Icon(Icons.add, color: Colors.black,)
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        height: 80,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${top_5[index]["title"]["rendered"]}',
                                                // textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                    fontSize: size.width * 0.033
                                                ),
                                              ),
                                              Text(
                                                'abcd',
                                                // textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: size.width * 0.03
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFF7941D).withOpacity(0.9),
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25))
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ),onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(
                                      builder: (context) => ThirdPage(post:  top_5[index],navi: "/",)));
                            },);
                          }),
                        ),
                        onNotification: (t){
                          if (t is ScrollEndNotification) {
                          }
                          return true;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, bottom: 35),
                    child: Container(
                      height: 50,
                      width: size.width * 0.7,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {
                          navigatorKey.currentState.pushNamed("/page2");
                          setState(() {
                            bookModel.selectedIndex=1;
                          });
                        },
                        color: Color(0xffE84616),
                        child: Column(

                          children: [
                            SizedBox(height: 6,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Ver caletas de Chile',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Text(
                              'abcd',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: size.width * 0.03
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: (_mapLoading)? 50:MediaQuery.of(context).size.height,
      width: (_mapLoading)? 50:MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove();
            },
            mapType: MapType.normal,
            initialCameraPosition:  CameraPosition(target: LatLng(lat,long), zoom: 12),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              print("Mao created");
              _controller=controller;
              _customInfoWindowController.googleMapController = controller;
              var newPosition = CameraPosition(
                  target: LatLng(lat, long),
                  zoom: 16);

              CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);

              _controller.moveCamera(update);
              setState(() => _mapLoading = false);
              // _controller.complete(controller);
            },
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
            markers: markers,
          ),
          _mapLoading==false?CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 65,
            width: 300,
            offset: 40,
          ):CircularProgressIndicator(),
        ],
      ),
    );
  }
}

