// import 'package:flutter/material.dart';

// class CalculatorButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onPressed;
//   final bool isCircle;
//   final Color? textColor; // Optional property for text color
//   final double textSize; // Required property for text size
//   final FontWeight fontWeight; // Optional property for font weight

//   const CalculatorButton({
//     Key? key,
//     required this.label,
//     required this.onPressed,
//     this.isCircle = false,
//     this.textColor,
//     required this.textSize,
//     this.fontWeight = FontWeight.w400, // Default value
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: isCircle
//           ? ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: const CircleBorder(side: BorderSide(width: 130)),
//                   padding: const EdgeInsets.all(3),
//                   backgroundColor: Colors.orangeAccent),
//               onPressed: onPressed,
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: textSize,
//                   fontWeight: fontWeight, // Use provided or default fontWeight
//                   color: textColor ?? Colors.white,
//                 ),
//               ),
//             )
//           : InkWell(
//               onTap: onPressed,
//               borderRadius: BorderRadius.circular(75),
//               splashColor: Colors.white30,
//               radius: 75,
//               child: Center(
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: textSize, // Use the required textSize
//                     fontWeight:
//                         fontWeight, // Use provided or default fontWeight
//                     color: textColor ??
//                         Colors.white, // Use custom or default color
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isCircle;
  final Color? textColor; // Optional property for text color
  final double textSize; // Required property for text size
  final FontWeight fontWeight; // Optional property for font weight

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isCircle = false,
    this.textColor,
    required this.textSize,
    this.fontWeight = FontWeight.w400, // Default value
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
                  borderRadius: BorderRadius.circular(75),
                  color: Colors.transparent,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
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
