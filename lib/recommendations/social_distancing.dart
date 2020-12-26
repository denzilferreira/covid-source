import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialDistancing extends StatelessWidget {
  const SocialDistancing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24)
      ),
      child: Row(
        children: [
          Image(
              image: AssetImage(
                "images/05.png",
              ),
              width: 120),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.only(top:8),
                  child: Text("Social Distance", style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                    
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Maintain at least a 1-metre distance between yourself and others, especially indoors.",
                    softWrap: true,
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
