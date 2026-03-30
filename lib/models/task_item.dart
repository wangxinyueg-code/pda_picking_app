class TaskItem {
  final String orderLabel;
  final String materialSpec;
  final String remark;
  final int totalNumber;
  final String imagePath;

  const TaskItem({
    required this.orderLabel,
    required this.materialSpec,
    required this.remark,
    required this.totalNumber,
    this.imagePath = '',
  });
}