import 'package:flutter/material.dart';
import 'flutter_wms_outbound/router/wms_outbound_route_map.dart';

void main() {
  runApp(const PickingApp());
}

class PickingApp extends StatelessWidget {
  const PickingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDA 拣货下架',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
      ),
      initialRoute: WmsOutboundRouteMap.outboundPicking,
      routes: WmsOutboundRouteMap.routes,
    );
  }
}