import 'package:flutter/material.dart';
import '../style/pick_task_style.dart';
import '../../../../../models/task_item.dart';

/// 任务备注弹窗组件（保留全亮/单亮逻辑与 UI 样式）
/// highlightAll=true 进入时 4 单全亮；false 时仅 highlightedIndex 高亮，其余半透明
class TaskBottomSheet extends StatelessWidget {
  final List<TaskItem> tasks;
  final VoidCallback onClose;
  final bool highlightAll;
  final int highlightedIndex;

  const TaskBottomSheet({
    super.key,
    required this.tasks,
    required this.onClose,
    this.highlightAll = true,
    this.highlightedIndex = 0,
  });

  Color _cardColorByIndex(int i) {
    switch (i) {
      case 0:
        return PickTaskStyle.card1;
      case 1:
        return PickTaskStyle.card2;
      case 2:
        return PickTaskStyle.card3;
      case 3:
      default:
        return PickTaskStyle.card4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTasks = tasks.take(4).toList();
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(PickTaskStyle.radiusSheet),
            topRight: Radius.circular(PickTaskStyle.radiusSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    '任务数量·${displayTasks.length}个',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: PickTaskStyle.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onClose,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '关闭',
                        style: TextStyle(
                          fontSize: 16,
                          color: PickTaskStyle.textPrimary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: Column(
                  children: [
                    for (int i = 0; i < displayTasks.length; i++) ...[
                      _TaskCard(
                        item: displayTasks[i],
                        color: _cardColorByIndex(i),
                        dimmed: !highlightAll && i != highlightedIndex,
                      ),
                      if (i != displayTasks.length - 1)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskItem item;
  final Color color;
  final bool dimmed;

  const _TaskCard({
    required this.item,
    required this.color,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(PickTaskStyle.radiusCard),
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(PickTaskStyle.radiusAvatar),
                      ),
                      child: item.imagePath.isEmpty
                          ? const Icon(Icons.shopping_bag,
                              color: Color(0xFF1AB16D), size: 20)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  PickTaskStyle.radiusAvatar),
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.shopping_bag,
                                  color: Color(0xFF1AB16D),
                                  size: 20,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.materialSpec,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: PickTaskStyle.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.remark.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '备注',
                        style: TextStyle(
                          fontSize: 12,
                          color: PickTaskStyle.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.remark,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: PickTaskStyle.textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: PickTaskStyle.badgeShadow,
                ),
                child: Text(
                  '${item.totalNumber}件',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: PickTaskStyle.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}