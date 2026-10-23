import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({
    super.key,
    required this.enable,
    required this.initialCount,
    required this.onChanged,
    this.textColor,
  });
  final bool enable;
  final int initialCount;
  final void Function(int number) onChanged;
  final Color? textColor;

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  final TextEditingController controller = TextEditingController();
  late int _count;
  set count(int value) {
    _count = value;
    controller.value = controller.value.copyWith(text: value.toString());
  }

  int get count => _count;

  void resetTextIfNeccessary() {
    var trimmed = controller.text.trim();
    if (trimmed.isEmpty || (int.tryParse(trimmed) ?? 0) < 1) {
      count = 1;
    } else {
      _count = int.parse(controller.text);
    }
  }

  void onChanged() {
    widget.onChanged(int.parse(controller.text));
  }

  @override
  void initState() {
    super.initState();
    count = widget.initialCount >= 1 ? widget.initialCount : 1;
    controller.addListener(resetTextIfNeccessary);
    controller.addListener(onChanged);
  }

  @override
  void dispose() {
    controller.removeListener(resetTextIfNeccessary);
    controller.removeListener(onChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resetTextIfNeccessary();
  }

  @override
  void didUpdateWidget(covariant ItemCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    count = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 0.9,
          child: IconButton(
            onPressed: widget.enable
                ? () {
                    count = (count - 1).clamp(0, double.infinity).toInt();
                  }
                : null,
            icon: Icon(Icons.remove),
          ),
        ),
        SizedBox(
          width: 50,
          height: 20,
          child: TextField(
            enabled: widget.enable,
            controller: controller,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 17, color: widget.textColor),
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
            onPressed: widget.enable
                ? () {
                    count = (count + 1).clamp(0, double.infinity).toInt();
                  }
                : null,
            icon: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
