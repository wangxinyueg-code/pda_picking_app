import 'package:flutter/material.dart';
import '../feature/outbound_picking/page/pick_task_page.dart';

/// 出库模块路由映射
class WmsOutboundRouteMap {
  /// 拣货下架页面路由
  static const String outboundPicking = '/wms_outbound/outbound_picking';

  /// 路由表
  static final Map<String, WidgetBuilder> routes = {
    outboundPicking: (_) => const PickTaskPage(),
  };
}