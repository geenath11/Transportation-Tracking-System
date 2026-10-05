import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class DestinationField extends StatefulWidget {
  final String? label;
  final String hintText;
  final String value;
  final List<String> destinations;
  final String? excludedDestination;
  final ValueChanged<String> onSelected;

  const DestinationField({
    super.key,
    this.label,
    required this.hintText,
    required this.value,
    required this.destinations,
    this.excludedDestination,
    required this.onSelected,
  });

  @override
  State<DestinationField> createState() => _DestinationFieldState();
}

class _DestinationFieldState extends State<DestinationField> {
  static const int _maxResults = 8;

  static const String _noResults = '__no_results__';

  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant DestinationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) return;

    final text = _controller.text.trim().toLowerCase();
    String? match;
    for (final d in widget.destinations) {
      if (d.toLowerCase() == text && d != widget.excludedDestination) {
        match = d;
        break;
      }
    }

    if (match == null) {
      _controller.text = widget.value;
    } else if (match != widget.value) {
      _controller.text = match;
      widget.onSelected(match);
    }
  }

  Iterable<String> _optionsFor(TextEditingValue input) {
    final query = input.text.trim().toLowerCase();
    final pool = widget.destinations.where(
      (d) => d != widget.excludedDestination,
    );

    if (query.isEmpty) return pool.take(_maxResults);

    final startsWith = <String>[];
    final contains = <String>[];

    for (final d in pool) {
      final lower = d.toLowerCase();
      if (lower.startsWith(query)) {
        startsWith.add(d);
      } else if (lower.contains(query)) {
        contains.add(d);
      }
    }

    final results = [...startsWith, ...contains].take(_maxResults).toList();

    return results.isEmpty ? [_noResults] : results;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth;

        return RawAutocomplete<String>(
          textEditingController: _controller,
          focusNode: _focusNode,
          optionsBuilder: _optionsFor,
          displayStringForOption: (option) =>
              option == _noResults ? _controller.text : option,
          onSelected: (value) {
            if (value == _noResults) return;
            widget.onSelected(value);
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmit) =>
              _buildField(controller, focusNode, onSubmit),
          optionsViewBuilder: (context, onSelected, options) =>
              _buildPopup(onSelected, options.toList(), fieldWidth),
        );
      },
    );
  }

  Widget _buildField(
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onSubmit,
  ) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, _) {
        final isFocused = focusNode.hasFocus;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          height: 58,
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isFocused ? AppColors.primary : const Color(0xFFE1E3EA),
              width: isFocused ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: isFocused ? AppColors.primary : const Color(0xFF6F7380),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  cursorColor: AppColors.primary,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  enableSuggestions: false,
                  onSubmitted: (_) => onSubmit(),
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15,
                    color: const Color(0xFF17181C),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.regular.copyWith(
                      fontSize: 15,
                      color: const Color(0xFF6B7080),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  if (!isFocused || value.text.isEmpty) {
                    return const SizedBox(width: 16);
                  }
                  return IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: const Color(0xFF6F7380),
                    onPressed: controller.clear,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopup(
    AutocompleteOnSelected<String> onSelected,
    List<String> options,
    double width,
  ) {
    final isEmpty = options.length == 1 && options.first == _noResults;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Material(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.10),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E4EA)),
          ),
          child: SizedBox(
            width: width,
            child: isEmpty
                ? _buildEmptyMessage()
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: options.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        indent: 48,
                        endIndent: 16,
                        color: Color(0xFFEDEEF2),
                      ),
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: Color(0xFF6F7380),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    option,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.semiBold.copyWith(
                                      fontSize: 14,
                                      color: const Color(0xFF17181C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 20,
            color: Color(0xFF6F7380),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No destinations found',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF17181C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Check the spelling or try another place.',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF5B5F6B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
