import 'package:flutter/material.dart';

enum LayoutType { tab, card }

class LayoutProvider extends ChangeNotifier {
  LayoutType _layout = LayoutType.card;

  LayoutType get layout => _layout;

  void switchLayout(LayoutType layoutType) {
    _layout = layoutType;
    notifyListeners();
  }
}
