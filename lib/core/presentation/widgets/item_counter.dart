import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({
    super.key,
    required this.enable,
    required this.initialCount,
    required this.onChanged,
    this.textColor,
    this.onDelete,
  });
  final bool enable;
  final int initialCount;
  final void Function(int number) onChanged;
  final Color? textColor;
  final void Function()? onDelete;

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  final TextEditingController controller = TextEditingController();
  set count(int value) {
    final valueText = value.toString();
    controller.value = controller.value.copyWith(
      text: valueText,
      selection: TextSelection.collapsed(offset: valueText.length),
    );
  }

  int get count => int.parse(controller.text);

  void resetTextIfNeccessary() {
    var trimmed = controller.text.trim();
    if (trimmed.isEmpty || (int.tryParse(trimmed) ?? 0) < 1) {
      count = 1;
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
    if (oldWidget.initialCount != widget.initialCount) {
      count = widget.initialCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    var enableDelete = count == 1 && widget.onDelete != null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: widget.enable
              ? () {
                  if (enableDelete) {
                    widget.onDelete!();
                  } else {
                    count = (count - 1).clamp(0, double.infinity).toInt();
                  }
                }
              : null,
          icon: Icon(enableDelete ? Icons.delete : Icons.remove),
        ),
        SizedBox(
          width: 50,
          height: 30,
          child: TextField(
            enabled: widget.enable,
            controller: controller,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            enableSuggestions: false,
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        IconButton(
          onPressed: widget.enable
              ? () {
                  count = (count + 1).clamp(0, double.infinity).toInt();
                }
              : null,
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
