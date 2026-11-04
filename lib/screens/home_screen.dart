import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/dashboard_action_button.dart';
import '../widgets/section_title.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/wallet_balance_card.dart';

// Screens for bottom navigation tabs
import 'contacts_screen.dart';
import 'profile_screen.dart';
import 'transaction_history_screen.dart';

// ==============================================================================
// SCREEN 4: HOME / DASHBOARD SCREEN
// Demonstrates Experiment 2 (Flutter Widgets & Layouts: Row, Column, Container,
// Card, Stack, Icon, Text, ElevatedButton), Experiment 3 (Responsive UI),
// Experiment 4 (Navigation), and Experiment 5 (Provider State Management).
// ==============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Experiment 5: Local UI state for bottom navigation index
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of tab views for bottom navigation bar
    final List<Widget> pages = [
      const _DashboardTabView(),
      const TransactionHistoryScreen(isTab: true),
      const ContactsScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),
            selectedIcon: Icon(Icons.contacts_rounded),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------------------
// SUB-VIEW: DASHBOARD TAB CONTENT
// ------------------------------------------------------------------------------
class _DashboardTabView extends StatelessWidget {
  const _DashboardTabView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Experiment 5: Provider.of / Consumer - listens for wallet updates automatically
    final walletProvider = Provider.of<WalletProvider>(context);
    final user = walletProvider.user;
    final balance = walletProvider.balance;
    final recentTransactions = walletProvider.recentTransactions;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.15),
              child: const Icon(
                Icons.person,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello,',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          // Profile quick view button
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications. All systems normal.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate pull to refresh
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Experiment 6: Reusable WalletBalanceCard widget
                WalletBalanceCard(
                  balance: balance,
                  walletId: user.walletId,
                  onAddMoney: () {
                    Navigator.pushNamed(context, AppRoutes.addMoney);
                  },
                  onSendMoney: () {
                    Navigator.pushNamed(context, AppRoutes.sendMoney);
                  },
                ),

                const SizedBox(height: 20),

                // Quick Action Buttons Grid (Experiment 2: Row & Card)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DashboardActionButton(
                          icon: Icons.add_circle,
                          label: 'Add Money',
                          color: AppTheme.primaryBlue,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.addMoney);
                          },
                        ),
                        DashboardActionButton(
                          icon: Icons.send_rounded,
                          label: 'Send Money',
                          color: AppTheme.accentCyan,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.sendMoney);
                          },
                        ),
                        DashboardActionButton(
                          icon: Icons.history_rounded,
                          label: 'History',
                          color: AppTheme.warningAmber,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.transactions);
                          },
                        ),
                        DashboardActionButton(
                          icon: Icons.people_alt_rounded,
                          label: 'Contacts',
                          color: AppTheme.successGreen,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.contacts);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Experiment 9 Notice Banner (REST API demonstration card)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cloud_sync_outlined,
                        color: AppTheme.primaryBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Experiment 9: REST API Integration',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            Text(
                              'Tap "Contacts" to fetch live users from jsonplaceholder API',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.contacts);
                        },
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Recent Transactions Section Header
                SectionTitle(
                  title: 'Recent Transactions',
                  actionText: 'View All',
                  onActionPressed: () {
                    Navigator.pushNamed(context, AppRoutes.transactions);
                  },
                ),

                // Recent Transactions List
                if (recentTransactions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            size: 48,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No transactions recorded yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    itemBuilder: (context, index) {
                      final txn = recentTransactions[index];
                      // Experiment 6: TransactionTile custom widget
                      return TransactionTile(
                        transaction: txn,
                        onTap: () {
                          // Experiment 4: Navigate and pass transaction data
                          Navigator.pushNamed(
                            context,
                            AppRoutes.transactionDetails,
                            arguments: txn,
                          );
                        },
                      );
                    },
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
