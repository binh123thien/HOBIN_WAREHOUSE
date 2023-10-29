// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/common_widgets/form/button_bar_widget.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/chondanhmuc_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/themhanghoa_model.dart';
import 'package:hobin_warehouse/src/utils/image_picker/image_picker.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../repository/goods_repository/good_repository.dart';
import '../../../../../utils/utils.dart';
import '../../../controllers/goods/chondonvi_controller.dart';
import '../../../../../common_widgets/bottom_sheet_options.dart';
import 'themhanghoa/danhmuc.dart';
import 'themhanghoa/donvi.dart';
import 'themhanghoa/phanloai_hang_hoa.dart';

class ThemGoodsScreen extends StatefulWidget {
  const ThemGoodsScreen({super.key});

  @override
  State<ThemGoodsScreen> createState() => _ThemGoodsScreenState();
}

class _ThemGoodsScreenState extends State<ThemGoodsScreen>
    with InputValidationMixin {
  //2 nút: lưu và thoát; thêm hàng hóa
  final controller = Get.put(ThemHangHoaController());
  final myController = Get.put(ChonDonViController());
  final controllerDanhMuc = Get.put(ChonDanhMucController());
  final firebaseUser = FirebaseAuth.instance.currentUser;
  Uint8List? currentImage;
  Uint8List? preImage;

  @override
  void initState() {
    controller.donviController = TextEditingController();
    controller.maCodeController = TextEditingController();
    controller.tenSanPhamController = TextEditingController();
    controller.gianhapController = TextEditingController();
    controller.giabanController = TextEditingController();

    //clear List được lưu trữ trong controller
    controllerDanhMuc.selectedDanhMuc.clear();
    super.initState();
  }

  selectImage(sourceImage) async {
    Uint8List? img = await StoreData().pickImage(sourceImage);
    if (img != null) {
      preImage = img;
      currentImage = img;
    } else {
      currentImage = preImage;
    }
    setState(() {
      currentImage;
    });
    Navigator.of(context).pop();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    genarateCode() {
      String generatedCode = generateRandomCode(13); // độ dài là 13
      controller.maCodeController.text =
          generatedCode; // Gán mã code mới vào _maCodeController
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: IconButton(
            icon: Image(
              image: const AssetImage(backIcon),
              height: size.height * 0.02345,
              color: whiteColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          "Thêm hàng hóa",
          style: TextStyle(
              fontSize: Font.sizes(context)[2], fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.255, //100
                  height: size.height * 0.117, // 100
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    elevation: 1,
                    child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return BottomSheetOptions(
                                textOneofTwo: 'avatar',
                                onTapCamera: () =>
                                    selectImage(ImageSource.camera),
                                onTapGallery: () =>
                                    selectImage(ImageSource.gallery),
                              );
                            },
                          );
                        },
                        icon: currentImage != null
                            ? Image.memory(
                                currentImage!,
                                width: size.width * 0.255, //100
                                height: size.height * 0.117, // 100
                                fit: BoxFit.cover,
                              )
                            : Image.asset(cameraIcon)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: TextFormField(
                        validator: (value) {
                          return oneCharacter(value!);
                        },
                        controller: controller.maCodeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        decoration: InputDecoration(
                            errorStyle:
                                TextStyle(fontSize: Font.sizes(context)[1]),
                            border: const UnderlineInputBorder(),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainColor, width: 2)),
                            contentPadding: EdgeInsets.zero,
                            labelText: "Mã code",
                            labelStyle:
                                TextStyle(fontSize: Font.sizes(context)[1]),
                            suffixIcon: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    genarateCode();
                                  },
                                  icon: const Icon(
                                    Icons.autorenew_outlined,
                                  ),
                                  iconSize: Font.sizes(context)[4],
                                ),
                                IconButton(
                                  onPressed: () async {
                                    String code =
                                        await FlutterBarcodeScanner.scanBarcode(
                                      "#ff6666", // Màu hiển thị của app
                                      "Hủy bỏ", // Chữ hiển thị cho nút hủy bỏ
                                      true, // Cho phép Async? (có hay không)
                                      ScanMode.BARCODE, // Hình thức quét
                                    );
                                    if (!mounted) return;
                                    if (code == "-1") {
                                      controller.maCodeController.text = '';
                                    } else {
                                      controller.maCodeController.text = code;
                                    }
                                  },
                                  icon: const ImageIcon(AssetImage(qRIcon)),
                                  iconSize: Font.sizes(context)[4],
                                ),
                              ],
                            )),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //ten san pham
                    Text("Tên sản phẩm:",
                        style: TextStyle(fontSize: Font.sizes(context)[2])),
                    TextFormField(
                      validator: (value) {
                        return oneCharacter(value!);
                      },
                      controller: controller.tenSanPhamController,
                      decoration: InputDecoration(
                          errorStyle:
                              TextStyle(fontSize: Font.sizes(context)[1]),
                          border: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Tên sản phẩm'),
                    ),
                    const SizedBox(height: 10),

                    //giá nhập
                    Text("Giá nhập:",
                        style: TextStyle(fontSize: Font.sizes(context)[2])),
                    TextFormField(
                      validator: (value) {
                        return oneCharacter(value!);
                      },
                      controller: controller.gianhapController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      onChanged: (value) {
                        final newValue = formatNumber(value);
                        if (newValue != value) {
                          controller.gianhapController.value = TextEditingValue(
                            text: newValue,
                            selection: TextSelection.fromPosition(
                                TextPosition(offset: newValue.length)),
                          );
                        }
                      },
                      decoration: InputDecoration(
                          errorStyle:
                              TextStyle(fontSize: Font.sizes(context)[1]),
                          border: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Giá nhập'),
                    ),
                    const SizedBox(height: 10),

                    //Giá bán
                    Text("Giá bán:",
                        style: TextStyle(fontSize: Font.sizes(context)[2])),
                    TextFormField(
                      validator: (value) {
                        return oneCharacter(value!);
                      },
                      controller: controller.giabanController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      onChanged: (value) {
                        final newValue = formatNumber(value);
                        if (newValue != value) {
                          controller.giabanController.value = TextEditingValue(
                            text: newValue,
                            selection: TextSelection.fromPosition(
                                TextPosition(offset: newValue.length)),
                          );
                        }
                      },
                      decoration: InputDecoration(
                          errorStyle:
                              TextStyle(fontSize: Font.sizes(context)[1]),
                          border: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Giá bán'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phân loại",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[2])),
                          const RadioButton(phanloaiFb: "bán lẻ"),
                        ]),
                    const SizedBox(height: 10),
                    Text("Đơn vị",
                        style: TextStyle(fontSize: Font.sizes(context)[2])),
                    const DonVi(),
                    const SizedBox(height: 10),
                    Text("Danh mục",
                        style: TextStyle(fontSize: Font.sizes(context)[2])),
                    const DanhMucHang(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Button2nutBar(
        title1: 'Thêm hàng hóa',
        title2: 'Lưu & thoát',
        onPressed1: () {
          if (formKey.currentState!.validate()) {
            createHangHoa().then((_) async {
              if (currentImage != null) {
                await StoreData().saveImageGood(
                    file: currentImage!,
                    user: firebaseUser!.uid,
                    macodeGood: controller.maCodeController.text.trim());
              }
            }).then((_) {
              setState(() {
                currentImage = null;
                controller.maCodeController.clear();
                controller.tenSanPhamController.clear();
                controller.gianhapController.clear();
                controller.giabanController.clear();
                controller.donviController.clear();
                // Clear List được lưu trữ trong controller
                controllerDanhMuc.selectedDanhMuc.clear();
              });
            });
          }
        },
        onPressed2: () {
          if (formKey.currentState!.validate()) {
            createHangHoa().then((_) async {
              if (currentImage != null) {
                await StoreData().saveImageGood(
                    file: currentImage!,
                    user: firebaseUser!.uid,
                    macodeGood: controller.maCodeController.text.trim());
              }
            });

            //clear List được lưu trữ trong controller
            controllerDanhMuc.selectedDanhMuc.clear();
            //Chờ 1s để cập nhật dữ liệu trên db
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop();
            });
          }
        },
      ),
    );
  }

//tạo hàng hóa theo ma code
  Future<void> createHangHoa() async {
    //đổi Rx thành List = .toList()
    List<String> listDanhMuc = controllerDanhMuc.selectedDanhMuc.toList();
    var hanghoa = HangHoaModel(
      chuyendoi: 0,
      daban: 0,
      soluong: 0,
      tonkho: 0,
      macode: controller.maCodeController.text.trim(),
      tensanpham: controller.tenSanPhamController.text.trim(),
      gianhap: double.tryParse(
              controller.gianhapController.text.replaceAll(",", "")) ??
          0,
      giaban: double.tryParse(
              controller.giabanController.text.replaceAll(",", "")) ??
          0,
      phanloai: controller.phanloaiController.text,
      donvi: controller.donviController.text,
      danhmuc: listDanhMuc,
      photoGood: '',
    );
    final goodsRepo = Get.put(GoodRepository());
    goodsRepo.createCollectionFirestore(
        hanghoa,
        controller.maCodeController.text.trim(),
        controller.tenSanPhamController.text.trim());
  }
}
