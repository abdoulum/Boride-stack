import 'package:boride/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTP extends StatefulWidget {
  const OTP({Key? key, required this.phone}) : super(key: key);
  final String phone;

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  Color focusedBorderColor = const Color.fromRGBO(23, 171, 144, 1);
  Color borderColor = const Color.fromRGBO(196, 226, 247, 0.4);

  final defaultPinTheme = PinTheme(
    width: 45,
    height: 55,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: Colors.red),
    ),
  );

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pinController;
    return Scaffold(
      body: ListView(
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 150.0, horizontal: 30),
              child: Column(
                children: [
                  const Text("Verify phone",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: "Brand-Bold",
                      )),
                  const SizedBox(height: 20),
                  Center(
                      child: Text(
                    "+234 " + widget.phone,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: "Brand-Bold",
                    ),
                  )),
                  const SizedBox(height: 50),
                  Pinput(
                    controller: pinController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    validator: (value) {
                      return value == '2222' ? null : 'Pin is incorrect';
                    },
                    // onClipboardFound: (value) {
                    //   debugPrint('onClipboardFound: $value');
                    //   pinController.setText(value);
                    // },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: BrandColors.colorAccent2,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
