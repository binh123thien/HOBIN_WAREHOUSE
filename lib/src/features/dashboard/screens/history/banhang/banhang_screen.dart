import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../repository/history_repository/history_repository.dart';
import '../widget/nhapbanhang/streamlist.dart';

class BanHangScreen extends StatefulWidget {
  const BanHangScreen({super.key});
  @override
  State<BanHangScreen> createState() => _BanHangScreenState();
}

class _BanHangScreenState extends State<BanHangScreen> {
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
        .getDocsByMonthly('BanHang', firebaseUser!.uid)
        .then((value) {
      setState(() {
        docsByMonthly = value;
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamList(
      controller: controller,
      docsByMonth: docsByMonthly,
      snapshotCollection: 'BanHang',
    );
  }
}
