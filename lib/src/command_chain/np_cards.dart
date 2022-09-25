import 'package:flutter/material.dart';

class NpWidget extends StatefulWidget {
  final dynamic servant;
  final dynamic np;
  final int npNum;

  const NpWidget({super.key, required this.servant, required this.np, required this.npNum});

  @override
  State<NpWidget> createState() => _NpWidgetState();
}

class _NpWidgetState extends State<NpWidget> {
  Image backgroundImage = Image.asset("lib/src/common/npbustercard.png", width: 63);
  Image foregroundIcon = Image.asset("lib/src/common/busterIcon.png", width: 69);
  Color barColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    if (widget.servant == "") {
      return Container(
        height: 100,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          color: Colors.red,
        ),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("lib/src/common/npbustercard.png", width: 63),
                  Image.network("https://static.atlasacademy.io/NA/Servants/Commands/100100/card_servant_1.png"),
                  Positioned(
                    top: 49,
                    left: 8,
                    child:Image.asset("lib/src/common/busterIcon.png", width: 69),
                  ),
                  Positioned(
                    top: 51,
                    child: Image.network("https://static.atlasacademy.io/NA/Servants/Commands/100100/card_servant_np.png", width: 80),
                  ),
                ],
              )
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Excalibur",
                  style: TextStyle(
                    fontSize: 25, 
                    fontWeight: FontWeight.bold,
                  )
                )
              )
            ),
          ]
        )
      );      
    }

    if (widget.np["card"] == "buster") {
      backgroundImage = Image.asset("lib/src/common/npbustercard.png", width: 63);
      foregroundIcon = Image.asset("lib/src/common/busterIcon.png", width: 69);
      barColor = Colors.red;
    } else if (widget.np["card"] == "arts") {
      backgroundImage = Image.asset("lib/src/common/npartscard.png", width: 63);
      foregroundIcon = Image.asset("lib/src/common/artsIcon.png", width: 69);    
      barColor = Colors.blue;  
    } 



    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        color: barColor,
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                backgroundImage,
                Image.network(widget.servant["extraAssets"]["commands"]["ascension"]["1"]),
                Positioned(
                  top: 49,
                  left: 8,
                  child: foregroundIcon,
                ),
                Positioned(
                  top: 51,
                  child: Image.network(widget.np["icon"], width: 80),
                ),
              ],
            )
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: _buildNpName(widget.np, widget.servant, widget.npNum)
            )
          ),
        ]
      )
    );
  }   

  }
  Widget _buildNpName(np, servant, npNum) {
    String npName = np["name"];

    if (npNum >= 2) {
      npName = np["name"] + " (Upgrade ${npNum - 1})";
    }

    return Text(
      npName,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      )
    );
}





