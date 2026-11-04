# Digital Wallet Simulator – Flutter Mobile Application

A clean, modern, beginner-to-intermediate level Android mobile application developed in **Flutter & Dart** demonstrating the core concepts taught in **B.Tech Flutter UI Design Lab (Experiments 1–10)**.

---

## 📱 Project Overview

The **Digital Wallet Simulator** simulates core digital payment operations locally without requiring real banking integrations or payment gateways:
- User Authentication (Login & Registration with validation + demo auto-fill for viva)
- Real-time Wallet Balance tracking in Indian Rupees (**₹**)
- Add Money (with preset chips: ₹100, ₹500, ₹1000, ₹2000, and simulated payment modes)
- Send Money (with recipient verification, balance checking, and confirmation dialog)
- Animated Payment Success screen
- Complete Transaction History with filter tabs (**All**, **Received**, **Sent**)
- Detailed Transaction Receipt with copyable Transaction ID
- User Profile management with interactive editing
- Dynamic Theme Switcher (**Light Mode** and **Dark Mode** via Provider)
- REST API Integration fetching live contacts from `jsonplaceholder.typicode.com/users`
- Unit, Widget, and Integration tests using `flutter_test`

---

## 🧪 Flutter Lab Manual Experiments (1–10) Mapping

| Experiment | Concept | Implementation in this Project | Key Code Reference |
| :--- | :--- | :--- | :--- |
| **Exp 1** | **Dart Fundamentals & OOP** | Data types, arithmetic operations, class models, functions: `addMoney()`, `sendMoney()`, `calculateBalance()`, `validateAmount()`, `generateTransactionId()`, null safety | `lib/models/transaction_model.dart`<br>`lib/providers/wallet_provider.dart` |
| **Exp 2** | **Widgets & Layouts** | `Text`, `Icon`, `Container`, `Card`, `Row`, `Column`, `Stack`, `ElevatedButton`, `Scaffold`, `AppBar`, `FittedBox` | `lib/screens/home_screen.dart`<br>`lib/widgets/wallet_balance_card.dart` |
| **Exp 3** | **Responsive UI** | `MediaQuery` for screen sizing, `Expanded` and `Flexible` preventing overflow, `SafeArea`, `Wrap` for adaptive buttons | `lib/widgets/wallet_balance_card.dart`<br>`lib/screens/login_screen.dart` |
| **Exp 4** | **Navigation** | `Navigator.push`, `Navigator.pop`, `Navigator.pushNamed`, `Navigator.pushReplacementNamed`, data arguments passing | `lib/utils/app_routes.dart`<br>`lib/main.dart`<br>`lib/screens/splash_screen.dart` |
| **Exp 5** | **State Management** | `Provider` with `ChangeNotifier` for application-wide reactive state (`WalletProvider`, `ThemeProvider`). `setState()` for local widget state (filters, password visibility, animation triggers) | `lib/providers/wallet_provider.dart`<br>`lib/providers/theme_provider.dart` |
| **Exp 6** | **Custom Widgets & Themes** | Reusable components (`WalletBalanceCard`, `CustomButton`, `CustomTextField`, `TransactionTile`, `DashboardActionButton`, `SectionTitle`). Consistent `ThemeData` for Light and Dark modes | `lib/widgets/`<br>`lib/utils/app_theme.dart` |
| **Exp 7** | **Forms & Validation** | `Form`, `TextFormField`, `TextEditingController`, `GlobalKey<FormState>`, custom validators for email, 10-digit phone, password length, and available balance | `lib/screens/login_screen.dart`<br>`lib/screens/register_screen.dart`<br>`lib/screens/send_money_screen.dart` |
| **Exp 8** | **Flutter Animations** | `AnimatedOpacity` for splash fade-in, `AnimatedScale` for checkmark success, `AnimatedContainer` for balance and preset buttons | `lib/screens/splash_screen.dart`<br>`lib/screens/payment_success_screen.dart` |
| **Exp 9** | **REST API Integration** | HTTP GET requests via `http` package, `jsonDecode()`, `async/await`, `FutureBuilder`, loading spinner, error handling with Retry, live API from `jsonplaceholder.typicode.com/users` | `lib/services/api_service.dart`<br>`lib/screens/contacts_screen.dart` |
| **Exp 10** | **Testing & Debugging** | Comprehensive unit tests for balance calculation, widget tests for UI elements, and full integration flow test | `test/wallet_provider_test.dart`<br>`test/widget_test.dart` |

---

## 📂 Project Structure

