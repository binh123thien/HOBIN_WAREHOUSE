// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/utils/image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../common_widgets/bottom_sheet_options.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../repository/goods_repository/good_repository.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../utils/validate/validate.dart';
import '../../../../controllers/goods/chondanhmuc_controller.dart';
import '../../../../controllers/goods/chondonvi_controller.dart';
import '../../../../controllers/goods/them_hanghoa_controller.dart';
import '../themhanghoa/danhmuc.dart';
import '../themhanghoa/donvi.dart';
import '../themhanghoa/phanloai_hang_hoa.dart';

class ChinhSuaChiTietHangHoaScreen extends StatefulWidget {
  final dynamic updateChinhSuaHangHoa;
  const ChinhSuaChiTietHangHoaScreen({super.key, this.updateChinhSuaHangHoa});

  @override
  State<ChinhSuaChiTietHangHoaScreen> createState() =>
      _ChinhSuaChiTietHangHoaScreenState();
}

class _ChinhSuaChiTietHangHoaScreenState
    extends State<ChinhSuaChiTietHangHoaScreen> with InputValidationMixin {
  final controllerDanhMuc = Get.put(ChonDanhMucController());
  final controller = Get.put(ThemHangHoaController());
  final myController = Get.put(ChonDonViController());
  final goodsRepo = Get.put(GoodRepository());

  late Map<String, dynamic> hangHoatam;

  Uint8List? currentImage;
  Uint8List? preImage;
  bool _isLoading = false;
  @override
  void initState() {
    //tạo map tạm để show hình ảnh chưa lưu
    hangHoatam = widget.updateChinhSuaHangHoa;
    final formatGiaNhap =
        formatCurrencWithoutD(widget.updateChinhSuaHangHoa['gianhap']);
    final formatGiaBan =
        formatCurrencWithoutD(widget.updateChinhSuaHangHoa['giaban']);
    controller.maCodeController =
        TextEditingController(text: widget.updateChinhSuaHangHoa['macode']);
    controller.tenSanPhamController =
        TextEditingController(text: widget.updateChinhSuaHangHoa['tensanpham']);
    controller.gianhapController = TextEditingController(text: formatGiaNhap);
    controller.giabanController = TextEditingController(text: formatGiaBan);
    //phân loại sẽ được truyền  qua radio sau đó xét đk bên file chonDanhMuc
    controller.donviController =
        TextEditingController(text: widget.updateChinhSuaHangHoa['donvi']);
    // hiển thị danh mục
    //clear danh mục khi vô lại trang
    controllerDanhMuc.selectedDanhMuc.clear();
    for (int i = 0; i < widget.updateChinhSuaHangHoa['danhmuc'].length; i++) {
      controllerDanhMuc.selectedDanhMuc
          .add(widget.updateChinhSuaHangHoa['danhmuc'][i]);
    }
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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
        title: const Text("Chỉnh sửa chi tiết hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
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
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : hangHoatam["photoGood"] == ''
                              ? Image.asset(cameraIcon)
                              : CachedNetworkImage(
                                  imageUrl: hangHoatam["photoGood"].toString(),
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.fill,
                                ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: TextFormField(
                        controller: controller.maCodeController,
                        decoration: const InputDecoration(
                          enabled: false,
                          errorStyle: TextStyle(fontSize: 15),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 2)),
                          contentPadding: EdgeInsets.zero,
                          labelText: "Mã code",
                          labelStyle: TextStyle(fontSize: 18),
                        ),
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
                          enabled: false,
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Phân loại",
                              style: TextStyle(fontSize: 18)),
                          RadioButton(phanloaiFb: hangHoatam['phanloai']),
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
      bottomNavigationBar: BottomAppBar(
        height: 80,
        color: whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 350,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  side: const BorderSide(color: mainColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5), // giá trị này xác định bán kính bo tròn
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    await goodsRepo
                        .updateGood(
                            hangHoatam['macode'],
                            widget.updateChinhSuaHangHoa['photoGood'],
                            controller.tenSanPhamController.text,
                            currentImage)
                        .then((newvalue) {
                      Get.snackbar("Cập nhật hàng hóa thành công",
                          "Hàng hóa đã cập nhật theo yêu cầu của bạn",
                          colorText: Colors.green);
                      Navigator.of(context).pop(newvalue);
                    });
                  }
                },
                child: _isLoading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: whiteColor,
                        ),
                      )
                    : const Text(
                        'Lưu & thoát',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
