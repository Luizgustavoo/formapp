import 'package:flutter/material.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class EditPeopleView extends GetView<EditPeopleController> {
  const EditPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('EditPeopleViewPage')),
        body: const SafeArea(child: Text('EditPeopleViewController')));
  }
}
