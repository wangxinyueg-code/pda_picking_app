import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PickTaskPage extends StatefulWidget {
  const PickTaskPage({super.key});

  @override
  State<PickTaskPage> createState() => _PickTaskPageState();
}

class _PickTaskPageState extends State<PickTaskPage> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _error;

  Future<String> _loadAsset(String path) async {
    final data = await rootBundle.load(path);
    return utf8.decode(data.buffer.asUint8List());
  }

  Future<String> _buildPageDataUrl() async {
    final html = await _loadAsset('index.html');
    final css = await _loadAsset('styles.css');
    final js = await _loadAsset('script.js');

    final bodyContent =
        RegExp(
          r'<body[^>]*>([\\s\\S]*?)</body>',
          caseSensitive: false,
        ).firstMatch(html)?.group(1) ??
        '';

    final merged =
        '''
<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<style>
$css
</style>
</head>
<body>
$bodyContent
<script>
$js
</script>
</body>
</html>
''';

    final encoded = base64Encode(utf8.encode(merged));
    return 'data:text/html;base64,$encoded';
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final dataUrl = await _buildPageDataUrl();
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(dataUrl));
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = '加载页面失败: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!_loading && _error == null)
            WebViewWidget(controller: _controller)
          else
            const SizedBox.shrink(),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ),
        ],
      ),
    );
  }
}
