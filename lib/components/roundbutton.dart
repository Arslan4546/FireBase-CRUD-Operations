
import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({super.key, required this.text, required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: loading ? const Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white)) : Center(child: Text(text, style: const TextStyle(fontSize: 17.0, color: Colors.white),)),
      ),
    );
  }
}


