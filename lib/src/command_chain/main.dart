import 'package:fgo_app/src/command_chain/servant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'np_cards.dart';
import 'skills.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Servant(),
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Command Chain Calculator',
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
  bool _validate = true;
  late Future<dynamic> _data;
  String servantName = "";
  Map<String, TextEditingController> _controllers = {};
  Color npColor = Colors.red;

  Future<dynamic> readJson() async {
    final String response = await rootBundle.loadString('lib/src/common/servant_data_large.json');
    dynamic data = await json.decode(response);
    return data;
  }

  void initControllers() {
    _controllers = {"servant_name": TextEditingController(text: "Altria Pendragon"), "level": TextEditingController(text: "1"), "attack": TextEditingController(text: "1734")};
  }

  void updateDataFields(servantData, controllers) {
    if (servantData != "") {
      level = int.tryParse(controllers["level"]?.text??'1') ?? 0;
      if (level >=1 && level <= 120) {
        controllers["attack"]?.text = servantData["atkGrowth"][level - 1].toString();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _data = readJson();
    initControllers();
  }


  @override
  Widget build(BuildContext context) {
    var servant = Provider.of<Servant>(context);
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Command Chain Calculator')
            ),  
            body: const Center(
              child: Text(
                "Loading Data...",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
              )
            )
          );
        } else {
          if (servant.name == "") {
            servant.initServant(snapshot.data);
          }
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
                          Image.network(servant.imageUrl, fit: BoxFit.contain),
                          const SizedBox(width: 20),
                          Flexible(
                            child:TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Servant Name',
                              ),
                              controller: _controllers["servant_name"],
                              onSubmitted: (text) {
                                var validServant = servant.getServant(text);
                                if (validServant != "") {
                                  level = int.parse(_controllers["level"]!.text);
                                  servant.updateServant(validServant, level);
                                  _controllers["attack"]!.text = servant.attack.toString();
                                }
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
                                  _controllers["attack"]?.text = servant.servantData["atkGrowth"][int.parse(value) - 1].toString();
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
                    for (Widget npWidget in _buildNpWidgets(servant.servantData)) 
                      npWidget,
                    for (int i = 1; i <=3; i++) ...[
                      Skills(servant: servant.servantData, skillnum: i),
                    ]
                  ],
                ),
              ), 
            ),
          );
        }
      }
    );
  }

  List<Widget> _buildNpWidgets(servant) {
    List<Widget> npWidgets = [];
    int npNum = 1;

    for (var np in servant["noblePhantasms"]) {
      npWidgets.add(
        NpWidget(servant: servant, np: np, npNum: npNum)
      );
      npNum += 1;
    }
    
    return npWidgets;
  }
}
