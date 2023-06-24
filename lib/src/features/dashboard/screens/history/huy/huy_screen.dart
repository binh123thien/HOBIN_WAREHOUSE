import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../repository/history_repository/history_repository.dart';
import '../widget/phanloai/streamlist_phanloai.dart';

class HuyHistoryScreen extends StatefulWidget {
  const HuyHistoryScreen({super.key});
  @override
  State<HuyHistoryScreen> createState() => _HuyHistoryScreenState();
}

class _HuyHistoryScreenState extends State<HuyHistoryScreen> {
  final controller = Get.put(HistoryRepository());
  List<List<DocumentSnapshot>> docsByMonthly = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await controller
        .getDocsByMonthlyPhanLoai(firebaseUser!.uid, "Hủy")
        .then((value) {
      setState(() {
        docsByMonthly = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(docsByMonthly);
    return StreamListHistoryPhanLoai(
        controller: controller, docsByMonth: docsByMonthly);
  }
}
