import 'package:flutter/material.dart';

///Main App Widgets
class MainWidgets {
  ///Default AppBar
  /// - `title` => Page Title (String)
  /// - `allowBack` => Allow to Go Back to Previous Page (Bool)
  /// - `centerTitle` => Center Title or Not (Bool)
  static AppBar defaultAppBar({
    required String title,
    required bool allowBack,
    required bool centerTitle,
    List<Widget>? actions,
  }) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: allowBack,
      centerTitle: centerTitle,
      actions: actions ?? [], //Page Actions if Defined / Null if None
    );
  }

  ///Default Scaffold
  /// - `pageTitle` => Page Title (String)
  /// - `allowBack` => Allow to Go Back to Previous Page (Bool)
  /// - `centerTitle` => Center Title or Not (Bool)
  /// - `actions` => Page Actions (List<Widget\>)
  static Scaffold defaultScaffold({
    required String pageTitle,
    required bool centerTitle,
    required bool allowBack,
    List<Widget>? actions,
    required Widget body,
  }) {
    return Scaffold(
      appBar: defaultAppBar(
        title: pageTitle,
        allowBack: allowBack,
        centerTitle: centerTitle,
        actions: actions ?? [],
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }
}
