import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final bool loading;
  final VoidCallback onPress;
  final Color? buttonColor;
  final Color? textColor;
  final double? borderRadius;

  const RoundButton({
    Key? key,
    this.width,
    this.height,
    required this.title,
    required this.loading,
    required this.onPress,
    this.buttonColor,
    this.textColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
        ),
        onPressed: loading ? null : onPress,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
