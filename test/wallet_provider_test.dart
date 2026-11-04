import 'package:flutter_test/flutter_test.dart';
import 'package:digital_wallet_simulator/providers/wallet_provider.dart';
import 'package:digital_wallet_simulator/models/transaction_model.dart';

// ==============================================================================
// EXPERIMENT 10: TESTING AND DEBUGGING – UNIT TESTS
// Tests core wallet logic: calculations, arithmetic, validations, and state updates.
// ==============================================================================

void main() {
  group('Experiment 10 - Wallet Provider Unit Tests', () {
    late WalletProvider walletProvider;

    setUp(() {
      walletProvider = WalletProvider();
      walletProvider.resetToDemoState(); // Starts with ₹5,000
    });

    test('Initial balance is initialized to ₹5,000.00', () {
      expect(walletProvider.balance, equals(5000.0));
      expect(walletProvider.calculateBalance(), equals(5000.0));
    });

    test('Add money increases wallet balance and records credit transaction', () {
      final initialBalance = walletProvider.balance;
      const addAmount = 1500.0;

      final success = walletProvider.addMoney(
        amount: addAmount,
        paymentMethod: 'UPI Simulator',
      );

      expect(success, isTrue);
      expect(walletProvider.balance, equals(initialBalance + addAmount));
      expect(walletProvider.transactions.first.amount, equals(addAmount));
      expect(walletProvider.transactions.first.type, equals(TransactionType.credit));
      expect(walletProvider.transactions.first.isCredit, isTrue);
    });

    test('Send money decreases wallet balance and records debit transaction', () {
      final initialBalance = walletProvider.balance;
      const sendAmount = 1200.0;

      final success = walletProvider.sendMoney(
        recipientName: 'Rahul Sharma',
        phoneNumber: '9876543210',
        amount: sendAmount,
        description: 'Semester notes payment',
      );

      expect(success, isTrue);
      expect(walletProvider.balance, equals(initialBalance - sendAmount));
      expect(walletProvider.transactions.first.amount, equals(sendAmount));
      expect(walletProvider.transactions.first.type, equals(TransactionType.debit));
      expect(walletProvider.transactions.first.isCredit, isFalse);
    });

    test('Send money fails when amount exceeds available balance (Insufficient balance)', () {
      final initialBalance = walletProvider.balance; // 5000
      final excessAmount = initialBalance + 500.0; // 5500

      final success = walletProvider.sendMoney(
        recipientName: 'Rahul Sharma',
        phoneNumber: '9876543210',
        amount: excessAmount,
      );

      expect(success, isFalse);
      // Balance remains unchanged
      expect(walletProvider.balance, equals(initialBalance));
    });

    test('Amount validation function detects null, empty, zero, and negative values', () {
      // Null or empty
      expect(walletProvider.validateAmount(null), isNotNull);
      expect(walletProvider.validateAmount(''), isNotNull);
      expect(walletProvider.validateAmount('   '), isNotNull);

      // Non-numeric
      expect(walletProvider.validateAmount('abc'), isNotNull);

      // Zero and negative
      expect(walletProvider.validateAmount('0'), isNotNull);
      expect(walletProvider.validateAmount('-50'), isNotNull);

      // Valid positive amount
      expect(walletProvider.validateAmount('250.50'), isNull);
    });

    test('Amount validation function checks against available balance when requested', () {
      // ₹6,000 exceeds ₹5,000 balance
      final error = walletProvider.validateAmount('6000', checkAvailableBalance: true);
      expect(error, contains('Insufficient balance'));

      // ₹2,000 is within ₹5,000 balance
      final valid = walletProvider.validateAmount('2000', checkAvailableBalance: true);
      expect(valid, isNull);
    });

    test('generateTransactionId produces valid formatted ID string', () {
      final id = walletProvider.generateTransactionId();
      expect(id, startsWith('TXN-'));
      expect(id.length, greaterThan(12));
    });
  });
}
