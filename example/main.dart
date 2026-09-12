import 'package:flutter/material.dart';
import 'package:device_unique_id/device_unique_id.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DemoPage());
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  DeviceIdentity? _identity;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final identity = await DeviceUniqueId.getDeviceIdentity();
      setState(() => _identity = identity);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('device_unique_id demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _error != null
            ? Text('Error: $_error')
            : _identity == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Persistent ID:\n${_identity!.persistentId}'),
                      const SizedBox(height: 12),
                      Text('Android ID: ${_identity!.androidId ?? "n/a (iOS)"}'),
                      const SizedBox(height: 12),
                      Text('identifierForVendor: ${_identity!.identifierForVendor ?? "n/a (Android)"}'),
                    ],
                  ),
      ),
    );
  }
}
