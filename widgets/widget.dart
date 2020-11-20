import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
                    mainAxisAlignment: kIsWeb
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Recipe",
                        style: GoogleFonts.libreFranklin(
                            fontSize: 24,
                            color: Colors.white,
                             fontWeight: FontWeight.normal,   
                            ),
                      ),
                      Text(
                        "App",
                        style: GoogleFonts.libreFranklin(
                            fontSize: 24,
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            ),
                      )
                    ],
                  ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(
            "What will you cook today?",
            style: GoogleFonts.workSans(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(
            "Just Enter Ingredients you have and we will show the best recipe for you",
            style: GoogleFonts.workSans(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                ),
          ),
        ),
      ],
      
    );
  }
}