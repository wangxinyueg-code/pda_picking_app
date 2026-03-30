import 'package:flutter/material.dart';

class PickTaskStyle {
  // 弹窗遮罩
  static const Color barrier = Color(0xFF23252B);

  // 任务卡配色
  static const Color card1 = Color(0xFFF5F5F5);
  static const Color card2 = Color(0xFFE8F8F5);
  static const Color card3 = Color(0xFFF4ECFC);
  static const Color card4 = Color(0xFFFFEDF4);

  // 文案色
  static const Color textPrimary = Color(0xFF23252B);
  static const Color textSecondary = Color(0xFF868D9F);

  // 圆角
  static const double radiusSheet = 16;
  static const double radiusCard = 12;
  static const double radiusAvatar = 8;

  // 阴影
  static const List<BoxShadow> badgeShadow = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}