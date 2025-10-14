import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onTap;
  const AuthGradientButton({super.key, required this.buttonName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [
          AppPallete.gradient1,
          AppPallete.gradient2
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        )
      ),
      child: ElevatedButton(
          onPressed: onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(370, 55),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor
        ),
          child: Text(buttonName, style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
