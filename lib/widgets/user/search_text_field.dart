import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class SearchTextField extends ConsumerStatefulWidget {
  final String hintText;
  final bool autofocus;
  final ValueChanged<bool>? onSearchingChanged;
  final ValueChanged<String>? onTextChanged;

  const SearchTextField({
    super.key,
    this.hintText = '검색',
    this.autofocus = false,
    this.onSearchingChanged,
    this.onTextChanged,
  });

  @override
  SearchTextFieldState createState() => SearchTextFieldState();
}

class SearchTextFieldState extends ConsumerState<SearchTextField> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchingChanged?.call(value.isNotEmpty);
      widget.onTextChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                  widget.onSearchingChanged?.call(false);
                  widget.onTextChanged?.call('');
                },
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {});
        _onSearchChanged(value);
      },
    );
  }

  String get searchText => _controller.text;
}
