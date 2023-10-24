import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../repository/history_repository/history_repository.dart';
import '../widget/phanloai/streamlist_phanloai.dart';

class HuyHistoryScreen extends StatefulWidget {
  final String searchHistory;
  const HuyHistoryScreen({super.key, required this.searchHistory});
  @override
  State<HuyHistoryScreen> createState() => _HuyHistoryScreenState();
}

class _HuyHistoryScreenState extends State<HuyHistoryScreen> {
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
        .getDocsByMonthlyPhanLoai(firebaseUser!.uid, "Hủy")
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
      docsByMonth: docsByMonthly,
    );
  }
}
