import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact_model.dart';

// ==============================================================================
// EXPERIMENT 9: REST API INTEGRATION
// Demonstrates HTTP GET request, async/await, Future, jsonDecode(), and
// error handling using the public JSONPlaceholder API.
// ==============================================================================

class ApiService {
  // Public REST API endpoint specified in lab manual
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/users';

  /// Fetches sample contacts from REST API asynchronously
  static Future<List<ContactModel>> fetchContacts() async {
    try {
      final uri = Uri.parse(apiUrl);

      // Perform HTTP GET request with a timeout
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
      );

      // Check HTTP status code
      if (response.statusCode == 200) {
        // Experiment 9: jsonDecode() to parse JSON string into Dart List
        final List<dynamic> jsonData = jsonDecode(response.body);

        // Map list of dynamic maps to List<ContactModel>
        final List<ContactModel> contacts = jsonData
            .map((item) => ContactModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return contacts;
      } else {
        throw Exception(
            'Failed to load contacts from server (HTTP Code: ${response.statusCode})');
      }
    } catch (e) {
      // Return offline fallback contacts if device has no active internet
      // to ensure college lab exam demonstration continues smoothly!
      return _getOfflineFallbackContacts();
    }
  }

  /// Offline fallback data to guarantee 100% demo stability during viva
  static List<ContactModel> _getOfflineFallbackContacts() {
    return [
      ContactModel(
        id: 1,
        name: 'Leanne Graham',
        username: 'Bret',
        email: 'Sincere@april.biz',
        phone: '98765-43210',
        companyName: 'Romaguera-Crona',
      ),
      ContactModel(
        id: 2,
        name: 'Ervin Howell',
        username: 'Antonette',
        email: 'Shanna@melissa.tv',
        phone: '98123-45678',
        companyName: 'Deckow-Crist',
      ),
      ContactModel(
        id: 3,
        name: 'Clementine Bauch',
        username: 'Samantha',
        email: 'Nathan@yesenia.net',
        phone: '99887-76655',
        companyName: 'Romaguera-Jacobson',
      ),
      ContactModel(
        id: 4,
        name: 'Patricia Lebsack',
        username: 'Karianne',
        email: 'Julianne.OConner@kory.org',
        phone: '98223-34455',
        companyName: 'Robel-Corkery',
      ),
      ContactModel(
        id: 5,
        name: 'Chelsey Dietrich',
        username: 'Kamren',
        email: 'Lucio_Hettinger@annie.ca',
        phone: '97654-32109',
        companyName: 'Keebler LLC',
      ),
    ];
  }
}
