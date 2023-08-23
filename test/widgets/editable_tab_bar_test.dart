import 'package:elastic_dashboard/widgets/dashboard_grid.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_text_input.dart';
import 'package:elastic_dashboard/widgets/editable_tab_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_util.dart';
import 'editable_tab_bar_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FakeTabBarFunctions>()])
class FakeTabBarFunctions {
  void onTabCreate() {}

  void onTabDestroy() {}

  void onTabRename() {}

  void onTabChanged() {}
}

void main() {
  late MockFakeTabBarFunctions tabBarFunctions;

  setUp(() {
    tabBarFunctions = MockFakeTabBarFunctions();
  });

  testWidgets('Editable tab bar', (widgetTester) async {
    FlutterError.onError = ignoreOverflowErrors;

    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditableTabBar(
            currentIndex: 0,
            tabData: [
              TabData(name: 'Teleoperated'),
              TabData(name: 'Autonomous'),
            ],
            tabViews: [
              DashboardGrid(),
              DashboardGrid(),
            ],
            onTabCreate: (tab, grid) {},
            onTabDestroy: (tab, grid) {},
            onTabRename: (tab, grid) {},
            onTabChanged: (index) {},
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(
        find.widgetWithText(AnimatedContainer, 'Teleoperated'), findsOneWidget);
    expect(
        find.widgetWithText(AnimatedContainer, 'Autonomous'), findsOneWidget);

    expect(find.byIcon(Icons.close), findsNWidgets(2));
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Open new tab', (widgetTester) async {
    FlutterError.onError = ignoreOverflowErrors;

    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditableTabBar(
            currentIndex: 0,
            tabData: [
              TabData(name: 'Teleoperated'),
              TabData(name: 'Autonomous'),
            ],
            tabViews: [
              DashboardGrid(),
              DashboardGrid(),
            ],
            onTabCreate: (tab, grid) {
              tabBarFunctions.onTabCreate();
            },
            onTabDestroy: (tab, grid) {
              tabBarFunctions.onTabDestroy();
            },
            onTabRename: (tab, grid) {
              tabBarFunctions.onTabRename();
            },
            onTabChanged: (index) {
              tabBarFunctions.onTabChanged();
            },
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    final newTabButton = find.byIcon(Icons.add);

    expect(newTabButton, findsOneWidget);

    await widgetTester.tap(newTabButton);
    await widgetTester.pumpAndSettle();

    verify(tabBarFunctions.onTabCreate()).called(1);
  });

  testWidgets('Close tab', (widgetTester) async {
    FlutterError.onError = ignoreOverflowErrors;

    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditableTabBar(
            currentIndex: 0,
            tabData: [
              TabData(name: 'Teleoperated'),
              TabData(name: 'Autonomous'),
            ],
            tabViews: [
              DashboardGrid(),
              DashboardGrid(),
            ],
            onTabCreate: (tab, grid) {
              tabBarFunctions.onTabCreate();
            },
            onTabDestroy: (tab, grid) {
              tabBarFunctions.onTabDestroy();
            },
            onTabRename: (tab, grid) {
              tabBarFunctions.onTabRename();
            },
            onTabChanged: (index) {
              tabBarFunctions.onTabChanged();
            },
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    final closeTabButton = find.byIcon(Icons.close).first;

    expect(closeTabButton, findsOneWidget);

    await widgetTester.tap(closeTabButton);
    await widgetTester.pumpAndSettle();

    expect(find.text('Confirm Tab Close', skipOffstage: false), findsOneWidget);

    final confirmButton =
        find.widgetWithText(TextButton, 'OK', skipOffstage: false);

    expect(confirmButton, findsOneWidget);

    await widgetTester.tap(confirmButton);
    await widgetTester.pumpAndSettle();

    verify(tabBarFunctions.onTabDestroy()).called(1);
  });

  testWidgets('Rename tab', (widgetTester) async {
    FlutterError.onError = ignoreOverflowErrors;

    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditableTabBar(
            currentIndex: 0,
            tabData: [
              TabData(name: 'Teleoperated'),
              TabData(name: 'Autonomous'),
            ],
            tabViews: [
              DashboardGrid(),
              DashboardGrid(),
            ],
            onTabCreate: (tab, grid) {
              tabBarFunctions.onTabCreate();
            },
            onTabDestroy: (tab, grid) {
              tabBarFunctions.onTabDestroy();
            },
            onTabRename: (tab, grid) {
              tabBarFunctions.onTabRename();
            },
            onTabChanged: (index) {
              tabBarFunctions.onTabChanged();
            },
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    final teleopTab = find.widgetWithText(AnimatedContainer, 'Teleoperated');

    expect(teleopTab, findsOneWidget);

    await widgetTester.tap(teleopTab, buttons: kSecondaryButton);
    await widgetTester.pumpAndSettle();

    final renameButton =
        find.widgetWithText(ListTile, 'Rename', skipOffstage: false);

    expect(renameButton, findsOneWidget);

    await widgetTester.tap(renameButton);
    await widgetTester.pumpAndSettle();

    expect(find.text('Rename Tab', skipOffstage: false), findsOneWidget);

    final nameTextField = find.widgetWithText(DialogTextInput, 'Name');

    expect(nameTextField, findsOneWidget);

    await widgetTester.enterText(nameTextField, 'New Tab Name!');
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    await widgetTester.pump();

    final saveButton = find.widgetWithText(TextButton, 'Save');

    expect(saveButton, findsOneWidget);

    await widgetTester.tap(saveButton);
    await widgetTester.pumpAndSettle();

    verify(tabBarFunctions.onTabRename()).called(greaterThanOrEqualTo(1));
  });

  testWidgets('Change tab', (widgetTester) async {
    FlutterError.onError = ignoreOverflowErrors;

    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditableTabBar(
            currentIndex: 0,
            tabData: [
              TabData(name: 'Teleoperated'),
              TabData(name: 'Autonomous'),
            ],
            tabViews: [
              DashboardGrid(),
              DashboardGrid(),
            ],
            onTabCreate: (tab, grid) {
              tabBarFunctions.onTabCreate();
            },
            onTabDestroy: (tab, grid) {
              tabBarFunctions.onTabDestroy();
            },
            onTabRename: (tab, grid) {
              tabBarFunctions.onTabRename();
            },
            onTabChanged: (index) {
              tabBarFunctions.onTabChanged();
            },
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    final autonomousTab = find.widgetWithText(AnimatedContainer, 'Autonomous');

    expect(autonomousTab, findsOneWidget);

    await widgetTester.tap(autonomousTab);
    await widgetTester.pumpAndSettle();

    verify(tabBarFunctions.onTabChanged()).called(1);
  });
}