import 'package:flutter/material.dart';

class Skills extends StatefulWidget {
  final int skillnum;
  final servant;
  const Skills({super.key, required this.servant, required this.skillnum});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  List<String> skillLvls = ["1","2","3","4","5","6","7","8","9","10"];
  String currentSkillLvl = "1";
  List<dynamic> skills = [];

  List<dynamic> getSkills(servant, skillnum) {
    List<dynamic> skills = [];
    if (servant == "") {
      return [];
    }
    for (var skill in servant["skills"]) {
      if (skill["num"] == skillnum) {
        skills.add(skill);
      }
    }
    return skills;
  }

  @override
  Widget build(BuildContext context) {
    skills = getSkills(widget.servant, widget.skillnum);
    return _buildSkillWidget(widget.servant, skills);
  }

  Widget _buildSkillWidget(servant, skills) {
    if (servant == "") {
      return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.network("https://static.atlasacademy.io/NA/SkillIcons/skill_00300.png", width: 50,),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "Charisma B",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButton(
              value: currentSkillLvl,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: skillLvls.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  currentSkillLvl = value.toString();
                });
              },
            )
          ]
        )
      );
    }

    return Container(
      color: const Color.fromARGB(255, 221, 221, 221),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                for (dynamic skill in skills)
                  _buildSkill(skill),
              ]
            )
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButton(
              value: currentSkillLvl,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: skillLvls.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  currentSkillLvl = value.toString();
                });
              },
            )
          ),
        ]
      )
    );
  }

  Widget _buildSkill(skill) {
    return  Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Image.network(skill["icon"], width: 50,),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              skill["name"],
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )
    );
  }
}
  