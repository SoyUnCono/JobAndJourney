import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Container searchField(
  BuildContext context,
  TextEditingController controllerName,
  String placeholderText,
  String? iconLeading,
  TextInputType textInputType,
  bool acceptOnlyNumbers,
) {
  List<TextInputFormatter> inputFormatters = [];

  if (acceptOnlyNumbers) {
    inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')));
  }

  return Container(
    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
    child: TextField(
      controller: controllerName,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true,
        contentPadding: const EdgeInsets.all(15),
        hintText: placeholderText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        suffixIcon: SizedBox(
          width: 150,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                VerticalDivider(
                  color: Theme.of(context).colorScheme.secondary,
                  indent: 10,
                  endIndent: 10,
                  thickness: 0.1,
                ),
                SizedBox(
                  width: 55,
                  child: Padding(
                    padding: const EdgeInsets.all(16.25),
                    child: Image.asset(
                      iconLeading ?? '',
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
