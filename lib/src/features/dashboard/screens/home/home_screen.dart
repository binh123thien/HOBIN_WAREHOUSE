import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/appbar_dashboard.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/home/widget/shortcuticon.dart';
import '../../../authentication/models/user_models.dart';
import '../../controllers/account/profile_controller.dart';
import '../../controllers/add/chonhanghoa_controller.dart';
import '../../controllers/history/history_controller.dart';
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
  final HistoryController controllerHistoryRepo = Get.find();
  final ProfileController controllerProfile = Get.find();
  @override
  void initState() {
    super.initState();
    controllerProfile.getUserData();
    controller.loadAllHangHoa();
    controllerHistory.loadPhiNhapHangTrongThang("NhapHang");
    controllerHistory.loadPhiNhapHangTrongThang("BanHang");
    userAccountUpdate = controllerProfile.userDataFrebase;
  }

  late UserModel userAccountUpdate;
  @override
  Widget build(BuildContext context) {
    print(userAccountUpdate.email);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: mainColor,
        title: AppBarDashBoard(userAccountUpdate: userAccountUpdate),
      ),
      backgroundColor: whiteColor,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CardDashboard(),
            Divider(),
            ShortCutIcon(),
            SizedBox(height: 20),
            Divider(),
            ExpenseTrack(),
            SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
