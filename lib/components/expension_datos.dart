import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_new/apis/apis.dart';
import 'package:intl/intl.dart';
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

// ignore: non_constant_identifier_names
Future<Item> generateItems(Apis) async{
  var result =await Apis.getRegions();
  // print(json.decode(result));
  return json.decode(result);
}

/// This is the stateful widget that the main application instantiates.
class ExpansionDatos extends StatefulWidget {
  final datos;
  const ExpansionDatos({Key key,this.datos}) : super(key: key);

  @override
  State<ExpansionDatos> createState() => _ExpansionDatosState();
}

/// This is the private State class that goes with Expansion.
class _ExpansionDatosState extends State<ExpansionDatos> {
  List<Item> _data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

      for(var i=0;i<widget.datos.length;i++){
        print(widget.datos[i]);
        setState(() {
          _data.add(Item(expandedValue: widget.datos[i]["datos"], headerValue: widget.datos[i]["titulo"]));
        });

      }
    });
    // get_regions();
    // var result =await _Apis.getRegions();
    // print(json.decode(result));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildPanel(),
    );
  }

  Widget _buildPanel() {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.white),
        child: ExpansionPanelList(
          animationDuration: Duration(milliseconds: 50),
          dividerColor: Colors.grey.withOpacity(0.5),
          elevation: 0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((Item item) {
            // print(_data);
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.headerValue,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: size.width * 0.040,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'abcd',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: size.width * 0.03
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Container(
                  // width: 164,
                  // height: 209,
                  child: Text(
                    Bidi.stripHtmlIfNeeded(item.expandedValue).split("\n")[0],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}