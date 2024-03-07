import 'package:flutter/material.dart';

class CoachMarkDesc extends StatefulWidget {
  const CoachMarkDesc(
      {super.key,
      required this.text,
      this.skip = 'Sair',
      this.next = 'Próximo',
      this.onSkip,
      this.onNext});

  final String text;
  final String? skip;
  final String? next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachMarkDesc> createState() => _CoachMarkDescState();
}

class _CoachMarkDescState extends State<CoachMarkDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: widget.onSkip, child: Text(widget.skip!)),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                  onPressed: widget.onNext, child: Text(widget.next!)),
            ],
          )
        ],
      ),
    );
  }
}
