import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'np_cards.dart';
import 'skills.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CommandChain(),
    );
  }
}



class CommandChain extends StatefulWidget {
  const CommandChain({super.key});

  @override
  State<CommandChain> createState() => _CommandChainState();
}

class _CommandChainState extends State<CommandChain> {
  int level = 1;
  bool _validate = false;
  dynamic _data = "";
  String servantName = "";
  dynamic _servantData = "";
  Map<String, TextEditingController> _controllers = Map();
  Color npColor = Colors.red;

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/src/common/servant_data_large.json');
    final data = await json.decode(response);
    setState(() {
      _data = data;
    });
  }

  void initControllers() {
    _controllers = {"servant_name": TextEditingController(text: "Altria Pendragon"), "level": TextEditingController(text: "1"), "attack": TextEditingController(text: "1734")};
  }

  String servantPic(servantController, data) {
    debugPrint(servantController.text);
    if (data == "") {
      return "https://static.atlasacademy.io/NA/Faces/f_1001000.png";
    }
    for (var servant in data) {
      
      if (servant["name"] == servantController.text) {
        return servant["extraAssets"]["faces"]["ascension"]["1"];
      }
    }
    return "https://static.atlasacademy.io/NA/Faces/f_1001000.png";
  }

  dynamic getServant(text, data) {
    for (var servant in data) {
      if (servant["name"] == text) {
        debugPrint(servant["name"]);
        return servant;
      }
    }
    return "";
  }

  void updateDataFields(servantData, controllers) {
    if (servantData != "") {
      level = int.tryParse(controllers["level"]?.text??'1') ?? 0;
      if (level >=1 && level <= 120) {
        controllers["attack"]?.text = servantData["atkGrowth"][level].toString();
      }
    }
  }

  @override
  void initState() {
    readJson();
    initControllers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Command Chain Calculator'),
      ),
      body: Align(
        child: Container(
          width: .9 * MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: ListView( 
            children: [
              Container(
                height: 60,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: Row(
                  children:  [
                    Image.network(servantPic(_controllers["servant_name"], _data), fit: BoxFit.contain),
                    const SizedBox(width: 20),
                    Flexible(
                      child:TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Servant Name',
                        ),
                        controller: _controllers["servant_name"],
                        onSubmitted: (text) {
                          setState(() {
                            _servantData = getServant(text, _data);
                            updateDataFields(_servantData, _controllers);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Lvl',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Lvl',
                        ),
                        controller: _controllers["level"],
                        validator: (value) {
                          level = int.tryParse(value??'1') ?? 0;
                          if (level < 1 || level > 120) {
                            _validate = false;
                            return 'Please enter a number between 1 and 120';
                          }
                          _validate = true;
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if (_validate) {
                            _controllers["attack"]?.text = _servantData["atkGrowth"][int.parse(value) - 1].toString();
                          }
                        },
                      ),
                    ),
                    const Text(
                      'Attack',
                      style: TextStyle(fontSize: 20),
                      ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Attack',
                        ),
                        controller: _controllers["attack"],
                      ),
                    ),
                  ],
                )
              ),
              for (Widget npWidget in _buildNpWidgets(_servantData)) 
                npWidget,
              Skills(servant: _servantData, skillnum: 1),
              Skills(servant: _servantData, skillnum: 2),
              Skills(servant: _servantData, skillnum: 3),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNpWidgets(servant) {
    List<Widget> npWidgets = [];
    int npNum = 1;

    if (servant == "") {
      npWidgets.add(
        NpWidget(servant: servant, np: "", npNum: 1)
      );

      npWidgets.add(
        Container(
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
                    "Excalibur (Upgrade 1)",
                    style: TextStyle(
                      fontSize: 25, 
                      fontWeight: FontWeight.bold,
                    )
                  )
                )
              ),
            ]
          )
        )
      );

      return npWidgets;
    }

    for (var np in servant["noblePhantasms"]) {
      npWidgets.add(
        NpWidget(servant: servant, np: np, npNum: npNum)
      );
      npNum += 1;
    }
    
    return npWidgets;
  }
}
