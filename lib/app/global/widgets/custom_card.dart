import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final VoidCallback? ontap;
  final String? imageUrl;

  const CustomCard({
    Key? key,
    @required this.title,
    @required this.ontap,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: InkWell(
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        onTap: ontap,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.height * 0.12,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFF123d68),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black, // Cor da borda
                  width: 2, // Largura da borda
                ),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.height *
                        0.08, // Reduzindo o tamanho da imagem
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppinss',
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
