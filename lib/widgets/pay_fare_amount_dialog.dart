import 'package:boride/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:uuid/uuid.dart';

class PayFareAmountDialog extends StatefulWidget {
  String? fareAmount;
  String? paymentMtd;

  PayFareAmountDialog({this.fareAmount, this.paymentMtd});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {


  bool isTestMode = true;



  @override
  Widget build(BuildContext context) {
    String fareAmount = widget.fareAmount!.toString();
    String paymentMtd = widget.paymentMtd!.toString();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 22.0,
            ),
            const Text(
              "Trip Fare",
              style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Divider(
              height: 2.0,
              thickness: 2.0,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "\$ $fareAmount",
              style: const TextStyle(fontSize: 45.0, fontFamily: "Brand-Bold"),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "This is the total trip amount, it has been charged to the rider.",
                style: TextStyle(fontFamily: "Brand-Regular"),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (paymentMtd == "Cash") {
                    Navigator.pop(context, "cashPayed");
                  }
                  else if(paymentMtd == "Card"){
                    _handlePaymentInitialization();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Pay Fare",
                        style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  _handlePaymentInitialization() async {


    final Customer customer = Customer(
        name: userModelCurrentInfo!.name!,
        phoneNumber: userModelCurrentInfo!.phone!,
        email: userModelCurrentInfo!.email!);

    final Flutterwave flutterWave = Flutterwave(
        context: context,
        publicKey: getPublicKey(),
        currency: "NGN",
        redirectUrl: 'https://facebook.com',
        txRef: "${const Uuid().v1()}-Txd",
        amount: widget.fareAmount.toString(),
        customer: customer,
        paymentOptions: "card, bank transfer",
        customization: Customization(title: "Test Payment"),
        isTestMode: isTestMode);
    final ChargeResponse response = await flutterWave.charge().whenComplete(() {
      Fluttertoast.showToast(msg: "Success///");
      Navigator.pop(context, "CardPaymentSuccessful");
    });

  }

  String getPublicKey() {
    if (isTestMode) return "FLWPUBK_TEST-1b50fcec6e04d0b2b0e471d74827197b-X";
    return "FLWPUBK-45587fdb1c84335354ab0fa388b803d5-X";
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
