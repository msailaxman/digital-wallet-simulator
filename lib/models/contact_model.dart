// ==============================================================================
// EXPERIMENT 9: REST API INTEGRATION & DART JSON PARSING
// Model representing external user contact fetched from JSONPlaceholder API.
// ==============================================================================

class ContactModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String companyName;

  ContactModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.companyName,
  });

  // Factory constructor to parse JSON response from REST API
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown Contact',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      companyName: json['company'] != null
          ? (json['company']['name'] as String? ?? '')
          : '',
    );
  }
}
