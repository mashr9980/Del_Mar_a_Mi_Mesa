import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_new/components/expension_datos.dart';
import 'package:flutter_new/components/front_logo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_new/components/players.dart';
import 'package:flutter_new/screens/fifth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'fourth_page.dart';
import 'main_page.dart';

class ThirdPage extends StatefulWidget {
  final post;
  final navi;
  const ThirdPage({Key key, this.post,this.navi}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  GlobalKey<AutoCompleteTextFieldState<Players>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;
  int _current = 0;
  final CarouselController _controller_coursal = CarouselController();
  YoutubePlayerController _controller_you;
  @override
  void initState(){
    print(widget.post["content"]["rendered"]);
    final ireg=RegExp(r'(?<=src=").*?(?=[\?"])');
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(ireg.allMatches(widget.post["content"]["rendered"]).map((m) => m.group(0)).join(' '));
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
    print("sdfsdfdsfds");
    final ireg=RegExp(r'(?<=src=").*?(?=[\?"])');
    return Scaffold(
      body: SingleChildScrollView(
        child: VisibilityDetector(
          key: Key("unique key"),
          onVisibilityChanged: (VisibilityInfo info) {
            debugPrint("${info.visibleFraction} of my widget is visible");
            if(info.visibleFraction == 0){
              _controller_you.pause();
            }

          },
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
                  Stack(
                    children: <Widget>[
                      Container(
                        height: size.height / 3,
                        decoration: BoxDecoration(
                            image: DecorationImage(fit: BoxFit.cover,
                                image: NetworkImage(widget.post["better_featured_image"]==null ? widget.post['acf']['gallery'][0]['url'] : widget.post["better_featured_image"]["source_url"])
                            )
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
                                                              hintText: "Buscar Caleta..."
                                                          ),
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
                          Padding(
                            padding: const EdgeInsets.only(top:125.0, left: 20, right: 20),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '“${widget.post["title"]["rendered"]}”',
                                  style: TextStyle(
                                      fontSize: size.width * 0.05, fontWeight: FontWeight.w700
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Html(
                                      data:'${widget.post["content"]["rendered"].indexOf('<figure')<0?widget.post["content"]["rendered"]:widget.post["content"]["rendered"].substring(0, widget.post["content"]["rendered"].indexOf('<figure'))}'
                                          // .replaceAll(RegExp("height=\"([0-9]{1,4})\""),r'height=\"100%"\').replaceAll(RegExp("width=\"([0-9]{1,4})\""),r'width=\"100%"\').replaceAll("<iframe",'<iframe style="overflow:hidden;height:100%;width:100%" ')}'

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
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              SizedBox(width: size.width * 0.04,),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Acceder a /',
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.w700
                                  ),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10, top: 10),
                            child: Container(
                              height: 50,
                              width: size.width,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                onPressed: () {
                                  // print("Data======================>> ${widget.post["acf"]["informacion_gastronomica"]}");
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => FirthPage(post:  widget.post["acf"]["informacion_gastronomica"],
                                            image: widget.post["better_featured_image"]==null ? widget.post['acf']['gallery'][0]['url'] : widget.post["better_featured_image"]["source_url"],)
                                      )
                                  );
                                },
                                color: Color(0xffE84616),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // SizedBox(height: 4,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          // SizedBox(width: size.width * 0.04,),
                                          Text(
                                            'Información Gastronómica',
                                            style: TextStyle(
                                              fontSize: size.width * 0.040,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          // SizedBox(width: size.width * 0.05,),
                                          Icon(
                                            Icons.navigate_next_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Gastronomic Information',
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 50,
                              width: size.width,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => FifthPage(post:  widget.post["acf"]["informacion_turistica"],image:  widget.post["better_featured_image"]==null ? widget.post['acf']['gallery'][0]['url'] : widget.post["better_featured_image"]["source_url"],)
                                      )
                                  );
                                },
                                color: Color(0xff188D8D),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          // SizedBox(width: size.width * 0.04,),
                                          Text(
                                            'Información Turística',
                                            style: TextStyle(
                                              fontSize: size.width * 0.040,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          // SizedBox(width: size.width * 0.159,),
                                          Icon(
                                            Icons.navigate_next_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Tourist Information',
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                // SizedBox(width: size.width * 0.002,),
                                SvgPicture.asset('assets/images/datos.svg'),
                                SizedBox(width: 30),
                                Text(
                                  'Datos / ',
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.w700
                                  ),
                                ),
                                Text(
                                  'Information:',
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
                          Divider(
                            endIndent: 15,indent: 15,
                            color: Colors.grey,
                            thickness: 0.6,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Container(
                              child: ExpansionDatos(datos: widget.post["acf"]["repeater_datos"],),
                            ),
                          ),
                          Divider(
                            endIndent: 15,indent: 15,
                            color: Colors.grey,
                            thickness: 0.6,
                          ),
                          widget.post["acf"].containsKey("iconos_y_otros_datos")?
                          widget.post["acf"]["iconos_y_otros_datos"]!=false?Column(children: List.generate(widget.post["acf"]["iconos_y_otros_datos"].length, (index){
                            return
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0, right: 25),
                                    child: Container(
                                      // color: Colors.white,
                                      height: 52,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${widget.post["acf"]["iconos_y_otros_datos"][index]["frase_asociada_al_icono"]}',
                                            style: TextStyle(
                                                fontSize: size.width * 0.040, fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Image(image: NetworkImage('${widget.post["acf"]["iconos_y_otros_datos"][index]["icono"]["url"]}'),)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Divider(
                                  //   endIndent: 15,indent: 15,
                                  //   color: Colors.grey,
                                  //   thickness: 0.6,
                                  // ),
                                ],
                              );}

                          ),):SizedBox():SizedBox(),
                          SizedBox(height: size.height * 0.05,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(30)
                            ),

                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.05,),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/images/camera.svg'),
                                      // Image(image: AssetImage('assets/images/camera.png')),
                                      SizedBox(width: 25),
                                      Text(
                                        'Galería:',
                                        style: TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: Colors.grey,
                                  decoration: BoxDecoration(color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  height: 170,
                                  child: new ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: new List.generate(widget.post["acf"]["gallery"].length, (int index) {
                                      return InkWell(
                                        onTap: (){
                                          final List<Widget> imageSliders__ = [];
                                          for(var i=0;i<widget.post["acf"]["gallery"].length;i++){
                                            imageSliders__.add(Container(
                                              child: Container(
                                                margin: EdgeInsets.all(5.0),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Image.network(widget.post["acf"]["gallery"][i]["url"], fit: BoxFit.cover, width: 1000.0),
                                                        Positioned(
                                                          bottom: 0.0,
                                                          left: 0.0,
                                                          right: 0.0,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  Color.fromARGB(200, 0, 0, 0),
                                                                  Color.fromARGB(0, 0, 0, 0)
                                                                ],
                                                                begin: Alignment.bottomCenter,
                                                                end: Alignment.topCenter,
                                                              ),
                                                            ),
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: 10.0, horizontal: 20.0),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ));
                                          }
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                            bool isChecked = false;
                                            return StatefulBuilder(builder: (context, setState) {
                                              return Container(
                                                // width: size.width*0.8,
                                                // decoration: ,
                                                // title: Text("Title"),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:size.width*0.8,
                                                      decoration:BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),),
                                                      child: CarouselSlider(
                                                        options: CarouselOptions(
                                                          aspectRatio: 0.5,
                                                          height: 180,
                                                          viewportFraction: 1,
                                                          autoPlay: true,
                                                          enlargeCenterPage: true,
                                                          // enlargeCenterPage: true,
                                                          scrollDirection: Axis.horizontal,
                                                          onPageChanged: (index, reason) {
                                                            // print(_current);
                                                            setState(() {
                                                              _current = index;
                                                            });
                                                          },
                                                        ),
                                                        items: imageSliders__,
                                                        carouselController: _controller_coursal,

                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: imageSliders__.asMap().entries.map((entry) {
                                                        // print("key ");
                                                        // print(entry.key);
                                                        // print(_current);
                                                        return GestureDetector(
                                                          onTap: () => _controller_coursal.animateToPage(entry.key),
                                                          child: Container(
                                                            width: 12.0,
                                                            height: 12.0,
                                                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color:Colors.white
                                                                    .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                   // Text("Sample")
                                                  ],
                                                ),
                                              );
                                            });
                                            });

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 5, top: 10, bottom: 50,),
                                          child: new Container(
                                              width: 144,
                                              // height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                // color: Colors.white,
                                                image: DecorationImage(
                                                  image: NetworkImage(widget.post["acf"]["gallery"][index]["url"]),
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
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))
                                                          ),
                                                          // color: Colors.white,
                                                          child: Icon(Icons.add, color: Colors.black,)
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                      );
                                    }),
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
                                        navigatorKey.currentState.pushNamed("${widget.navi=="/"?widget.navi:"/page2"}");
                                      },
                                      color: Color(0xff188D8D),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.navigate_before,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 15,),
                                          Text(
                                            'VOLVER/ ',
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
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}