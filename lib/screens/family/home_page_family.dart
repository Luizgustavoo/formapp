import 'package:flutter/material.dart';
import 'package:formapp/screens/family/widgets/custom_drawer_family.dart';
import 'package:formapp/screens/family/widgets/custom_list_tile_family.dart';

class HomePageFamily extends StatefulWidget {
  const HomePageFamily({super.key});

  @override
  State<HomePageFamily> createState() => _HomePageFamilyState();
}

class _HomePageFamilyState extends State<HomePageFamily> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      appBar: AppBar(
        title: const Text('NOME DA FAMILIA'),
      ),
      drawer: const CustomDrawerFamily(),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: const Text(
                  'Composição Familiar',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.orange.shade500,
                ),
              ),
            ],
          ),
          const Expanded(child: CustomListTileFamily())
        ],
      ),
    );
  }
}
