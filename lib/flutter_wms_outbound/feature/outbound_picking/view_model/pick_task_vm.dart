import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../models/task_item.dart';

class ProductItem {
  final String name;
  final String orderLabel;
  final String imagePath;
  final String location;
  final int floor;
  final int count;
  final String date;
  final String tag1;
  final String tag2;

  const ProductItem({
    required this.name,
    required this.orderLabel,
    required this.imagePath,
    required this.location,
    required this.floor,
    required this.count,
    required this.date,
    required this.tag1,
    required this.tag2,
  });
}

class OperationField {
  final String label;
  final TextEditingController controller;
  OperationField(this.label) : controller = TextEditingController();
}

class PickTaskVm extends ChangeNotifier {
  List<TaskItem> tasks = const [
    TaskItem(
      orderLabel: '第一单',
      materialSpec: '大号*2；小号*1',
      remark: '给我两个葱',
      totalNumber: 14,
      imagePath: 'icon/耗材1.png',
    ),
    TaskItem(
      orderLabel: '第二单',
      materialSpec: '小号*1',
      remark: '',
      totalNumber: 4,
      imagePath: 'icon/耗材图片.png',
    ),
    TaskItem(
      orderLabel: '第三单',
      materialSpec: '大号*2',
      remark: '给我两个葱给我两个葱给我两个葱给我两个葱给我两个葱',
      totalNumber: 10,
      imagePath: 'icon/打包袋.png',
    ),
    TaskItem(
      orderLabel: '第四单',
      materialSpec: '大号*1；小号*1',
      remark: '给我两个葱',
      totalNumber: 7,
      imagePath: 'icon/耗材1.png',
    ),
  ];

  List<ProductItem> products = const [
    ProductItem(
      name: '五常大米 5kg 真空装 东北产地',
      orderLabel: '第一单',
      imagePath: 'icon/商品1.png',
      location: 'CW-01-2',
      floor: 4,
      count: 20,
      date: '生产日期：2025.05.29',
      tag1: '宰杀',
      tag2: '良品',
    ),
    ProductItem(
      name: '饮用水 550ml*24瓶',
      orderLabel: '第二单',
      imagePath: 'icon/商品2.png',
      location: 'CW-02-3',
      floor: 2,
      count: 24,
      date: '生产日期：2025.06.02',
      tag1: '灭菌',
      tag2: '良品',
    ),
    ProductItem(
      name: '食用油 5L 压榨一级',
      orderLabel: '第三单',
      imagePath: 'icon/商品3.png',
      location: 'CW-03-1',
      floor: 5,
      count: 26,
      date: '生产日期：2025.05.18',
      tag1: '压榨',
      tag2: '良品',
    ),
    ProductItem(
      name: '面粉 2.5kg 小麦粉',
      orderLabel: '第四单',
      imagePath: 'icon/商品4.png',
      location: 'CW-01-5',
      floor: 1,
      count: 18,
      date: '生产日期：2025.04.11',
      tag1: '常温',
      tag2: '良品',
    ),
  ];

  int currentProductIndex = 0;
  int highlightedIndex = 0;
  bool highlightAll = true;
  int countdownSeconds = 268; // 对应 04:28
  Timer? _timer;
  String? validationMessage;

  final List<OperationField> operationFields = [
    OperationField('商品编码'),
    OperationField('下架数量'),
  ];

  PickTaskVm() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds > 0) {
        countdownSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  String get timerText {
    final m = countdownSeconds ~/ 60;
    final s = countdownSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  ProductItem get currentProduct => products[currentProductIndex];

  void selectProduct(int index) {
    if (index < 0 || index >= products.length) return;
    currentProductIndex = index;
    highlightedIndex = index;
    notifyListeners();
  }

  void toggleSort() {
    products = products.reversed.toList();
    notifyListeners();
  }

  void setHighlightedIndex(int index) {
    highlightedIndex = index.clamp(0, tasks.length - 1);
    highlightAll = false;
    notifyListeners();
  }

  void resetHighlightAll() {
    highlightAll = true;
    notifyListeners();
  }

  bool validateAndSubmit() {
    for (final field in operationFields) {
      if (field.controller.text.trim().isEmpty) {
        validationMessage = '${field.label}不能为空';
        notifyListeners();
        return false;
      }
    }
    validationMessage = null;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final f in operationFields) {
      f.controller.dispose();
    }
    super.dispose();
  }
}