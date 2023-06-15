import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final Function onChanged;
  final Function onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final IconData prefixIcon;
  final bool divider;

  CustomTextField(
      {this.hintText = 'Write something...',
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSubmit,
      this.onChanged,
      this.prefixIcon,
      this.capitalization = TextCapitalization.none,
      this.isPassword = false,
      this.divider = false});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: const TextStyle(
            fontFamily: 'Barlow',
            fontWeight: FontWeight.w400,
          ),
          textInputAction: widget.inputAction,
          keyboardType: widget.inputType,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          autofocus: false,
          obscureText: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Z a-z]')),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(style: BorderStyle.none, width: 0),
            ),
            isDense: true,
            hintText: widget.hintText,
            fillColor: Theme.of(context).cardColor,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            filled: true,
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(widget.prefixIcon),
                  )
                : null,
          ),
          onSubmitted: (text) => widget.nextFocus != null
              ? FocusScope.of(context).requestFocus(widget.nextFocus)
              : widget.onSubmit != null
                  ? widget.onSubmit(text)
                  : null,
          onChanged: widget.onChanged(),
        ),
        widget.divider
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider())
            : const SizedBox(),
      ],
    );
  }
}
