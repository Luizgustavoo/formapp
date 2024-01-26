// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

// ignore: must_be_immutable
class CustomFamilyCard extends StatelessWidget {
  String memberName;
  String memberContact;
  VoidCallback editMember;
  VoidCallback messageMember;
  VoidCallback supportMember;
  VoidCallback deleteMember;

  CustomFamilyCard({
    Key? key,
    this.memberName = '',
    this.memberContact = '',
    required this.editMember,
    required this.messageMember,
    required this.supportMember,
    required this.deleteMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(),
              title: Text(memberName,
                  style: CustomTextStyle.subtitleNegrit(context)),
              subtitle:
                  Text(memberContact, style: CustomTextStyle.subtitle(context)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 3,
                thickness: 2,
                color: Colors.orange.shade300,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 22,
                    onPressed: editMember,
                    icon: const Icon(Icons.edit_outlined)),
                IconButton(
                    iconSize: 22,
                    onPressed: messageMember,
                    icon: const Icon(Icons.email_outlined)),
                IconButton(
                    iconSize: 22,
                    onPressed: supportMember,
                    icon: const Icon(Icons.support_agent_rounded)),
                IconButton(
                    iconSize: 22,
                    onPressed: deleteMember,
                    icon: const Icon(Icons.delete_outlined)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
