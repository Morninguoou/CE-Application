import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class StudyPlanPageS extends StatefulWidget {
  const StudyPlanPageS({super.key});

  @override
  State<StudyPlanPageS> createState() => _StudyPlanPageSState();
}

class _StudyPlanPageSState extends State<StudyPlanPageS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Study Plan',includeBackButton: true,),
    );
  }
}