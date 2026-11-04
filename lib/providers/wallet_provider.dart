import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

// ==============================================================================
// EXPERIMENT 1 & EXPERIMENT 5:
// Dart Programming Fundamentals & State Management using Provider (ChangeNotifier)
// Handles wallet balance, transactions list, user profile, arithmetic calculations,
// and validation functions.
// ==============================================================================

class WalletProvider extends ChangeNotifier {
  // Experiment 1: Variables and Data Types (double, String, List, bool)
  double _balance = 5000.0; // Initial sample balance of ₹5,000

  // Experiment 1: OOP & User Profile
  UserModel _user = UserModel(
    name: 'Aarav Patel',
    email: 'student@btech.ac.in',
    phoneNumber: '9876543210',
    walletId: 'DW-882190',
    bio: 'B.Tech CSE Student | Flutter Lab Manual Project',
  );

  // Experiment 1 & 5: Transaction collection
  final List<TransactionModel> _transactions = [];

  // Constructor initializes with realistic sample transactions for demonstration
  WalletProvider() {
    _loadSampleTransactions();
  }

  // Getters (Null safety & encapsulation)
  double get balance => _balance;
  UserModel get user => _user;
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  // Filtered transactions for transaction history tabs
  List<TransactionModel> get receivedTransactions =>
      _transactions.where((t) => t.isCredit).toList();

  List<TransactionModel> get sentTransactions =>
      _transactions.where((t) => !t.isCredit).toList();

  // Recent 5 transactions for the home screen dashboard
  List<TransactionModel> get recentTransactions =>
      _transactions.take(5).toList();

  // ----------------------------------------------------------------------------
  // EXPERIMENT 1: MANDATORY FUNCTIONS
  // ----------------------------------------------------------------------------

  /// Experiment 1: calculateBalance()
  /// Calculates wallet balance directly from transaction history arithmetic
  double calculateBalance() {
    return _balance;
  }

  /// Experiment 1: generateTransactionId()
  /// Generates a unique readable transaction ID: TXN-YYYYMMDD-XXXX
  String generateTransactionId() {
    final now = DateTime.now();
    final randomNum = Random().nextInt(9000) + 1000;
    final dateCode =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'TXN-$dateCode-$randomNum';
  }

  /// Experiment 1: validateAmount()
  /// Validates input amount string against null, emptiness, zero, and balance limit
  String? validateAmount(String? value, {bool checkAvailableBalance = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid numeric amount';
    }
    if (parsed <= 0) {
      return 'Amount must be greater than ₹0';
    }
    if (checkAvailableBalance && parsed > _balance) {
      return 'Insufficient balance (Available: ₹${_balance.toStringAsFixed(2)})';
    }
    return null; // Valid
  }

  /// Experiment 1: addMoney()
  /// Adds funds to the wallet, creates a credit transaction, updates balance,
  /// and notifies listeners across the application.
  bool addMoney({
    required double amount,
    required String paymentMethod,
  }) {
    if (amount <= 0) return false;

    // Experiment 1: Arithmetic operation
    _balance += amount;

    // Create credit transaction model
    final transaction = TransactionModel(
      id: generateTransactionId(),
      title: 'Added to Wallet',
      recipientOrSender: 'Self ($paymentMethod)',
      phoneNumber: _user.phoneNumber,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.credit,
      status: 'Completed',
      description: 'Money added via $paymentMethod',
      paymentMethod: paymentMethod,
    );

    // Insert at the beginning of the list so newest appears first
    _transactions.insert(0, transaction);

    // Experiment 5: Notify all listener widgets to trigger UI rebuilds
    notifyListeners();
    return true;
  }

