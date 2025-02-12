import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isCircle;
  final Color? textColor;
  final double textSize;
  final FontWeight fontWeight;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isCircle = false,
    this.textColor,
    required this.textSize,
    this.fontWeight = FontWeight.w400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isCircle
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(7),
                  backgroundColor: const Color.fromARGB(255, 237, 112, 3)),
              onPressed: onPressed,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: fontWeight, // Use provided or default fontWeight
                  color: textColor ?? Colors.white,
                ),
              ),
            )
          : GestureDetector(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.transparent,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: textSize, // Use the required textSize
                    fontWeight:
                        fontWeight, // Use provided or default fontWeight
                    color: textColor ??
                        Colors.white, // Use custom or default color
                  ),
                ),
              ),
            ),
    );
  }
}
