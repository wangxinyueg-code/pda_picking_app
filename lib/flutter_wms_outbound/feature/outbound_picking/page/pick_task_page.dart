import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/pick_task_style.dart';
import '../view_model/pick_task_vm.dart';
import '../widgets/task_bottom_sheet.dart';
import '../../../../../models/task_item.dart';

class PickTaskPage extends StatelessWidget {
  const PickTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PickTaskVm(),
      child: const _PickTaskView(),
    );
  }
}

class _PickTaskView extends StatefulWidget {
  const _PickTaskView();

  @override
  State<_PickTaskView> createState() => _PickTaskViewState();
}

class _PickTaskViewState extends State<_PickTaskView> {
  bool _isOpening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSheet(initial: true));
  }

  Future<void> _showSheet({required bool initial}) async {
    if (_isOpening) return;
    _isOpening = true;
    final vm = context.read<PickTaskVm>();
    if (initial) {
      vm.resetHighlightAll();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      barrierColor: PickTaskStyle.barrier.withOpacity(0.8),
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ChangeNotifierProvider.value(
          value: vm,
          child: Consumer<PickTaskVm>(
            builder: (_, vm, __) {
              return TaskBottomSheet(
                tasks: vm.tasks,
                onClose: () => Navigator.of(ctx).pop(),
                highlightAll: vm.highlightAll,
                highlightedIndex: vm.highlightedIndex,
              );
            },
          ),
        );
      },
    );
    _isOpening = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PickTaskVm>(
      builder: (context, vm, _) {
        final product = vm.currentProduct;
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: SafeArea(
            child: Column(
              children: [
                _buildStatusBar(),
                _buildTopNav(vm),
                _buildProductScroll(vm),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      children: [
                        _buildOrderInfo(product),
                        const SizedBox(height: 8),
                        _buildProductDetails(product),
                        const SizedBox(height: 12),
                        _buildBottomOperation(vm),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.black,
      child: const Row(
        children: [
          Text(
            '前置仓',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Text(
            'V2.0',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          SizedBox(width: 12),
          Text(
            '12:30',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(PickTaskVm vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          _iconButton('icon/Lui-icon-swapcircle2.png', onTap: () {}),
          const SizedBox(width: 8),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '0/150',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF23252B)),
                ),
                TextSpan(
                  text: '件',
                  style: TextStyle(fontSize: 12, color: Color(0xFF23252B)),
                ),
              ],
            ),
          ),
          const Spacer(),
          _timerBoxes(vm.timerText),
          const Spacer(),
          _iconButton('icon/Lui-icon-setting.png', onTap: () {}),
        ],
      ),
    );
  }

  Widget _iconButton(String asset, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(asset, width: 24, height: 24),
    );
  }

  Widget _timerBoxes(String time) {
    final parts = time.split(':');
    return Row(
      children: [
        _timerBox(parts.first),
        const SizedBox(width: 4),
        const Text(':', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF23252B))),
        const SizedBox(width: 4),
        _timerBox(parts.last),
      ],
    );
  }

  Widget _timerBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECF4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF23252B)),
      ),
    );
  }

  Widget _buildProductScroll(PickTaskVm vm) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: SizedBox(
        height: 64,
        child: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.only(left: 12, right: 80),
              scrollDirection: Axis.horizontal,
              itemCount: vm.products.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == vm.products.length) {
                  // 末尾进度模块
                  return _progressTail();
                }
                final item = vm.products[index];
                final selected = index == vm.currentProductIndex;
                final borderColor = _orderBorderColor(index);
                return GestureDetector(
                  onTap: () => vm.selectProduct(index),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selected ? borderColor : borderColor.withOpacity(0.5), width: 2),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(item.imagePath, fit: BoxFit.contain),
                  ),
                );
              },
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: _filterBar(vm),
            ),
          ],
        ),
      ),
    );
  }

  Color _orderBorderColor(int idx) {
    switch (idx) {
      case 0:
        return const Color(0xFF6A6D73);
      case 1:
        return const Color(0xFF11D6D0);
      case 2:
        return const Color(0xFFFB4C8D);
      case 3:
      default:
        return const Color(0xFF9045E6);
    }
  }

  Widget _filterBar(PickTaskVm vm) {
    return Container(
      width: 66,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: InkWell(
        onTap: vm.toggleSort,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('正序', style: TextStyle(fontSize: 12, color: Color(0xFF23252B))),
            const SizedBox(width: 2),
            Image.asset('icon/Lui-icon-d-caret-solid.png', width: 14, height: 14),
          ],
        ),
      ),
    );
  }

  Widget _progressTail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          '0/6',
          style: TextStyle(fontSize: 12, color: Color(0xFF23252B)),
        ),
      ),
    );
  }

  Widget _buildOrderInfo(ProductItem product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23252B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(product.orderLabel, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: product.location,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF23252B)),
                      ),
                      const TextSpan(text: '列', style: TextStyle(fontSize: 14, color: Color(0xFF23252B))),
                      TextSpan(
                        text: product.floor.toString(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF23252B)),
                      ),
                      const TextSpan(text: '层', style: TextStyle(fontSize: 14, color: Color(0xFF23252B))),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: product.count.toString(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A73E8)),
                      ),
                      const TextSpan(text: '件', style: TextStyle(fontSize: 16, color: Color(0xFF23252B))),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF23252B)),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _tag(product.date, bg: const Color(0xFFFFF4E6), color: const Color(0xFFFA9028)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _tag(product.tag1, bg: const Color(0xFFF7F1FF), color: const Color(0xFF946AEC)),
                    const SizedBox(width: 6),
                    _tag(product.tag2, bg: const Color(0xFFE9F1FF), color: const Color(0xFF4D7EFF)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(product.imagePath, width: 120, height: 120, fit: BoxFit.cover),
              ),
              Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF1F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.add, size: 18, color: Color(0xFF23252B)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, {required Color bg, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 12, color: color)),
    );
  }

  Widget _buildProductDetails(ProductItem product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF23252B)),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset('icon/down-min.png', width: 20, height: 20),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _tag(product.tag1, bg: const Color(0xFFF7F1FF), color: const Color(0xFF946AEC)),
              const SizedBox(width: 6),
              _tag(product.tag2, bg: const Color(0xFFE9F1FF), color: const Color(0xFF4D7EFF)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomOperation(PickTaskVm vm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '商品编码 》》 下架数量',
            style: TextStyle(fontSize: 14, color: Color(0xFF23252B)),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < vm.operationFields.length; i++) ...[
            _operationField(vm.operationFields[i]),
            const SizedBox(height: 10),
          ],
          if (vm.validationMessage != null)
            Text(
              vm.validationMessage!,
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              _actionButton('任务备注', onTap: () {
                vm.setHighlightedIndex(vm.currentProductIndex);
                _showSheet(initial: false);
              }),
              const SizedBox(width: 8),
              _actionButton('拣货明细', onTap: () {}),
              const SizedBox(width: 8),
              _actionButton('差异上报', onTap: () {}),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (vm.validateAndSubmit()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('校验通过')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(vm.validationMessage ?? '校验失败')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('确认'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _operationField(OperationField field) {
    return TextField(
      controller: field.controller,
      decoration: InputDecoration(
        hintText: '请输入${field.label}',
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E4EB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E4EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4D7EFF), width: 1.2)),
      ),
    );
  }

  Widget _actionButton(String text, {required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: Color(0xFFE0E4EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Color(0xFF23252B)),
      ),
    );
  }
}