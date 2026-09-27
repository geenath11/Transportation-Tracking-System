import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class DestinationButton extends StatelessWidget {
  final String label;
  final String value;
  final List<String> destinations;
  final ValueChanged<String> onSelected;

  const DestinationButton({
    super.key,
    required this.label,
    required this.value,
    required this.destinations,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(
        text: value,
      ),

      // ------------------------------------------------------------
      // SEARCH / FILTER
      // ------------------------------------------------------------
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();

        if (query.isEmpty) {
          return destinations.take(8);
        }

        final results = <String>[];

        for (final destination in destinations) {
          if (destination.toLowerCase().contains(query)) {
            results.add(destination);

            // Keep the popup small.
            if (results.length == 8) {
              break;
            }
          }
        }

        return results;
      },

      onSelected: onSelected,

      // ------------------------------------------------------------
      // TEXT FIELD
      // ------------------------------------------------------------
      fieldViewBuilder: (
          BuildContext context,
          TextEditingController controller,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
          ) {
        return AnimatedBuilder(
          animation: focusNode,
          builder: (context, _) {
            final isFocused = focusNode.hasFocus;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isFocused
                      ? AppColors.primary
                      : const Color(0xFFE1E3EA),
                  width: isFocused ? 1.4 : 1.0,
                ),
                boxShadow: isFocused
                    ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.10,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : null,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),

                  // FROM / TO label
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Input
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      cursorColor: AppColors.primary,
                      textInputAction: TextInputAction.done,

                      onSubmitted: (_) {
                        onFieldSubmitted();
                      },

                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 15,
                        color: const Color(0xFF17181C),
                      ),

                      decoration: InputDecoration(
                        hintText: 'Enter destination',
                        hintStyle: AppTextStyles.regular.copyWith(
                          fontSize: 15,
                          color: const Color(0xFF858995),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),
                ],
              ),
            );
          },
        );
      },

      // ------------------------------------------------------------
      // AUTOCOMPLETE POPUP
      // ------------------------------------------------------------
      optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<String> onSelected,
          Iterable<String> options,
          ) {
        final optionList = options.toList(growable: false);

        return Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(
              maxHeight: 240,
              maxWidth: 420,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2E4EA),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.10,
                  ),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,

            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              itemCount: optionList.length,
              itemBuilder: (context, index) {
                final option = optionList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        child: Row(
                          children: [
                            // Location icon
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                size: 17,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Destination
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

                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: Color(0xFF9A9DA7),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (index < optionList.length - 1)
                      const Divider(
                        height: 1,
                        indent: 56,
                        endIndent: 14,
                        color: Color(0xFFEDEEF2),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}