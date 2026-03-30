class TaskItem {
  final String id;
  final String consumableImage;
  final String size;
  final int quantity;
  final String note;
  final int totalItems;

  const TaskItem({
    required this.id,
    required this.consumableImage,
    required this.size,
    required this.quantity,
    required this.note,
    required this.totalItems,
  });
}

/// 任务服务接口 - 需要后端实现
class TaskService {
  /// 获取任务列表 - 需要后端API实现
  /// 
  /// 返回任务列表数据，用于显示任务数量列表模块
  /// 
  /// 需要后端提供：
  /// - 任务ID
  /// - 耗材图片URL
  /// - 耗材尺寸（大号/小号）
  /// - 数量
  /// - 备注信息
  /// - 总件数
  static Future<List<TaskItem>> fetchTasks() async {
    // TODO: 实现后端API调用
    // 示例API端点: GET /api/tasks
    // 示例响应格式:
    // {
    //   "tasks": [
    //     {
    //       "id": "1",
    //       "consumableImage": "https://example.com/image1.png",
    //       "size": "大号",
    //       "quantity": 5,
    //       "note": "紧急处理",
    //       "totalItems": 25
    //     }
    //   ]
    // }
    
    // 模拟延迟加载
    await Future.delayed(const Duration(seconds: 1));
    
    // 返回模拟数据 - 实际应从后端获取
    return [
      const TaskItem(
        id: '1',
        consumableImage: 'assets/images/consumable1.png',
        size: '大号',
        quantity: 5,
        note: '紧急处理',
        totalItems: 25,
      ),
      const TaskItem(
        id: '2',
        consumableImage: 'assets/images/consumable2.png',
        size: '小号',
        quantity: 3,
        note: '普通处理',
        totalItems: 15,
      ),
      const TaskItem(
        id: '3',
        consumableImage: 'assets/images/consumable3.png',
        size: '大号',
        quantity: 2,
        note: '无备注',
        totalItems: 10,
      ),
      const TaskItem(
        id: '4',
        consumableImage: 'assets/images/consumable4.png',
        size: '小号',
        quantity: 4,
        note: '加急处理',
        totalItems: 20,
      ),
    ];
  }

  /// 更新任务状态 - 需要后端API实现
  /// 
  /// 当用户完成任务时调用
  /// 
  /// 需要后端提供：
  /// - PUT /api/tasks/{id}/complete
  static Future<bool> completeTask(String taskId) async {
    // TODO: 实现后端API调用
    // 示例API端点: PUT /api/tasks/{id}/complete
    // 示例响应格式:
    // {
    //   "success": true,
    //   "message": "任务完成"
    // }
    
    // 模拟延迟加载
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 返回模拟结果 - 实际应从后端获取
    return true;
  }

  /// 获取任务详情 - 需要后端API实现
  /// 
  /// 当用户点击任务卡片查看详情时调用
  /// 
  /// 需要后端提供：
  /// - GET /api/tasks/{id}
  static Future<TaskItem?> getTaskDetail(String taskId) async {
    // TODO: 实现后端API调用
    // 示例API端点: GET /api/tasks/{id}
    // 示例响应格式:
    // {
    //   "task": {
    //     "id": "1",
    //     "consumableImage": "https://example.com/image1.png",
    //     "size": "大号",
    //     "quantity": 5,
    //     "note": "紧急处理",
    //     "totalItems": 25,
    //     "details": "更多详细信息..."
    //   }
    // }
    
    // 模拟延迟加载
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 返回模拟数据 - 实际应从后端获取
    return null;
  }
}