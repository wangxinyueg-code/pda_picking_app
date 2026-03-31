import 'package:flutter/material.dart';

class PdaHomePage extends StatefulWidget {
  const PdaHomePage({super.key});

  @override
  State<PdaHomePage> createState() => _PdaHomePageState();
}

class _PdaHomePageState extends State<PdaHomePage> {
  // 
  String progress = "0/150";
  String countDownMin = "04";
  String countDownSec = "30";
  String orderLabel = "第一单";
  String location = "CW-01-2";
  String floor = "4";
  String orderCount = "20";
  String productName = "新鲜鸡胸肉 500g/袋 冷冻保鲜 肉质鲜嫩 高蛋白";
  String productDate = "生产日期：2025.05.29";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 主体内容
      body: Stack(
        children: [
          // ===================== 1. 页面主体 =====================
          SingleChildScrollView(
            child: Column(
              children: [
                // 🔹 顶部状态栏
                _buildStatusBar(),
                // 🔹 顶部导航栏 + 倒计时
                _buildTopNav(),
                // 🔹 商品滑动栏
                _buildProductScrollBar(),
                // 🔹 商品详情卡片
                _buildGoodsDetailCard(),
                // 🔹 底部操作区
                _buildBottomOperation(),
              ],
            ),
          ),

          // ===================== 2. 商品图片预览弹窗 =====================
          _buildImagePreview(),

          // ===================== 3. 任务弹窗 =====================
          _buildTaskModal(),
        ],
      ),
    );
  }

  // 状态栏
  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey[100],
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("前置仓", style: TextStyle(fontSize: 14)),
          Row(
            children: [
              Text("V2.0", style: TextStyle(fontSize: 12)),
              SizedBox(width: 8),
              Text("12:30", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  // 顶部导航
  Widget _buildTopNav() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_back, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "$progress件",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          // 倒计时
          Row(
            children: [
              _timeBox(countDownMin),
              const Text(":",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              _timeBox(countDownSec),
            ],
          ),
          const Icon(Icons.settings, color: Colors.white),
        ],
      ),
    );
  }

  // 倒计时样式
  Widget _timeBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 商品滑动栏
  Widget _buildProductScrollBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("正序", style: TextStyle(fontSize: 14)),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  // 商品详情卡片
  Widget _buildGoodsDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 订单信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orderLabel,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("$location 列 $floor 层",
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text("$orderCount 件",
                      style: const TextStyle(fontSize: 14, color: Colors.red)),
                ],
              ),
              // 商品图片占位
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 商品信息
          Text(
            productName,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(productDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          // 标签
          const Row(
            children: [
              Chip(label: Text("宰杀"), backgroundColor: Colors.green),
              SizedBox(width: 8),
              Chip(label: Text("良品"), backgroundColor: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  // 底部操作区
  Widget _buildBottomOperation() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("商品编码 >>> 下架数量", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          // 操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton("任务备注"),
              _actionButton("拣货明细"),
              _actionButton("差异上报"),
            ],
          ),
          const SizedBox(height: 16),
          // 确认按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("确认",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // 操作按钮样式
  Widget _actionButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(text),
    );
  }

  // 图片预览弹窗
  Widget _buildImagePreview() {
    return const SizedBox();
  }

  // 任务弹窗
  Widget _buildTaskModal() {
    return const SizedBox();
  }
}
