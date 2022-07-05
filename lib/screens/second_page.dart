import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/apis/apis.dart';
import 'package:flutter_new/components/bottom_navigation.dart';
import 'package:flutter_new/components/front_logo.dart';
import 'package:flutter_new/components/expension_region.dart';
import 'package:flutter_new/components/players.dart';
import 'package:flutter_new/screens/third_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main_page.dart';
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.post,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  var post;
  bool isExpanded;
}
class SecondPage extends StatefulWidget {
  final post;
  const SecondPage({Key key,this.post}) : super(key: key);


  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin{
  GlobalKey<AutoCompleteTextFieldState<Players>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();
  var new_height=0;
  // var open=false;
  void _loadData() async {
    await PlayersViewModel.loadPlayers(widget.post);
  }

  List<double> animatedheight = [];
  var isloading=true;
  // var is_loading_expension
  // ignore: non_constant_identifier_names
  List get_post(id){
    print(id);
    List sort_post=[];
    for(var i=0;i<widget.post.length;i++){
      print("categories ${widget.post[i]["categories"]}");
      print("id to search ${id}");
      if(widget.post[i]["categories"].contains(id)){
        sort_post.add(widget.post[i]);
      }
    }
    return sort_post;
  }
  Apis _Apis = Apis();
  final List<Item> _data = [];
  final List open=[];
  // ignore: non_constant_identifier_names
  Future<String> get_regions() async {
    var result = await _Apis.getRegions();
    var resultFromJson = json.decode(result);

    for(var element in resultFromJson) {
      if(element["name"]!="Sin Región"){
        var resultFromJsonPost =  get_post(element["id"]);
        setState(() {
          open.add(false);
          animatedheight.add(0.0);
          _data.add(
              Item(
                headerValue: element["name"],
                expandedValue: 'This is item number ',
                post: [],
              )
          );
        });


        for(var element_post in resultFromJsonPost){
          setState(() {
            _data.last.post.add(element_post);
            isloading=false;
          });
        }
      }
    }
    return '';
  }

  @override
  void initState() {
    _loadData();
    get_regions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff073655),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40))
              ),
              height: isloading ? size.height:(size.height+((size.height-_data.length*209).abs()+10))+new_height,
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        height: size.height / 3,
                        decoration: BoxDecoration(
                            image: DecorationImage(fit: BoxFit.cover,
                                image: AssetImage('assets/images/second_page_img.png')
                            )
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                          AwesomeDialog(
                                            context: context,
                                            aligment: Alignment.topCenter,
                                            dismissOnTouchOutside:true,
                                            dialogType: DialogType.NO_HEADER,
                                            dialogBackgroundColor: Colors.transparent.withOpacity(0.0),
                                            body: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top :8.0, right: 20),
                                                  child: Align(
                                                    alignment: Alignment.bottomRight,
                                                    // padding: const EdgeInsets.only(bottom: 60.0,right: 15),
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
                                                              prefixIcon: Icon(Icons.search,color: Colors.black,),
                                                              hintStyle: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 18,
                                                                  color: Colors.black
                                                              ),
                                                              disabledBorder: InputBorder.none,
                                                              contentPadding:
                                                              EdgeInsets.all(15),
                                                              hintText: "Buscar Caleta ..."),
                                                          itemSubmitted: (item) {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => ThirdPage(post: item.value,)
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
                                                  )
                                                ),
                                              ],
                                            ),
                                          )..show();
                                        }, // button pressed
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.search, color: Colors.white, size: 30,), // icon// text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: size.height * 0.088,),
                          Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                              child: Card(
                                color: Color(0xffF6F5F5),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        SvgPicture.asset('assets/images/2card.svg',width: 50,),
                                        SizedBox(height: size.height * 0.008,),
                                        Text(
                                          'Caletas de Chile',
                                          style: TextStyle(letterSpacing: 1.2,
                                              fontSize: size.width * 0.05, fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Lorem salutandi eu mea, ea mei, per eu alterum electram adversarium. Ea vix probo dicta iuvaret.', textAlign: TextAlign.center,
                                            style: TextStyle(letterSpacing: 0.8,
                                                fontSize: size.width * 0.036, fontWeight: FontWeight.w300
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                      child: isloading?Container(child: Center(child: CircularProgressIndicator())):Container(
                          height: size.height,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _data.length,
                            itemBuilder: (context, index) {

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10, top: 10),
                                    child: Container(
                                      height: 50,
                                      width: size.width,
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        elevation: 0.0,
                                        onPressed: () {
                                          setState(() {
                                            animatedheight[index]!=0.0?animatedheight[index]=0.0:animatedheight[index]=209.0;
                                            open[index] = !open[index];

                                            open[index]?new_height+=209:new_height-=209;
                                          });
                                        },
                                        color: Color(0xff188D8D),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '${_data[index].headerValue}',
                                                    style: TextStyle(
                                                      fontSize: size.width * 0.04,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
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
                                              Container(
                                                padding: EdgeInsets.all(12),
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: Colors.white,
                                                ),
                                                child: open[index] ? SvgPicture.asset('assets/images/Polygon 1.svg') : SvgPicture.asset('assets/images/Polygon 2.svg',width: 20,),
                                              )

                                            ],
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ), AnimatedSize(
                                    duration: Duration(microseconds: 300),
                                    vsync: this,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      height: open[index] ? 209 : 0.0,
                                      child: new ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: new List.generate(_data[index].post.length, (int index__) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 25.0, bottom: 30, top: 10),
                                            child: new InkWell(
                                              child: Container(
                                                  width: 150,
                                                  height: 220,
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
                                                      image: NetworkImage("${_data[index].post[index__]["better_featured_image"]==null ?_data[index].post[index__]['acf']['gallery'][0]['url'] :_data[index].post[index__]["better_featured_image"]["source_url"]}"),
                                                      fit: BoxFit.fill,
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
                                                        padding: EdgeInsets.all(7),
                                                        height: 80,
                                                        child: Center(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                '${_data[index].post[index__]["title"]["rendered"]}',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Colors.white,
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
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                              onTap: (){
                                                Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext context) => ThirdPage(post: _data[index].post[index__],)
                                                    )
                                                );
                                              },
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },)
                      )
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
