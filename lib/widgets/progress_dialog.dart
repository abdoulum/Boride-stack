import 'package:flutter/material.dart';


class ProgressDialog extends StatelessWidget
{
  String? message;
  ProgressDialog({Key? key, this.message, required String status}) : super(key: key);


  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [

              const SizedBox(width: 6.0,),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),

              const SizedBox(width: 20.0,),

              Text(
                message!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
