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
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      widget.onSearchingChanged?.call(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchingChanged?.call(value.isNotEmpty || _focusNode.hasFocus);
      widget.onTextChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final containerColor = Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(128);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(128),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: true,
                fillColor: containerColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {});
                _onSearchChanged(value);
              },
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurfaceVariant),
              onPressed: () {
                _controller.clear();
                widget.onSearchingChanged?.call(false);
                widget.onTextChanged?.call('');
              },
            ),
        ],
      ),
    );
  }

  String get searchText => _controller.text;
}
