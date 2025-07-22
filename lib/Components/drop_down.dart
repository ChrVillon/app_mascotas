import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String hintText;
  final void Function(T?) onChanged;
  final bool search;

  const SearchableDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.hintText,
    required this.onChanged,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownSearch<T>(
        items: items,
        selectedItem: selectedItem,
        onChanged: onChanged,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          showSearchBox: search,
          constraints: BoxConstraints(
            maxHeight: _calculateHeight(items.length),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Buscar...',
            ),
          ),
        ),
      ),
    );
  }

  double _calculateHeight(int itemCount) {
    const double itemHeight = 60.0;
    double calculatedHeight = itemCount * itemHeight;

    return calculatedHeight;
  }
}
