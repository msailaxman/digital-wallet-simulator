import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:digital_wallet_simulator/providers/theme_provider.dart';
import 'package:digital_wallet_simulator/providers/wallet_provider.dart';
import 'package:digital_wallet_simulator/screens/home_screen.dart';
import 'package:digital_wallet_simulator/screens/login_screen.dart';
import 'package:digital_wallet_simulator/screens/add_money_screen.dart';
import 'package:digital_wallet_simulator/widgets/wallet_balance_card.dart';

// ==============================================================================
// EXPERIMENT 10: TESTING AND DEBUGGING – WIDGET & INTEGRATION TESTS
// Tests widget rendering, form validation display, and balance update workflow.
// ==============================================================================

Widget createTestableWidget({
  required Widget child,
  WalletProvider? walletProvider,
  ThemeProvider? themeProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<WalletProvider>(
        create: (_) => walletProvider ?? WalletProvider(),
      ),
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => themeProvider ?? ThemeProvider(),
      ),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('Experiment 10 - Widget Tests', () {
    testWidgets('1. Verify WalletBalanceCard displays balance and action buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WalletBalanceCard(
              balance: 5000.0,
              walletId: 'DW-882190',
              onAddMoney: () {},
              onSendMoney: () {},
            ),
          ),
        ),
      );

      // Verify wallet balance in ₹ is visible
      expect(find.text('₹5000.00'), findsOneWidget);

      // Verify wallet ID is displayed
      expect(find.text('Wallet ID: DW-882190'), findsOneWidget);

      // Verify Add Money and Send Money buttons are present
      expect(find.text('Add Money'), findsOneWidget);
      expect(find.text('Send Money'), findsOneWidget);
    });

    testWidgets('2. Verify Home / Dashboard displays user greeting and quick actions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestableWidget(child: const HomeScreen()));
      await tester.pumpAndSettle();

      // Verify user greeting
      expect(find.text('Hello,'), findsOneWidget);

      // Verify Dashboard quick action buttons
      expect(find.text('Add Money'), findsWidgets);
      expect(find.text('Send Money'), findsWidgets);
      expect(find.text('History'), findsWidgets);
      expect(find.text('Contacts'), findsWidgets);

      // Verify Recent Transactions section title is visible
      expect(find.text('Recent Transactions'), findsOneWidget);
    });

    testWidgets('3. Verify Login Screen form validation displays error on empty submit',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestableWidget(child: const LoginScreen()));
      await tester.pumpAndSettle();

      // Verify Login Screen widgets
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // Tap Sign In button without entering credentials
      final signInFinder = find.text('Sign In');
      await tester.ensureVisible(signInFinder);
      await tester.tap(signInFinder);
      await tester.pumpAndSettle();

      // Verify validation error messages are displayed
      expect(find.text('Please enter your email or phone number'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('4. Verify Auto-Fill button populates demo credentials on Login Screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestableWidget(child: const LoginScreen()));
      await tester.pumpAndSettle();

      // Tap Auto-Fill
      final autoFillFinder = find.text('Auto-Fill');
      await tester.ensureVisible(autoFillFinder);
      await tester.tap(autoFillFinder);
      await tester.pumpAndSettle();

      // Verify fields have been populated (finds in info card and textfield)
      expect(find.text('student@btech.ac.in'), findsWidgets);
    });
  });

  group('Experiment 10 - Integration Flow Test', () {
    testWidgets('5. Add Money increases balance and updates state dynamically',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final wallet = WalletProvider();
      wallet.resetToDemoState(); // 5000.0

      await tester.pumpWidget(
        createTestableWidget(
          child: const AddMoneyScreen(),
          walletProvider: wallet,
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial balance on Add Money screen
      expect(find.text('₹5000.00'), findsOneWidget);

      // Tap '+₹1000' preset button
      final presetFinder = find.text('+₹1000');
      await tester.ensureVisible(presetFinder);
      await tester.tap(presetFinder);
      await tester.pumpAndSettle();

      // Ensure button is visible in scroll view before tapping
      final proceedButtonFinder = find.text('Proceed to Add Money');
      await tester.ensureVisible(proceedButtonFinder);
      await tester.pumpAndSettle();

      // Tap 'Proceed to Add Money'
      await tester.tap(proceedButtonFinder);

      // Allow simulated delay to complete
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Verify success dialog appears and balance updated to ₹6,000
      expect(find.text('Money Added Successfully!'), findsOneWidget);
      expect(wallet.balance, equals(6000.0));
    });
  });
}
