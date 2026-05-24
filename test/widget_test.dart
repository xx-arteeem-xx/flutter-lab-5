import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_lab_5/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<App> buildApp(WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final app = App(prefs: prefs);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    return app;
  }

  testWidgets('app renders without errors', (tester) async {
    await buildApp(tester);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('two tabs present in BottomNavigationBar', (tester) async {
    await buildApp(tester);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('События'), findsOneWidget);
    expect(find.text('Статистика'), findsOneWidget);
  });

  testWidgets('FAB is visible on Events tab', (tester) async {
    await buildApp(tester);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('FAB is hidden on Statistics tab', (tester) async {
    await buildApp(tester);
    await tester.tap(find.text('Статистика'));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('AppBar contains theme toggle button', (tester) async {
    await buildApp(tester);
    expect(
      find.byWidgetPredicate((w) =>
          w is IconButton &&
          (w.tooltip == 'Светлая тема' || w.tooltip == 'Тёмная тема')),
      findsOneWidget,
    );
  });

  testWidgets('AppBar contains About info icon', (tester) async {
    await buildApp(tester);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });

  testWidgets('Sort button visible on Events tab', (tester) async {
    await buildApp(tester);
    expect(find.byIcon(Icons.sort_rounded), findsOneWidget);
  });

  testWidgets('Sort button hidden on Statistics tab', (tester) async {
    await buildApp(tester);
    await tester.tap(find.text('Статистика'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.sort_rounded), findsNothing);
  });

  testWidgets('Events tab shows initial events', (tester) async {
    await buildApp(tester);
    // At least one initial event title should be visible in the grid
    expect(find.text('Лекция по Flutter'), findsOneWidget);
  });

  testWidgets('Statistics tab shows all category names', (tester) async {
    await buildApp(tester);
    await tester.tap(find.text('Статистика'));
    await tester.pumpAndSettle();
    expect(find.text('Учёба'), findsOneWidget);
    expect(find.text('Спорт'), findsOneWidget);
    expect(find.text('Развлечения'), findsOneWidget);
    expect(find.text('Работа'), findsOneWidget);
    expect(find.text('Личное'), findsOneWidget);
  });

  testWidgets('tapping info icon opens About screen', (tester) async {
    await buildApp(tester);
    await tester.tap(find.byIcon(Icons.info_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.text('О приложении'), findsWidgets);
  });

  testWidgets('FAB tap opens BottomSheet form', (tester) async {
    await buildApp(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Новое событие'), findsOneWidget);
  });

  testWidgets('theme toggle switches theme', (tester) async {
    await buildApp(tester);
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final initialMode = materialApp.themeMode;

    final toggleBtn = find.byWidgetPredicate((w) =>
        w is IconButton &&
        (w.tooltip == 'Светлая тема' || w.tooltip == 'Тёмная тема'));
    await tester.tap(toggleBtn);
    await tester.pumpAndSettle();

    final updatedApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(updatedApp.themeMode, isNot(equals(initialMode)));
  });
}
