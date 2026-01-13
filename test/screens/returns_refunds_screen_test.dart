import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/screens/settings/returns_refunds_screen.dart';

void main() {
  group('ReturnsRefundsScreen Widget Tests', () {
    // Use a larger screen size for bottom sheet tests to prevent overflow
    const testScreenSize = Size(640, 900);

    Widget createTestWidget() {
      return const ProviderScope(
        child: MaterialApp(home: ReturnsRefundsScreen()),
      );
    }

    void setupScreenSize(WidgetTester tester) {
      tester.view.physicalSize = testScreenSize;
      tester.view.devicePixelRatio = 1.0;
    }

    testWidgets('should render screen with app bar', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Returns & Refunds'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display info card', (WidgetTester tester) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Easy Returns'), findsOneWidget);
      expect(find.text('30-day free returns on all orders'), findsOneWidget);
      expect(find.byIcon(Icons.assignment_return), findsOneWidget);
    });

    testWidgets('should display quick action buttons', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('New Return'), findsOneWidget);
      expect(find.text('Return Policy'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.policy_outlined), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });

    testWidgets('should display Your Returns section', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Your Returns'), findsOneWidget);
    });

    testWidgets('should display return request cards', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Nike Air Max 270'), findsOneWidget);
      expect(find.text('Wireless Headphones'), findsOneWidget);
      expect(find.text('Classic T-Shirt'), findsOneWidget);
    });

    testWidgets('should display status chips for returns', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Processing'), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);
      expect(find.text('Refunded'), findsOneWidget);
    });

    testWidgets('should display View Details buttons', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('View Details'), findsNWidgets(3));
    });

    testWidgets('should open new return sheet when New Return is tapped', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('New Return'));
      await tester.pumpAndSettle();

      expect(find.text('Request a Return'), findsOneWidget);
      expect(find.text('Order ID'), findsOneWidget);
      expect(find.text('Reason for return'), findsOneWidget);
      expect(find.text('Submit Return Request'), findsOneWidget);
    });

    testWidgets('should display reason chips in new return sheet', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('New Return'));
      await tester.pumpAndSettle();

      expect(find.text('Wrong size'), findsOneWidget);
      expect(find.text('Wrong item delivered'), findsOneWidget);
      expect(find.text('Defective product'), findsOneWidget);
      expect(find.text('Changed mind'), findsOneWidget);
      expect(find.text('Product not as described'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets(
      'should open return policy sheet when Return Policy is tapped',
      (WidgetTester tester) async {
        setupScreenSize(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Return Policy'));
        await tester.pumpAndSettle();

        expect(find.text('Return Policy'), findsNWidgets(2));
      },
    );

    testWidgets('should open help sheet when Help is tapped', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Help'));
      await tester.pumpAndSettle();

      expect(find.text('Need Help?'), findsOneWidget);
      expect(find.text('Live Chat'), findsOneWidget);
      expect(find.text('Email Support'), findsOneWidget);
      expect(find.text('Call Us'), findsOneWidget);
    });

    testWidgets('should show return details when View Details is tapped', (
      WidgetTester tester,
    ) async {
      setupScreenSize(tester);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Details').first);
      await tester.pumpAndSettle();

      expect(find.text('Return Details'), findsOneWidget);
      expect(find.text('Return ID'), findsOneWidget);
      expect(find.text('Order ID'), findsOneWidget);
      expect(find.text('Product'), findsOneWidget);
      expect(find.text('Reason'), findsOneWidget);
      expect(find.text('Request Date'), findsOneWidget);
      expect(find.text('Refund Amount'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
    });
  });

  group('ReturnRequest Model', () {
    test('should create return request with all fields', () {
      final request = ReturnRequest(
        id: 'RET-TEST-1',
        orderId: 'ORD-TEST-1',
        productName: 'Test Product',
        productImage: 'https://example.com/image.jpg',
        refundAmount: 99.99,
        status: 'Processing',
        requestDate: DateTime(2025, 1, 10),
        reason: 'Wrong size',
      );

      expect(request.id, 'RET-TEST-1');
      expect(request.orderId, 'ORD-TEST-1');
      expect(request.productName, 'Test Product');
      expect(request.productImage, 'https://example.com/image.jpg');
      expect(request.refundAmount, 99.99);
      expect(request.status, 'Processing');
      expect(request.requestDate, DateTime(2025, 1, 10));
      expect(request.reason, 'Wrong size');
    });
  });

  group('returnRequestsProvider', () {
    test('should provide list of return requests', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final returns = container.read(returnRequestsProvider);

      expect(returns, isNotEmpty);
      expect(returns.length, 3);
    });

    test('should have valid return request data', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final returns = container.read(returnRequestsProvider);

      for (final request in returns) {
        expect(request.id, isNotEmpty);
        expect(request.orderId, isNotEmpty);
        expect(request.productName, isNotEmpty);
        expect(request.refundAmount, greaterThan(0));
        expect(request.status, isNotEmpty);
        expect(request.reason, isNotEmpty);
      }
    });
  });
}
