import 'package:flutter/material.dart';
import 'package:flutter_new/components/icons.dart';
import 'package:flutter_new/components/path_line.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FrontLogo extends StatelessWidget {
  const FrontLogo({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: BottomWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 160,
        width: size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              Container(
                height: 90,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/logo1.png'
                    )
                  )
                ),
                // child: SvgPicture.asset('assets/images/Mask Group.svg', color: Colors.grey,),
              ),
              SizedBox(width: 10),
              Container(
                height: 80,
                width: 90,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/logo3.png'
                        )
                    )
                ),
                // child: SvgPicture.asset(splashIcon1, color: Colors.blue,),
              )
            ],
          ),
        ),
      ),
    );
  }
}