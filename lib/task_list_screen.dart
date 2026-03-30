import 'package:flutter/material.dart';
import 'services/task_service.dart';

/// 任务数量列表模块
/// 需要后端接口：获取任务列表数据
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // 任务数据 - 从后端接口获取
  List<TaskItem> tasks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// 加载任务数据 - 需要后端接口实现
  Future<void> _loadTasks() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // 从后端获取任务数据
      final fetchedTasks = await TaskService.fetchTasks();
      
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = '加载任务失败: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务数量 (${tasks.length})'), // 显示任务数量
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // 关闭按钮，点击回到上级
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTasks,
              child: const Text('重新加载'),
            ),
          ],
        ),
      );
    }

    if (tasks.isEmpty) {
      return const Center(
        child: Text('暂无任务'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(tasks[index], index);
      },
    );
  }

  /// 构建任务卡片
  Widget _buildTaskCard(TaskItem task, int index) {
    // 根据索引设置不同的背景色
    Color backgroundColor;
    switch (index) {
      case 0:
        backgroundColor = const Color(0xFFF1F2F4); // 第一个卡片底色
        break;
      case 1:
        backgroundColor = const Color(0xFF11D6D0).withValues(alpha: 0.1); // 第二个卡片底色
        break;
      case 2:
        backgroundColor = const Color(0xFFFB4C8D).withValues(alpha: 0.1); // 第三个卡片底色
        break;
      case 3:
        backgroundColor = const Color(0xFF9045E6).withValues(alpha: 0.1); // 第四个卡片底色
        break;
      default:
        backgroundColor = Colors.grey.withValues(alpha: 0.1);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // 点击卡片查看任务详情 - 需要后端接口支持
          _showTaskDetail(task);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 耗材图片 - 需要后端接口提供实际图片URL
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[600],
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 耗材尺寸 - 需要后端接口提供
                            Text(
                              '尺寸: ${task.size}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // 数量 - 需要后端接口提供
                            Text(
                              '数量: ${task.quantity}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 备注 - 需要后端接口提供
                  if (task.note.isNotEmpty && task.note != '无备注')
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '备注: ${task.note}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
              // 右上角总件数 - 需要后端接口提供
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${task.totalItems}件',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示任务详情 - 需要后端接口支持
  void _showTaskDetail(TaskItem task) async {
    // TODO: 从后端获取任务详情
    await TaskService.getTaskDetail(task.id);
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('任务详情'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('尺寸: ${task.size}'),
              Text('数量: ${task.quantity}'),
              Text('总件数: ${task.totalItems}'),
              if (task.note.isNotEmpty && task.note != '无备注')
                Text('备注: ${task.note}'),
              const SizedBox(height: 16),
              const Text(
                '更多详情功能需要后端接口支持...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
            ElevatedButton(
              onPressed: () {
                // 完成任务 - 需要后端接口支持
                _completeTask(task.id);
                Navigator.pop(context);
              },
              child: const Text('完成任务'),
            ),
          ],
        ),
      );
    }
  }

  /// 完成任务 - 需要后端接口支持
  Future<void> _completeTask(String taskId) async {
    try {
      final success = await TaskService.completeTask(taskId);
      if (success && mounted) {
        // 刷新任务列表
        _loadTasks();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('任务已完成'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('完成任务失败: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}