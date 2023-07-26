import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../repository/history_repository/history_repository.dart';
import '../widget/phanloai/streamlist_phanloai.dart';

class DangChoHistoryScreen extends StatefulWidget {
  const DangChoHistoryScreen({super.key});
  @override
  State<DangChoHistoryScreen> createState() => _DangChoHistoryScreenState();
}

class _DangChoHistoryScreenState extends State<DangChoHistoryScreen> {
  final controller = Get.put(HistoryRepository());
  List<List<DocumentSnapshot>> docsByMonthly = [];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _fetchData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _fetchData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await controller
        .getDocsByMonthlyPhanLoai(firebaseUser!.uid, "Đang chờ")
        .then((value) {
      if (_isMounted) {
        setState(() {
          docsByMonthly = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamListHistoryPhanLoai(
        controller: controller, docsByMonth: docsByMonthly);
  }
}
