import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_member.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/screens/edit_person.dart';

import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class EditPeopleView extends GetView<PeopleController> {
  final List<FamilyMember> familyMembersList = [];

  int editedFamilyMemberIndex = -1;

  EditPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
