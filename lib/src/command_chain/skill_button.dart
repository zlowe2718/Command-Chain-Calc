import 'package:flutter/material.dart';

class SkillButton extends StatefulWidget {
  final dynamic skill;
  final bool selected;

  const SkillButton({super.key, required this.skill, required this.selected});

  @override
  State<SkillButton> createState() => _SkillButtonState();
}

class _SkillButtonState extends State<SkillButton> {

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              widget.selected ? Colors.transparent : Colors.grey,
              BlendMode.saturation,
            ),
            child: Image.network(widget.skill["icon"], width: 50,)
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.skill["name"],
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )
    );
  }
}