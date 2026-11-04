import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import 'send_money_screen.dart';

// ==============================================================================
// EXPERIMENT 9: REST API INTEGRATION SCREEN (CONTACTS)
// Demonstrates HTTP GET request, async/await, Future, jsonDecode(),
// CircularProgressIndicator loading state, error handling with Retry,
// and ListView.builder().
// ==============================================================================

class ContactsScreen extends StatefulWidget {
  final bool isTab;
  final bool isSelectMode;

  const ContactsScreen({
    super.key,
    this.isTab = false,
    this.isSelectMode = false,
  });

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  // Experiment 9: Future holding async API data
  late Future<List<ContactModel>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      // Trigger HTTP GET request through ApiService
      _contactsFuture = ApiService.fetchContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if opened with selectMode argument from Send Money
    final isSelection = widget.isSelectMode ||
        (ModalRoute.of(context)?.settings.arguments == true);

    return Scaffold(
      appBar: AppBar(
        title: Text(isSelection ? 'Select Recipient' : 'Contacts (REST API)'),
        leading: widget.isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload API',
            onPressed: _loadContacts,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Experiment 9 Info Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentCyan.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentCyan.withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.api_rounded, color: AppTheme.primaryBlue, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Live users fetched via HTTP GET from jsonplaceholder.typicode.com/users',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Experiment 9: FutureBuilder for asynchronous API call
            Expanded(
              child: FutureBuilder<List<ContactModel>>(
                future: _contactsFuture,
                builder: (context, snapshot) {
                  // State 1: Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Fetching contacts from REST API...',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  // State 2: Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 56,
                              color: AppTheme.dangerRed,
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Failed to Load Contacts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _loadContacts,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry Request'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // State 3: Data Loaded Successfully
                  final contacts = snapshot.data ?? [];

                  if (contacts.isEmpty) {
                    return const Center(
                      child: Text('No contacts found from API.'),
                    );
                  }

                  // Experiment 9: ListView.builder
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          onTap: () {
                            if (isSelection) {
                              // Return selected contact back to SendMoneyScreen
                              Navigator.pop(context, contact);
                            } else {
                              // Open Send Money screen prefilled with this contact
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SendMoneyScreen(
                                    prefilledContact: contact,
                                  ),
                                ),
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor:
                                AppTheme.primaryBlue.withOpacity(0.12),
                            child: Text(
                              contact.name.isNotEmpty
                                  ? contact.name[0].toUpperCase()
                                  : 'C',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                contact.email,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Phone: ${contact.phone} • ${contact.companyName}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: isSelection
                              ? const Icon(Icons.arrow_forward_ios, size: 14)
                              : IconButton(
                                  icon: const Icon(Icons.send_rounded,
                                      color: AppTheme.primaryBlue),
                                  tooltip: 'Send Money to ${contact.name}',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SendMoneyScreen(
                                          prefilledContact: contact,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
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
}
