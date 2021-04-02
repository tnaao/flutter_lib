import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nati/nati.dart';

void main() {
  const MethodChannel channel = MethodChannel('nati');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Nati.platformVersion, '42');
  });
}
