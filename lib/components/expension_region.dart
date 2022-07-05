import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_new/apis/apis.dart';
import 'package:flutter_new/screens/third_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

// ignore: non_constant_identifier_names
Future<Item> generateItems(Apis) async{
  var result =await Apis.getRegions();
  return json.decode(result);
}

/// This is the stateful widget that the main application instantiates.
class ExpansionRegion extends StatefulWidget {
  final post;
  const ExpansionRegion({Key key,this.post}) : super(key: key);

  @override
  State<ExpansionRegion> createState() => _ExpansionRegionState();
}

/// This is the private State class that goes with Expansion.
class _ExpansionRegionState extends State<ExpansionRegion> with TickerProviderStateMixin{
  List<double> animatedheight = [];
  var isloading=true;
  // ignore: non_constant_identifier_names
  List get_post(id){
    print(id);
    List sort_post=[];
    for(var i=0;i<widget.post.length;i++){
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
    // TODO: implement initState
    super.initState();
    get_regions();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPanel();
  }

  Widget _buildPanel() {
    Size size = MediaQuery.of(context).size;
    return isloading?Container(child: Center(child: CircularProgressIndicator())):Container(
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
                    height: 55,
                    width: size.width,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      elevation: 0.0,
                      onPressed: () {
                        setState(() {
                          animatedheight[index]!=0.0?animatedheight[index]=0.0:animatedheight[index]=209.0;
                          open[index] = !open[index];
                        });
                      },
                      color: Color(0xff188D8D),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${_data[index].headerValue}',
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
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
                  duration: Duration(seconds: 1),
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
                                    image: NetworkImage("${_data[index].post[index__]["better_featured_image"]["source_url"]}"),
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
                                      height: 70,
                                      child: Center(
                                        child: Text(
                                          '${_data[index].post[index__]["title"]["rendered"]}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
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
    );
  }
}
