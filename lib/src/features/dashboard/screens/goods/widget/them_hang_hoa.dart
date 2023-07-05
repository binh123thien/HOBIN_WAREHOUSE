import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/form/button_bar_widget.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/chondanhmuc_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/themhanghoa_model.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../repository/goods_repository/good_repository.dart';
import '../../../../../utils/image_picker/image_picker.dart';
import '../../../../../utils/utils.dart';
import '../../../controllers/goods/chondonvi_controller.dart';
import '../../../../../common_widgets/bottom_sheet_options.dart';
import '../../../controllers/image_controller.dart';
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
  final controllerImage = Get.put(ImageController());

  @override
  void initState() {
    controller.donviController = TextEditingController();
    controller.maCodeController = TextEditingController();
    controller.tenSanPhamController = TextEditingController();
    controller.gianhapController = TextEditingController();
    controller.giabanController = TextEditingController();

    //clear List được lưu trữ trong controller
    controllerDanhMuc.selectedDanhMuc.clear();
    //xóa hình user chưa lưu khi back về bằng nút quay lại trên dth
    controllerImage.deleteAllImageList('hanghoa');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    genarateCode() {
      String generatedCode =
          generateRandomCode(13); // Tạo mã code với độ dài là 13
      controller.maCodeController.text =
          generatedCode; // Gán mã code mới vào _maCodeController
    }

    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(tBackGround1),
              fit: BoxFit.cover,
            ),
          ),
        ),
        leading: IconButton(
            icon: const Image(
              image: AssetImage(backIcon),
              height: 20,
              color: whiteColor,
            ),
            onPressed: () {
              //xóa những tấm khác chưa lưu
              controllerImage.deleteAllImageList('hanghoa');
              Navigator.of(context).pop();
            }),
        title: const Text(
          "Thêm hàng hóa",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
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
                                onTapCamera: () async {
                                  await uploadImageToFirebase(
                                      ImageSource.camera, 'hanghoa');
                                  //setState updateUserData
                                  showHinhAnh();
                                },
                                onTapGallery: () async {
                                  await uploadImageToFirebase(
                                      ImageSource.gallery, 'hanghoa');
                                  showHinhAnh();
                                },
                              );
                            },
                          );
                        },
                        icon: controllerImage
                                .ImagePickedURLController.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  controllerImage.ImagePickedURLController.last,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.fill,
                                ),
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
                            errorStyle: const TextStyle(fontSize: 15),
                            border: const UnderlineInputBorder(),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainColor, width: 2)),
                            contentPadding: EdgeInsets.zero,
                            labelText: "Mã code",
                            labelStyle: const TextStyle(fontSize: 18),
                            suffixIcon: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    genarateCode();
                                  },
                                  icon: const Icon(
                                    Icons.autorenew_outlined,
                                  ),
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
                                  iconSize: 30,
                                ),
                              ],
                            )),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //ten san pham
                    const Text("Tên sản phẩm:", style: TextStyle(fontSize: 18)),
                    TextFormField(
                      validator: (value) {
                        return oneCharacter(value!);
                      },
                      controller: controller.tenSanPhamController,
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Tên sản phẩm'),
                    ),
                    const SizedBox(height: 10),

                    //giá nhập
                    const Text("Giá nhập:", style: TextStyle(fontSize: 18)),
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
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Giá nhập'),
                    ),
                    const SizedBox(height: 10),

                    //Giá bán
                    const Text("Giá bán:", style: TextStyle(fontSize: 18)),
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
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Giá bán'),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phân loại", style: TextStyle(fontSize: 18)),
                          RadioButton(phanloaiFb: "bán lẻ"),
                        ]),
                    const SizedBox(height: 10),
                    const Text("Đơn vị", style: TextStyle(fontSize: 18)),
                    const DonVi(),
                    const SizedBox(height: 10),
                    const Text("Danh mục", style: TextStyle(fontSize: 18)),
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
          if (_formKey.currentState!.validate()) {
            createHangHoa();
            controller.maCodeController.clear();
            controller.tenSanPhamController.clear();
            controller.gianhapController.clear();
            controller.giabanController.clear();
            controller.donviController.clear();
            //================xóa hình ảnh=====================
            controllerImage.deleteExceptLastImage('hanghoa');
            setState(() {
              controllerImage.ImagePickedURLController;
            });
            //===================end xóa hình ============

            //clear List được lưu trữ trong controller
            controllerDanhMuc.selectedDanhMuc.clear();
          }
        },
        onPressed2: () {
          if (_formKey.currentState!.validate()) {
            createHangHoa();

            //================xóa hình ảnh=====================
            controllerImage.deleteExceptLastImage('hanghoa');
            setState(() {
              controllerImage.ImagePickedURLController;
            });
            //===================end xóa hình ============

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
  createHangHoa() {
    var hanghoa = HangHoaModel(
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
        danhmuc: controllerDanhMuc.selectedDanhMuc,
        photoGood: controllerImage.ImagePickedURLController.isNotEmpty
            ? controllerImage.ImagePickedURLController.last
            : "");
    final goodsRepo = Get.put(GoodRepository());
    goodsRepo.createCollectionFirestore(
        hanghoa,
        controller.maCodeController.text.trim(),
        controller.tenSanPhamController.text.trim());
  }

  //Show hình ảnh đã chọn
  showHinhAnh() {
    setState(() {
      controllerImage.ImagePickedURLController;
    });
    Navigator.of(context).pop();
  }
}
