import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';

///Main Widgets
class MainWidgets {
  ///AppBar
  static PreferredSizeWidget appBar({
    Widget? title,
    bool? allowBack = true,
    bool? centerTitle = true,
    Color? backgroundColor,
    Widget? leading,
    VoidCallback? onBack,
    List<Widget>? actions,
  }) {
    //Default Leading
    final defaultLeading = IconButton(
      onPressed: onBack ?? () => Navigator.pop(Get.context!),
      icon: const Icon(Ionicons.ios_chevron_back),
    );

    //Leading Widget
    final finalLeading = leading ?? (allowBack ?? true ? defaultLeading : null);

    //AppBar
    return AppBar(
      title: title,
      automaticallyImplyLeading: allowBack ?? true,
      scrolledUnderElevation: 0.0,
      backgroundColor:
          backgroundColor ?? Theme.of(Get.context!).scaffoldBackgroundColor,
      leading: finalLeading,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  ///Page Title
  static Widget pageTitle({required String title, double? textSize}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: textSize ?? 24.0,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ///Bottom Navigation Bar
  static Widget bottomNav({
    required int navIndex,
    required Function(int index) onChanged,
    Color? backgroundColor,
  }) {
    //Android
    if (Platform.isAndroid) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14.0)),
        child: BottomNavigationBar(
          backgroundColor:
              backgroundColor ?? Theme.of(Get.context!).dialogBackgroundColor,
          selectedItemColor: Theme.of(Get.context!).iconTheme.color,
          currentIndex: navIndex,
          onTap: (index) {
            onChanged(index);
          },
          items: const [
            //News
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Ionicons.ios_newspaper_outline),
              ),
              label: "Notícias",
            ),

            //Events
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(MaterialCommunityIcons.drama_masks),
              ),
              label: "Eventos",
            ),

            //Offline
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Ionicons.ios_cloud_offline_outline),
              ),
              label: "Offline",
            ),
          ],
        ),
      );
    }

    //iOS
    if (Platform.isIOS) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14.0)),
        child: CupertinoTabBar(
          backgroundColor:
              backgroundColor ?? Theme.of(Get.context!).dialogBackgroundColor,
          activeColor: Theme.of(Get.context!).iconTheme.color,
          currentIndex: navIndex,
          onTap: (index) {
            onChanged(index);
          },
          height: 60.0,
          items: const [
            //News
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Ionicons.ios_newspaper_outline),
              ),
              label: "Notícias",
            ),

            //Events
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(MaterialCommunityIcons.drama_masks),
              ),
              label: "Eventos",
            ),

            //Offline
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Ionicons.ios_cloud_offline_outline),
              ),
              label: "Offline",
            ),
          ],
        ),
      );
    }

    //Default
    return Container();
  }
}
