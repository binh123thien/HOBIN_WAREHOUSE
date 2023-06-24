import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class PaymentRadio extends StatefulWidget {
  final int paymentSelected;
  const PaymentRadio({super.key, required this.paymentSelected});

  @override
  State<PaymentRadio> createState() => _PaymentRadioState();
}

class _PaymentRadioState extends State<PaymentRadio> {
  late int selectedRadio;
  @override
  void initState() {
    super.initState();
    selectedRadio = widget.paymentSelected;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      print(selectedRadio);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.28,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hình thức thanh toán",
                    style: Theme.of(context).textTheme.bodyLarge),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                setSelectedRadio(0);
                Navigator.of(context).pop(selectedRadio);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tiền mặt',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Radio(
                    value: 0,
                    groupValue: selectedRadio,
                    activeColor: mainColor,
                    onChanged: (val) {
                      setSelectedRadio(val!);
                    },
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setSelectedRadio(1);
                Navigator.of(context).pop(selectedRadio);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chuyển khoản',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: mainColor,
                    onChanged: (val) {
                      setSelectedRadio(val!);
                    },
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setSelectedRadio(2);
                Navigator.of(context).pop(selectedRadio);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ví điện tử',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: mainColor,
                    onChanged: (val) {
                      setSelectedRadio(val!);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
