import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/transaction_tile.dart';

// ==============================================================================
// SCREEN 7: TRANSACTION HISTORY SCREEN
// Demonstrates Experiment 5 (Provider + setState for filters), Experiment 2 (ListView),
// and Experiment 4 (Navigation and passing transaction object).
// ==============================================================================

class TransactionHistoryScreen extends StatefulWidget {
  final bool isTab;

  const TransactionHistoryScreen({super.key, this.isTab = false});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // Experiment 5: Local UI state using setState() for active filter selection
  int _selectedFilterIndex = 0; // 0 = All, 1 = Received, 2 = Sent

  @override
  Widget build(BuildContext context) {
    // Experiment 5: Provider listens to transaction list updates
    final walletProvider = Provider.of<WalletProvider>(context);

    // Filter transactions based on selected tab
    List<TransactionModel> displayTransactions;
    if (_selectedFilterIndex == 1) {
      displayTransactions = walletProvider.receivedTransactions;
    } else if (_selectedFilterIndex == 2) {
      displayTransactions = walletProvider.sentTransactions;
    } else {
      displayTransactions = walletProvider.transactions;
    }

    // Calculate total in & out for summary banner
    final totalIn = walletProvider.transactions
        .where((t) => t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalOut = walletProvider.transactions
        .where((t) => !t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: widget.isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Summary Banner: Inflow & Outflow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      // Total Received (Credit)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.arrow_downward,
                                    size: 14, color: AppTheme.successGreen),
                                SizedBox(width: 4),
                                Text(
                                  'Total Received',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '+₹${totalIn.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      // Total Sent (Debit)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.arrow_upward,
                                      size: 14, color: AppTheme.dangerRed),
                                  SizedBox(width: 4),
                                  Text(
                                    'Total Sent',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '-₹${totalOut.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.dangerRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Filter Tabs: All, Received, Sent (Experiment 5: setState)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Row(
                children: [
                  _buildFilterChip(0, 'All (${walletProvider.transactions.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                      1, 'Received (${walletProvider.receivedTransactions.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                      2, 'Sent (${walletProvider.sentTransactions.length})'),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Transactions List
            Expanded(
              child: displayTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No transactions found in this category',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      itemCount: displayTransactions.length,
                      itemBuilder: (context, index) {
                        final txn = displayTransactions[index];
                        return TransactionTile(
                          transaction: txn,
                          onTap: () {
                            // Experiment 4: Navigate and pass transaction model
                            Navigator.pushNamed(
                              context,
                              AppRoutes.transactionDetails,
                              arguments: txn,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Experiment 5: setState for local UI state changes
          setState(() {
            _selectedFilterIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryBlue
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryBlue
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}
