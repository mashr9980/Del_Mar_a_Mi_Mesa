import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_new/components/bottom_navigation.dart';
import 'package:flutter_new/components/front_logo.dart';
import 'package:flutter_new/components/players.dart';
import 'package:flutter_new/screens/second_page.dart';
import 'package:flutter_new/screens/third_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'main_page.dart';

class FirthPage extends StatefulWidget {
  final post;
  final image;
  const FirthPage({Key key, this.post,this.image}) : super(key: key);

  @override
  _FirthPageState createState() => _FirthPageState();
}

class _FirthPageState extends State<FirthPage> {
  GlobalKey<AutoCompleteTextFieldState<Players>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;

  // final CarouselController _controller_coursal = CarouselController();
  YoutubePlayerController _controller_you;
  @override
  void initState(){
    final ireg=RegExp(r'(?<=src=").*?(?=[\?"])');
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(ireg.allMatches(widget.post).map((m) => m.group(0)).join(' '));
    print(videoId); // BBAyRBTfsOU
    _controller_you= YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,

      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff073655),
          ),
          child: Container(
            // height: size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40))
            ),
            child: Column(
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: size.height / 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(fit: BoxFit.cover,
                              image: NetworkImage(widget.image)
                          )
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                ),
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
                        Padding(
                          padding: const EdgeInsets.only(top:120.0, left: 20, right: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image(image: AssetImage('assets/images/jhbhj.png')),
                                  SizedBox(width: 30),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Información\nGastronómica:',
                                        style: TextStyle(
                                            fontSize: size.width * 0.06, fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Text(
                                        'Gastronomic Information',
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
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Html(
                                    data:'${widget.post.indexOf('<iframe')<0?widget.post:widget.post.substring(0, widget.post.indexOf('<iframe'))}'
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: YoutubePlayer(
                                  controller: _controller_you,
                                  showVideoProgressIndicator: true,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(isExpanded: true,),
                                    RemainingDuration(),
                                    const PlaybackSpeedButton(),
                                  ],
                                  onReady: (){
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
                          child: Container(
                            height: 50,
                            width: size.width * 0.5,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Color(0xffE84616),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.navigate_before,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    'VOLVER /',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'BACK',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}