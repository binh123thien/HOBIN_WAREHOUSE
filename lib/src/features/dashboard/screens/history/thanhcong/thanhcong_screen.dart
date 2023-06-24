import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/phanloai/streamlist_phanloai.dart';
import '../../../../../repository/history_repository/history_repository.dart';

class ThanhCongHistoryScreen extends StatefulWidget {
  const ThanhCongHistoryScreen({super.key});
  @override
  State<ThanhCongHistoryScreen> createState() => _ThanhCongHistoryScreenState();
}

class _ThanhCongHistoryScreenState extends State<ThanhCongHistoryScreen> {
  final controller = Get.put(HistoryRepository());
  List<List<DocumentSnapshot>> docsByMonthly = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await controller
        .getDocsByMonthlyPhanLoai(firebaseUser!.uid, "Thành công")
        .then((value) {
      setState(() {
        docsByMonthly = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamListHistoryPhanLoai(
        controller: controller, docsByMonth: docsByMonthly);
  }
}
