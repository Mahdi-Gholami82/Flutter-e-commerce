import 'package:digi_meh/features/product_view/presentation/product_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({super.key});

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  final TextEditingController controller = TextEditingController();

  void resetTextIfNeccessary() {
    var trimmed = controller.text.trim();
    if (trimmed.isEmpty || (int.tryParse(trimmed) ?? 0) < 1) {
      controller.text = "1";
    }
  }

  @override
  void initState() {
    super.initState();
    resetTextIfNeccessary();
    controller.addListener(resetTextIfNeccessary);
  }

  @override
  void dispose() {
    controller.removeListener(resetTextIfNeccessary);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resetTextIfNeccessary();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.9,
            child: IconButton(
              onPressed: () {
                int? number = int.tryParse(controller.text);
                controller.text = ((number ?? 0) - 1)
                    .clamp(0, double.infinity)
                    .toString();
              },
              icon: Icon(Icons.remove),
            ),
          ),
          SizedBox(
            width: 50,
            height: 20,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 15),
              enableSuggestions: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.all(9),
              ),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: IconButton(
              onPressed: () {
                int? number = int.tryParse(controller.text);
                controller.text = ((number ?? 0) + 1)
                    .clamp(0, double.infinity)
                    .toString();
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
