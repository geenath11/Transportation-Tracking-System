import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/features/search/presentation/widgets/date_chip.dart';


class DateSelector extends StatefulWidget {

  final ValueChanged<DateTime>? onDateSelected;

  final int daysAhead;

  const DateSelector({
    super.key,
    this.onDateSelected,
    this.daysAhead = 5,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late final List<DateTime> _dates;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dates = List.generate(
      widget.daysAhead,
          (index) => DateTime(today.year, today.month, today.day + index),
    );
  }

  String _labelFor(DateTime date, int index) {
    if (index == 0) return 'Today ${date.day}';
    if (index == 1) return 'Tomorrow ${date.day}';
    return '${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;
              return DateChip(
                label: _labelFor(_dates[index], index),
                selected: isSelected,
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onDateSelected?.call(_dates[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}