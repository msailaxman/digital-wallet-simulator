// ==============================================================================
// EXPERIMENT 1: DART PROGRAMMING FUNDAMENTALS (OOP, Enums, Null Safety)
// This model class defines a transaction entity in our Digital Wallet.
// ==============================================================================

enum TransactionType {
  credit, // Money added to wallet (Received)
  debit,  // Money transferred out of wallet (Sent)
}

class TransactionModel {
  final String id;
  final String title;
  final String recipientOrSender;
  final String phoneNumber;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String status;
  final String description;
  final String paymentMethod;

  // Constructor with required and optional null-safe parameters
  TransactionModel({
    required this.id,
    required this.title,
    required this.recipientOrSender,
    required this.phoneNumber,
    required this.amount,
    required this.date,
    required this.type,
    this.status = 'Completed',
    this.description = 'Wallet Transaction',
    this.paymentMethod = 'Wallet Balance',
  });

  // Getter to check if transaction is credit (Received)
  bool get isCredit => type == TransactionType.credit;

  // Formatted date string for display without heavy third-party packages
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }

  // Formatted time string
  String get formattedTime {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Formatted currency with sign (₹)
  String get formattedAmountWithSign {
    final sign = isCredit ? '+₹' : '-₹';
    return '$sign${amount.toStringAsFixed(2)}';
  }
}
