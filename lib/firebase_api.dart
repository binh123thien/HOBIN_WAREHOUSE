import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage? message) async {
  if (message == null) {
    return;
  }

  // print(message.notification?.title);
  // print(message.notification?.body);
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;

class FirebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }

    // print(message.notification?.title);
  }

// Future<void> scheduleDailyNotification() async {
//   final now = tz.TZDateTime.now(
//       tz.local); // Lấy thời gian hiện tại dựa trên múi giờ cục bộ

//   // Xác định thời gian cố định hàng ngày (ví dụ: 10 giờ sáng)
//   final scheduledTime = tz.TZDateTime(
//     tz.local,
//     now.year,
//     now.month,
//     now.day,
//     10, // 10 AM
  //   );

  //   // Nếu thời gian đã qua 10 AM, đặt lịch cho ngày mai
  //   if (now.isAfter(scheduledTime)) {
  //     scheduledTime.add(const Duration(days: 1));
//   }

//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   const androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'daily_notification_channel',
  //     'Daily Notification',
  //     importance: Importance.high,
  //   );
  //   const platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //   );

  //   // Tạo thông báo hàng ngày
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'Sản phẩm đã hết hạn',
  //     'Kiểm tra các sản phẩm đã hết hạn và sắp hết hạn.',
  //     scheduledTime,
  //     platformChannelSpecifics,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );

  //   print('Đã đặt lịch thông báo hàng ngày vào 10 giờ sáng.');
  // }

  Future<void> initLocalNotification() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@drawable/ic_launcher"),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        // print('notificationResspone ${notificationResponse.payload}');
      },
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  initPushNotification() {
    _firebaseMessaging.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        payload: jsonEncode(message.toMap()),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
      );
    }
  }

  initNotification() async {
    await _firebaseMessaging.requestPermission();
    // final fcmToken = await _firebaseMessaging.getToken();
    // print('Token: $fcmToken');
    await setupFlutterNotifications();
    initLocalNotification();
    initPushNotification();

// scheduleDailyNotification(); // Đặt lịch thông báo hàng ngày
    checkProductExpiryAndSendNotification();
  }

// Hàm này truy vấn dữ liệu từ Firestore và quyết định gửi thông báo hay không
  Future<void> checkProductExpiryAndSendNotification() async {
    // List<dynamic> allHangHoaFireBase = [];
    // final controllerGoodRepo = Get.put(GoodRepository());
    // await controllerGoodRepo.getAllhanghoa().listen((snapshot) {
    //   allHangHoaFireBase = snapshot.docs.map((doc) => doc.data()).toList();
    // });
    // print('eeeeeeeeeeee $allHangHoaFireBase');
    // final controllerChonHangHoa = Get.put(ChonHangHoaController());
    // print('tttttttttt ${controllerChonHangHoa.allHangHoaFireBase}');
    // final firestore = FirebaseFirestore.instance;
    // final firebaseUser = FirebaseAuth.instance.currentUser;

// Thực hiện truy vấn để lấy dữ liệu sản phẩm từ Firestore
    // final productsQuery = await firestore
    //     .collection("Users")
    //     .doc(firebaseUser!.uid)
    //     .collection("Goods")
    //     .doc(firebaseUser.uid)
    //     .collection("Expired")
    //     .get();

    // final now = DateTime.now();
    // final formatter = DateFormat('dd-MM-yyyy'); // Định dạng ngày thời hạn
    // if (productsQuery.docs.isNotEmpty) {
    //   // Có ít nhất một sản phẩm trong kết quả truy vấn
    //   for (var productDoc in productsQuery.docs) {
    //     final productData = productDoc.data();
    //     final expiryDateStr = productData['exp'] as String;
    //     final expiryDate = formatter.parse(expiryDateStr);

    //     if (expiryDate.isAfter(now) && expiryDate.difference(now).inDays <= 7) {
    //       // Thực hiện truy vấn Firestore để lấy dữ liệu dựa trên thông tin sản phẩm
    //       final productInfo = await firestore
    //           .collection("Users")
    //           .doc(firebaseUser.uid)
    //           .collection("Goods")
    //           .doc(firebaseUser.uid)
    //           .collection("Expired")
    //           .doc(expiryDateStr)
    //           .collection('masanpham')
    //           .doc()
    //           .get();

    //       // Xử lý dữ liệu sản phẩm nếu cần
    //       if (productInfo.exists) {
    //         final productInfoData = productInfo.data();
    //         // print('rrrrrrrrrrrrrrrrrrrrr $productInfoData');
    //         // Xử lý dữ liệu sản phẩm ở đây
    //       } else {
    //         // print('vao else');
    //       }

    //       // Thời hạn còn 7 ngày nữa, xử lý dữ liệu sản phẩm ở đây
    //       final productName = productData['name']
    //           as String; // Thay 'name' bằng trường dữ liệu sản phẩm thực tế
    //       sendNotification('Sản phẩm $productName sắp hết hạn',
    //           'Sản phẩm này sắp hết hạn trong vòng 7 ngày.');
    //     }
    //   }
    // } else {
    //   // Không có sản phẩm nào trong Firestore
    //   print('Không có sản phẩm trong Firestore');
    // }
  }

  Future<void> sendNotification(String title, String body) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', // ID của kênh thông báo (đặt tùy ý)
      'Channel Name', // Tên kênh thông báo (đặt tùy ý)
      importance: Importance.high, // Độ quan trọng của thông báo
      priority: Priority.high, // Ưu tiên thông báo
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Gửi thông báo
    await flutterLocalNotificationsPlugin.show(
      0, // ID của thông báo (đặt tùy ý)
      title, // Tiêu đề thông báo
      body, // Nội dung thông báo
      platformChannelSpecifics,
    );
  }
}
