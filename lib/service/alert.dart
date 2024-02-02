import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alert {
  confirm(String title, String content, Function next,
      {String btn1 = 'cancelar', String btn2 = 'sim'}) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title.tr),
        content: Text(content.tr),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              {
                Get.back();
              }
            },
            child: Text(btn1.tr),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              next();
            },
            child: Text(btn2.tr),
          ),
        ],
      ),
    );
  }

  show(String title, String content, {String btn1 = 'ok'}) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title.tr),
        content: Text(content.tr),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              {
                Get.back();
              }
            },
            child: Text(btn1.tr),
          ),
        ],
      ),
    );
  }

  loading({barrierDismissible = false}) async {
    Get.dialog(
      barrierDismissible: barrierDismissible,
      const CupertinoAlertDialog(
        content: Center(
          child: SizedBox(
            width: 30,
            height: 30.0,
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          ),
        ),
      ),
    );
  }

  snackBar(String title, String msg) {
    Get.snackbar(
      title.tr,
      msg.tr,
      duration: const Duration(seconds: 2),
    );
  }
}
