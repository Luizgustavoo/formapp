// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

// ignore: must_be_immutable
class CustomFamilyCard extends StatefulWidget {
  bool stripe = false;
  String familyName;
  String provedor;
  int moradores;
  VoidCallback editFamily;
  VoidCallback messageMember;
  VoidCallback supportFamily;
  VoidCallback deleteFamily;
  VoidCallback? addMember;
  VoidCallback? onEditPerson;
  VoidCallback? onDeletePerson;
  bool showAddMember = false;
  List<String>? peopleNames;

  CustomFamilyCard(
      {Key? key,
      this.familyName = '',
      this.provedor = '',
      this.moradores = 0,
      required this.editFamily,
      required this.messageMember,
      required this.supportFamily,
      required this.deleteFamily,
      this.addMember,
      required this.stripe,
      this.peopleNames,
      this.onEditPerson,
      this.onDeletePerson,
      this.showAddMember = false})
      : super(key: key);

  @override
  State<CustomFamilyCard> createState() => _CustomFamilyCardState();
}

class _CustomFamilyCardState extends State<CustomFamilyCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 3,
        color: widget.stripe ? Colors.grey.shade300 : Colors.white,
        child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ExpansionTile(
              childrenPadding:
                  const EdgeInsets.only(left: 18, right: 18, bottom: 5),
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                });
              },
              title: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        widget.familyName[0].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    title: Text(widget.familyName,
                        style: CustomTextStyle.subtitleNegrit(context)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.provedor,
                            style: CustomTextStyle.subtitle(context)),
                        Text("${widget.moradores} Moradores Cadastrados",
                            style: CustomTextStyle.subtitle(context)),
                      ],
                    ),
                  ),
                  Divider(
                    height: 3,
                    thickness: 2,
                    color: Colors.orange.shade300,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isExpanded) ...[
                        IconButton(
                          iconSize: 22,
                          onPressed: widget.editFamily,
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          iconSize: 22,
                          onPressed: widget.messageMember,
                          icon: const Icon(Icons.email_outlined),
                        ),
                        IconButton(
                          iconSize: 22,
                          onPressed: widget.supportFamily,
                          icon: const Icon(Icons.support_agent_rounded),
                        ),
                        if (widget.showAddMember)
                          IconButton(
                            iconSize: 22,
                            onPressed: widget.addMember,
                            icon: const Icon(Icons.add_rounded),
                          ),
                        IconButton(
                          iconSize: 22,
                          onPressed: widget.deleteFamily,
                          icon: const Icon(Icons.delete_outlined),
                        ),
                      ]
                    ],
                  )
                ],
              ),
              children: [
                for (String name in widget.peopleNames!)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.clip,
                        style: CustomTextStyle.subtitle(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: widget.onEditPerson,
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 22,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onDeletePerson,
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 22,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            )),
      ),
    );
  }
}
