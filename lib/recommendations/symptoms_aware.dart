import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SymptomsAware extends StatelessWidget {
  const SymptomsAware({Key key}) : super(key: key);

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
                "images/04.png",
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
                  child: Text("Symptoms aware", style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                    
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Stay home and self-isolate even if you have minor symptoms, until you recover.",
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