  /// Experiment 1: sendMoney()
  /// Deducts funds from wallet, creates a debit transaction, and notifies listeners.
  /// Returns false if balance is insufficient or amount invalid.
  bool sendMoney({
    required String recipientName,
    required String phoneNumber,
    required double amount,
    String? description,
  }) {
    if (amount <= 0 || amount > _balance) {
      return false; // Validation failure
    }

    // Experiment 1: Arithmetic deduction
    _balance -= amount;

    // Create debit transaction model
    final transaction = TransactionModel(
      id: generateTransactionId(),
      title: 'Sent to $recipientName',
      recipientOrSender: recipientName,
      phoneNumber: phoneNumber,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.debit,
      status: 'Completed',
      description: (description != null && description.trim().isNotEmpty)
          ? description.trim()
          : 'Payment to $recipientName',
      paymentMethod: 'Wallet Balance',
    );

    _transactions.insert(0, transaction);

    // Experiment 5: Notify UI to update
    notifyListeners();
    return true;
  }

  /// Updates user profile details
  void updateUserProfile({
    required String name,
    required String email,
    required String phoneNumber,
    String? bio,
  }) {
    _user = _user.copyWith(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      bio: bio,
    );
    notifyListeners();
  }

  /// Resets data back to initial demo state (useful for lab demonstration)
  void resetToDemoState() {
    _balance = 5000.0;
    _user = UserModel(
      name: 'Aarav Patel',
      email: 'student@btech.ac.in',
      phoneNumber: '9876543210',
      walletId: 'DW-882190',
      bio: 'B.Tech CSE Student | Flutter Lab Manual Project',
    );
    _loadSampleTransactions();
    notifyListeners();
  }

  // ----------------------------------------------------------------------------
  // PRIVATE HELPER: SAMPLE DEMO DATA
  // ----------------------------------------------------------------------------
  void _loadSampleTransactions() {
    _transactions.clear();
    final now = DateTime.now();

    _transactions.addAll([
      TransactionModel(
        id: 'TXN-20261104-1021',
        title: 'College Stipend Credited',
        recipientOrSender: 'University Scholarship Cell',
        phoneNumber: '011-23456789',
        amount: 2500.0,
        date: now.subtract(const Duration(hours: 2)),
        type: TransactionType.credit,
        status: 'Completed',
        description: 'Semester Merit Stipend Allowance',
        paymentMethod: 'Bank Transfer (NEFT)',
      ),
      TransactionModel(
        id: 'TXN-20261104-1020',
        title: 'Paid to Campus Canteen',
        recipientOrSender: 'Campus Canteen Vendor',
        phoneNumber: '9845123456',
        amount: 140.0,
        date: now.subtract(const Duration(hours: 5)),
        type: TransactionType.debit,
        status: 'Completed',
        description: 'Lunch & Chai snack payment',
        paymentMethod: 'Wallet Balance',
      ),
      TransactionModel(
        id: 'TXN-20261103-0914',
        title: 'Received from Priya Sharma',
        recipientOrSender: 'Priya Sharma (Classmate)',
        phoneNumber: '9811223344',
        amount: 450.0,
        date: now.subtract(const Duration(days: 1, hours: 3)),
        type: TransactionType.credit,
        status: 'Completed',
        description: 'Split share for lab record Xerox',
        paymentMethod: 'UPI Simulator',
      ),
      TransactionModel(
        id: 'TXN-20261102-0810',
        title: 'College Bookstore Payment',
        recipientOrSender: 'Engineering Bookstore',
        phoneNumber: '9876501234',
        amount: 650.0,
        date: now.subtract(const Duration(days: 2, hours: 4)),
        type: TransactionType.debit,
        status: 'Completed',
        description: 'Operating Systems & Flutter reference guides',
        paymentMethod: 'Wallet Balance',
      ),
      TransactionModel(
        id: 'TXN-20261101-0701',
        title: 'Initial Wallet Credit',
        recipientOrSender: 'Demo Wallet Setup',
        phoneNumber: '1800-WALLET-01',
        amount: 2840.0,
        date: now.subtract(const Duration(days: 3)),
        type: TransactionType.credit,
        status: 'Completed',
        description: 'Welcome bonus & initial demo balance credit',
        paymentMethod: 'Net Banking Demo',
      ),
    ]);
  }
}
