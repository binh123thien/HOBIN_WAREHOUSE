import 'package:flutter/material.dart';
import '../../../../../../constants/color.dart';

class GiamGiaWidget extends StatefulWidget {
  final String keyWord;
  final FocusNode focusNode;
  const GiamGiaWidget(
      {super.key, required this.focusNode, required this.keyWord});

  @override
  State<GiamGiaWidget> createState() => _GiamGiaWidgetState();
}

class _GiamGiaWidgetState extends State<GiamGiaWidget> {
  final TextEditingController _controllerGiamGia = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                widget.keyWord == "giamgia"
                    ? const Text("Giảm giá")
                    : const Text("Nợ"),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40,
                      width: (MediaQuery.of(context).size.width - 30) * 7 / 10,
                      child: TextFormField(
                        focusNode: widget.focusNode,
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: _controllerGiamGia,
                        keyboardType: TextInputType.number,
                        // maxLength: 10,
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: blueColor, width: 2),
                            borderRadius: BorderRadius.zero,
                          ),
                          hintText: 'Nhập số tiền',
                        ),
                      ),
                    ),
                    SizedBox(
                      width:
                          (MediaQuery.of(context).size.width - 30) * 2.9 / 10,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: blueColor,
                          side: BorderSide(
                              color: _controllerGiamGia.text.isNotEmpty
                                  ? blueColor
                                  : Colors.grey[500]!),
                        ),
                        onPressed: _controllerGiamGia.text.isNotEmpty
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context)
                                      .pop(_controllerGiamGia.text);
                                }
                              }
                            : null,
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
