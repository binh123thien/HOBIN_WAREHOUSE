import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/phanloai/streamlist_phanloai.dart';
import '../../../../../repository/history_repository/history_repository.dart';

class ThanhCongHistoryScreen extends StatefulWidget {
  final String searchHistory;
  const ThanhCongHistoryScreen({super.key, required this.searchHistory});
  @override
  State<ThanhCongHistoryScreen> createState() => _ThanhCongHistoryScreenState();
}

class _ThanhCongHistoryScreenState extends State<ThanhCongHistoryScreen> {
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
        .getDocsByMonthlyPhanLoai(firebaseUser!.uid, "Thành công")
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
        searchHistory: widget.searchHistory,
        controller: controller,
        docsByMonth: docsByMonthly);
  }
}
