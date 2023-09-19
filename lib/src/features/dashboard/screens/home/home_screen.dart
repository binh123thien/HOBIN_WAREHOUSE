import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/appbar_dashboard.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuticon.dart';
import '../../controllers/add/chonhanghoa_controller.dart';
import '../../controllers/history/history_controller.dart';
import '../../controllers/statistics/doanhthu_controller.dart';
import 'widget/card_dashboard.dart';
import 'widget/expense_graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(ChonHangHoaController());
  final controllerHistory = Get.put(HistoryController());
  final controllerDoanhThu = Get.put(DoanhThuController());
  final HistoryController controllerHistoryRepo = Get.find();
  @override
  void initState() {
    super.initState();
    controller.loadAllHangHoa();
    controllerHistory.loadPhiNhapHangTrongThang("NhapHang");
    controllerHistory.loadPhiNhapHangTrongThang("BanHang");
    controllerDoanhThu.loadDoanhThuTuanChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: mainColor,
        title: const AppBarDashBoard(),
      ),
      // backgroundColor: whiteColor,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CardDashboard(),
            ShortCutIcon(),
            SizedBox(height: 20),
            ExpenseTrack(),
            SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
