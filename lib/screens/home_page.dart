import 'package:flutter/material.dart';
import 'package:formapp/screens/create_family.dart';
import 'package:formapp/screens/list_family.dart';
import 'package:formapp/widgets/custom_card.dart';
import 'package:formapp/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notifications_rounded))
        ],
      ),
      drawer: const CustomDrawer(),
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
                  'Serviços',
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
          const Expanded(child: CategoryItems())
        ],
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 5),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 1,
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        padding: const EdgeInsets.all(8),
        children: [
          CustomCard(
              title: 'Cadastro de Família',
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const CreateFamily())));
              },
              imageUrl: 'assets/images/users.png'),
          CustomCard(
              title: 'Cadastro de Usuário',
              ontap: () {},
              imageUrl: 'assets/images/user.png'),
          CustomCard(
              title: 'Listagem de Famílias',
              ontap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => ListFamily())));
              },
              imageUrl: 'assets/images/list.png'),
          CustomCard(
              title: 'Mensagens',
              ontap: () {},
              imageUrl: 'assets/images/mensage.png'),
        ],
      ),
    );
  }
}
