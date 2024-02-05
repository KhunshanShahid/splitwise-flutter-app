import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Future<void> Function()? fn;
  final String label;

  const CustomButton({
    Key? key,
    required this.fn,
    required this.label,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.fn,
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isHovered
                ? Color.fromARGB(255, 0, 0, 0) 
                : Color.fromARGB(255, 75, 74, 207),
                border: Border.all(
      color: Theme.of(context).hintColor,
      width: 1.0,
    ),
               
          ),
          
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style:const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  void _handleHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }
}
