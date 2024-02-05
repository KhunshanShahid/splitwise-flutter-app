import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController fieldController;
  final String label;
  final bool check;
  final TextInputType keyboardType;

  const CustomFormField({super.key, 
    required this.fieldController,
    required this.label,
    this.check = false,
     this.keyboardType = TextInputType.text,
  });

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    obscureText = widget.check;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.fieldController,
      keyboardType: widget.keyboardType,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        suffixIcon: widget.check
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).dividerColor,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
