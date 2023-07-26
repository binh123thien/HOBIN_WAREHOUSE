import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../../utils/utils.dart';

class CardItemBanHang extends StatelessWidget {
  // 0: đơn bán      ; 1: đơn nhập
  final int phanbietNhapXuat;
  const CardItemBanHang({
    super.key,
    required this.allHangHoa,
    required this.controllerSoluong,
    required this.phanbietNhapXuat,
  });

  final List<dynamic> allHangHoa;
  final List<TextEditingController> controllerSoluong;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          width: size.width,
          height: size.height - kToolbarHeight,
          child: ListView.builder(
            itemCount: allHangHoa.length,
            itemBuilder: (context, index) {
              var hanghoa = allHangHoa[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            // flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 15),
                              child: SizedBox(
                                height: 30,
                                child: hanghoa["photoGood"].isEmpty
                                    ? const Icon(
                                        Icons.inventory_2,
                                        size: 30,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          height: 50,
                                          width: 50,
                                          imageUrl:
                                              hanghoa["photoGood"].toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hanghoa["tensanpham"],
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w900),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5),
                                  //chia giá nhập xuất cho 2 trang
                                  Text(
                                    phanbietNhapXuat == 0
                                        ? formatCurrency(hanghoa["giaban"])
                                        : formatCurrency(hanghoa["gianhap"]),
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 2,
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Tồn kho: ${hanghoa["tonkho"]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: backGroundColor,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (hanghoa["soluong"] > 0) {
                                                setState(() {
                                                  hanghoa["soluong"]--;
                                                  controllerSoluong[index]
                                                          .text =
                                                      hanghoa["soluong"]
                                                          .toString();
                                                });
                                              }
                                            },
                                            child: const Icon(Icons.remove),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 35,
                                          height: 25,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller:
                                                controllerSoluong[index],
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(4),
                                              isDense: true,
                                              border: InputBorder.none,
                                            ),
                                            scrollPadding: EdgeInsets.zero,
                                            keyboardType: TextInputType.number,
                                            onFieldSubmitted: (value) {
                                              int? soluong =
                                                  int.tryParse(value);
                                              if (soluong != null) {
                                                setState(() {
                                                  if (phanbietNhapXuat == 0) {
                                                    hanghoa["soluong"] =
                                                        soluong.clamp(0,
                                                            hanghoa["tonkho"]);
                                                  } else if (phanbietNhapXuat ==
                                                      1) {
                                                    hanghoa["soluong"] =
                                                        soluong;
                                                  }
                                                  controllerSoluong[index]
                                                          .text =
                                                      hanghoa["soluong"]
                                                          .toString();
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: backGroundColor),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                //truong hop ban hang
                                                if (phanbietNhapXuat == 0 &&
                                                    hanghoa["soluong"] <
                                                        hanghoa["tonkho"]) {
                                                  hanghoa["soluong"]++;
                                                  //truong hop nhap hang, khong gioi han so luong
                                                } else if (phanbietNhapXuat !=
                                                    0) {
                                                  hanghoa["soluong"]++;
                                                } else {
                                                  Get.snackbar(
                                                      "Trong kho không đủ số lượng",
                                                      "Vui lòng nhập thêm hàng",
                                                      colorText: Colors.white);
                                                }
                                                controllerSoluong[index].text =
                                                    hanghoa["soluong"]
                                                        .toString();
                                              });
                                            },
                                            child: const Icon(Icons.add),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
              // display the item in the UI
            },
          )),
    ));
  }
}
