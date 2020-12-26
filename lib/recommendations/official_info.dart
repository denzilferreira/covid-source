import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfficialInfo extends StatelessWidget {
  const OfficialInfo({Key key}) : super(key: key);

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
                "images/06.png",
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
                  child: Text("Trusted info", style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                    
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Read trusted sources, such as WHO or your local and national health authorities.",
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
