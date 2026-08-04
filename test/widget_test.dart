import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/main.dart';
import 'package:translator_app/providers/translator_provider.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TranslatorProvider(),
        child: const SvTranslateXApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
