import 'package:flutter/material.dart';
import 'skill_button.dart';

class Skills extends StatefulWidget {
  final int skillnum;
  final Map<String, dynamic> servant;
  const Skills({super.key, required this.servant, required this.skillnum});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  List<String> skillLvls = ["1","2","3","4","5","6","7","8","9","10"];
  String currentSkillLvl = "1";
  List<dynamic> skills = [];
  List<bool> skillButtonBool = [];

  List<dynamic> getSkills(servant, skillnum) {
    List<dynamic> skills = [];

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
    if (skillButtonBool.isEmpty) {
      for (var _ in skills) {
        skillButtonBool.add(false);
      }
    }
    return _buildSkillWidget(widget.servant, skills, skillButtonBool);
  }

  Widget _buildSkillWidget(servant, skills, skillButtonBool) {

    return Container(
      color: const Color.fromARGB(255, 221, 221, 221),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                for (int i= 0; i <= skills.length - 1; i ++) ...[
                  InkWell(
                    child: SkillButton(skill: skills[i], selected: skillButtonBool[i]),
                    onTap: () {
                      setState(() {
                        if (skillButtonBool[i]) {
                          skillButtonBool[i] = !skillButtonBool[i];
                        } else {
                          for (int j = 0; j <= skills.length - 1; j++) {
                            skillButtonBool[j] = false;
                          }
                          skillButtonBool[i] = !skillButtonBool[i];
                        }
                      });
                    },
                  ),
                ]
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

}
  