```
digital_wallet_simulator/
├── lib/
│   ├── main.dart                          # App entry point, MultiProvider & MaterialApp routes
│   ├── models/
│   │   ├── contact_model.dart             # Exp 9: REST API contact entity (json parsing)
│   │   ├── transaction_model.dart         # Exp 1: Transaction model with formatted getters
│   │   └── user_model.dart                # Exp 1: User profile entity
│   ├── providers/
│   │   ├── theme_provider.dart            # Exp 5 & 6: Dynamic light/dark theme notifier
│   │   └── wallet_provider.dart           # Exp 1 & 5: Wallet balance, transactions & validations
│   ├── screens/
│   │   ├── add_money_screen.dart          # Exp 1 & 7: Add money with preset chips & validation
│   │   ├── contacts_screen.dart           # Exp 9: REST API HTTP GET contacts list with Retry
│   │   ├── home_screen.dart               # Exp 2 & 3: Main dashboard with balance & quick actions
│   │   ├── login_screen.dart              # Exp 7: Login form with demo auto-fill for viva
│   │   ├── payment_success_screen.dart    # Exp 8: Animated payment confirmation screen
│   │   ├── profile_screen.dart            # Exp 5 & 7: Profile view & interactive edit form
│   │   ├── register_screen.dart           # Exp 7: User registration with complete validation
│   │   ├── send_money_screen.dart         # Exp 1 & 7: Send money with balance checking
│   │   ├── settings_screen.dart           # Exp 5 & 6: Theme switcher & lab viva guide
│   │   ├── splash_screen.dart             # Exp 8: Animated fade-in splash screen
│   │   ├── transaction_details_screen.dart# Exp 4: Receipt screen with data passed from list
│   │   └── transaction_history_screen.dart# Exp 5: Transaction list with All/Received/Sent filter
│   ├── services/
│   │   ├── api_service.dart               # Exp 9: HTTP service fetching live API data
│   │   └── auth_service.dart              # Demo simulated authentication service
│   ├── utils/
│   │   ├── app_routes.dart                # Exp 4: Centralized named route definitions
│   │   └── app_theme.dart                 # Exp 6: Light and Dark Material 3 ThemeData
│   └── widgets/
│       ├── custom_button.dart             # Exp 6: Styled reusable action button
│       ├── custom_textfield.dart          # Exp 6 & 7: Reusable TextFormField
│       ├── dashboard_action_button.dart   # Exp 6: Icon tile for dashboard actions
│       ├── section_title.dart             # Exp 6: Consistent section header with "See All"
│       ├── transaction_tile.dart          # Exp 6: Color-coded transaction list tile (Green/Red)
│       └── wallet_balance_card.dart       # Exp 2, 3 & 6: Gradient wallet balance card
├── test/
│   ├── wallet_provider_test.dart          # Exp 10: 7 Unit tests covering wallet arithmetic & validation
│   └── widget_test.dart                   # Exp 10: 5 Widget & integration flow tests
├── pubspec.yaml                           # Dependencies: provider, http, cupertino_icons
└── README.md                              # Lab documentation & viva guide
```

---

## 🔑 Demo Credentials for Practical Examination

To facilitate quick and error-free demonstration in front of your lab examiner:
- **Email:** `student@btech.ac.in`
- **Password:** `password123`

> **Note:** The Login Screen includes an **"Auto-Fill"** button on the credentials card that populates these demo credentials in one tap! Any email/password meeting standard validation (6+ characters) will also sign in.

---

## 🚀 How to Run the Application

### 1. Open the project in terminal:
```bash
cd "C:\Users\Sailaxman\.gemini\antigravity\scratch\digital_wallet_simulator"
```

### 2. Fetch packages:
```bash
flutter pub get
```

### 3. Verify static analysis:
```bash
flutter analyze
```
*(Result: `No issues found!`)*

### 4. Run automated tests (Experiment 10):
```bash
flutter test
```
*(Result: `All tests passed!`)*

### 5. Launch the application:
```bash
# To run on connected Android device or emulator:
flutter run

# Or to run on Chrome for quick browser testing:
flutter run -d chrome
```

---

## 🎓 Viva Questions & Answers for Lab Examination

1. **How does the wallet balance update automatically across multiple screens?**
   - We use the `Provider` package with `ChangeNotifier` (`WalletProvider`). When `addMoney()` or `sendMoney()` executes, it calls `notifyListeners()`. Any widget listening via `Provider.of<WalletProvider>(context)` or `Consumer<WalletProvider>` automatically rebuilds with the updated balance.

2. **How is the Indian Rupee (₹) currency formatted?**
   - We use Dart string interpolation with fixed precision: `'₹${balance.toStringAsFixed(2)}'`, ensuring exactly two decimal places.

3. **How is the REST API integrated in Experiment 9?**
   - In `lib/services/api_service.dart`, we use `http.get()` from the `http` package with `async/await`. The JSON response string is parsed using `jsonDecode()` into Dart Maps, which are transformed into `ContactModel` objects using factory constructors. In `ContactsScreen`, `FutureBuilder` handles the loading (`CircularProgressIndicator`), success (`ListView.builder`), and error (`Retry` button) states.

4. **Why are both `setState()` and `Provider` used?**
   - As per Experiment 5, `setState()` handles ephemeral local UI state that only affects one widget (e.g. toggling password visibility or selecting a filter tab), while `Provider` handles application-wide persistent state (wallet balance, transactions, logged-in user, and theme mode).
