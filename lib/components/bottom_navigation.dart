import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/components/players.dart';
import 'package:flutter_new/screens/main_page.dart';
import 'package:flutter_new/screens/second_page.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_new/screens/third_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData});
  var iconData;
  // String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.items,
    this.height: 60.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
    this.currentindex
  }) {
    assert(this.items.length == 1 || this.items.length == 3);
  }
  final List<FABBottomAppBarItem> items;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  final currentindex;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;
  BaseModel bookModel;

  _updateIndex(int index) {

    widget.onTabSelected(index);
    setState(() {
      if(index!=2) {
        _selectedIndex = index;
        bookModel.selectedIndex=index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bookModel= Provider.of(context);
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = bookModel.selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(item.iconData, color: color,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class BaseModel extends ChangeNotifier {
  int _selectedIndex = 0;

  set selectedIndex(int val) {_selectedIndex = val;notifyListeners();} // optionally perform validation, etc

  int get selectedIndex => _selectedIndex;

  notifyChange() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
class Navv extends StatefulWidget {
  final posts;
  final context_;
  const Navv({Key key,this.posts,this.context_}) : super(key: key);

  @override
  _NavvState createState() => _NavvState();
}

class _NavvState extends State<Navv> {
  GlobalKey<AutoCompleteTextFieldState<Players>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  void _loadData() async {
    await PlayersViewModel.loadPlayers(widget.posts);
  }
  @override
  void initState() {
    _loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FABBottomAppBar(
      currentindex: 1,
      // color: Colors.white,
      backgroundColor: Color(0xFF073655),
      // selectedColor: Colors.white,
      notchedShape: CircularNotchedRectangle(),
      // color: Colors.transparent,
      selectedColor: Colors.white,

      items: [
        FABBottomAppBarItem(iconData: 'assets/images/3.svg'),
        FABBottomAppBarItem(iconData: 'assets/images/2.svg'),
        FABBottomAppBarItem(iconData: 'assets/images/1.svg'),
      ], onTabSelected: (int value) {
      if(value==0){
        navigatorKey.currentState.pushNamed("/");
      }
      else if(value==1){
        navigatorKey.currentState.pushNamed("/page2");
      }
      else{
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
                    size: Size(56, 56),
                    child: ClipOval(
                      child: Material(
                        color: Color(0xffE84616),
                        child: InkWell(
                          splashColor: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                          },
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
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.black
                            ),
                            contentPadding:
                            EdgeInsets.all(15),
                            hintText: "Buscar Caleta ..."),
                        itemSubmitted: (item) {
                          // print("itemmmmmmmmmmmmmmmm ${item.value}");
                          // Navigator.pop(context);
                          Navigator.of(widget.context_).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => ThirdPage(post: item.value,navi: value==0?"/":"/page2",)
                              )
                          );
                          // navigatorKey.currentState.pushNamed("/page2");
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10,bottom: 10),
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: size.width,
                    // height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text("Search",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: size.width * 0.045),)
                ),
              ),
            ],
          ),
        )..show();
      }
    },
    );
  }
}
