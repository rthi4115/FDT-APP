import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// --- DATA_MODEL ---
class UserData extends ChangeNotifier {
  String _loggedInIdentifier = 'FDT User'; // Default or a placeholder

  String get loggedInIdentifier => _loggedInIdentifier;

  void setLoggedInIdentifier(String identifier) {
    _loggedInIdentifier = identifier;
    notifyListeners();
  }
}

// --- APP THEME AND MAIN ENTRY POINT ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>(
      create: (BuildContext context) => UserData(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FDT UPI App',
          theme: ThemeData(
            // Define our custom green color scheme
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green, // Base green color
              accentColor: Colors.lightGreenAccent, // Accent color
              backgroundColor: Colors.green.shade50, // Light background for pages
              cardColor: Colors.white,
              errorColor: Colors.red.shade700,
            ).copyWith(
              secondary: Colors.lightGreenAccent, // For FloatingActionButtons etc.
            ),
            scaffoldBackgroundColor: Colors.green.shade50, // Consistent background
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              elevation: 0, // Flat app bar
              centerTitle: true,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                inherit: true, // Explicitly set inherit to true
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actionsIconTheme: const IconThemeData(color: Colors.white),
              systemOverlayStyle:
                  SystemUiOverlayStyle.light, // Status bar icons white
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600, // Button background
                foregroundColor: Colors.white, // Button text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  inherit: true,
                ), // Explicitly set inherit to true
                elevation: 3, // Slight shadow
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green.shade700, // Text button color
                textStyle: const TextStyle(
                  fontSize: 16,
                  inherit: true,
                ), // Explicitly set inherit to true
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green.shade600,
                side: BorderSide(color: Colors.green.shade600, width: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  inherit: true,
                ), // Explicitly set inherit to true
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, // No visible border by default
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green.shade700, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade700, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade700, width: 2),
              ),
              labelStyle: TextStyle(
                color: Colors.green.shade700,
                inherit: true,
              ), // Explicitly set inherit to true
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                inherit: true,
              ), // Explicitly set inherit to true
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.green.shade700,
              unselectedItemColor: Colors.grey.shade600,
              type: BottomNavigationBarType.fixed, // Shows all labels
              elevation: 10,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                inherit: true,
              ), // Explicitly set inherit to true
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                inherit: true,
              ), // Explicitly set inherit to true
            ),
            cardTheme: CardThemeData( // Changed CardTheme to CardThemeData
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // More rounded cards
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              color: Colors.white,
            ),
          ),
          home: const LoginScreen(), // App starts with LoginScreen
        );
      },
    );
  }
}

// --- LOGIN SCREEN ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // For form validation
  bool _isLoading = false;
  bool _obscureText = true;

  String _getTimeBasedGreeting() {
    final DateTime now = DateTime.now();
    final int hour = now.hour;

    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network request for login
      await Future<void>.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Update user identifier in provider
        Provider.of<UserData>(context, listen: false)
            .setLoggedInIdentifier(_userController.text);

        setState(() {
          _isLoading = false;
        });
        // On successful login, navigate to HomeScreen and remove all previous routes
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.account_balance_wallet,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 15),
                Text(
                  '${_getTimeBasedGreeting()}!', 
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'FDT UPI Pay',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'UPI ID or Phone Number',
                    prefixIcon: Icon(Icons.person),
                    hintText: 'e.g., user@fdtupi or 9876543210',
                  ),
                  keyboardType: TextInputType.text,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your User ID or Phone Number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long.';
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'Password must contain at least one uppercase letter.';
                    }
                    if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'Password must contain at least one lowercase letter.';
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Password must contain at least one digit.';
                    }
                    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                      return 'Password must contain at least one special character.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login Securely'),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SIGN UP SCREEN (NEW) ---
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network request for sign-up
      await Future<void>.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account created for ${_fullNameController.text}! Please log in.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to LoginScreen
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _upiIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Join FDT UPI Pay today!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'e.g., yourname@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: 'e.g., 9876543210',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _upiIdController,
                decoration: InputDecoration(
                  labelText: 'Create UPI ID',
                  prefixIcon: const Icon(Icons.tag),
                  hintText: 'e.g., yourname@fdtupi',
                  suffixText: '@fdtupi', // Example suffix
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please create a UPI ID.';
                  }
                  if (!value.contains('@')) {
                    return 'UPI ID should generally contain "@" (e.g., name@bank)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long.';
                  }
                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Password must contain at least one uppercase letter.';
                  }
                  if (!value.contains(RegExp(r'[a-z]'))) {
                    return 'Password must contain at least one lowercase letter.';
                  }
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Password must contain at least one digit.';
                  }
                  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    return 'Password must contain at least one special character.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password.';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _signUp,
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text('Sign Up'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- FORGOT PASSWORD SCREEN ---
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate sending a reset email
      await Future<void>.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password reset link sent to ${_emailController.text}',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to LoginScreen
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter your registered email address to receive a password reset link.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_rounded),
                  hintText: 'e.g., yourname@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _sendResetLink,
                        icon: const Icon(Icons.mail_outline_rounded),
                        label: const Text('Send Reset Link'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HOME SCREEN WITH BOTTOM NAVIGATION ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of widgets (pages) to display in the BottomNavigationBar
  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const TransactionScreen(), // This is the 'Pay' screen
    const HistoryScreen(),
    const ProfileScreen(), // New profile screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.send_rounded), label: 'Pay'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- DASHBOARD SCREEN ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBalanceVisible = false; // State to manage balance visibility

  // Removed _getTimeBasedGreeting() as it's no longer used in DashboardScreen

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_active_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications Pressed!')),
              );
              // Navigate to a dedicated notifications screen if available
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scan QR Code! (Feature coming soon)'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Removed greeting text:
            // Text(
            //   '${_getTimeBasedGreeting()}!',
            //   style: theme.textTheme.headlineSmall?.copyWith(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),

            // User Balance Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current Balance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _isBalanceVisible ? '₹ 12,500.50' : '********.**',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isBalanceVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          color: primaryColor,
                          onPressed: () {
                            setState(() {
                              _isBalanceVisible = !_isBalanceVisible;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Adding money to wallet!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Add Money'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildQuickActionButton(
                  context,
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan & Pay',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Scan & Pay feature!')),
                    );
                  },
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.send_rounded,
                  label: 'Send Money',
                  onTap: () {
                    // Navigate to TransactionScreen, potentially clearing current route stack
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const TransactionScreen(),
                      ),
                    );
                  },
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.request_quote_rounded,
                  label: 'Request Money',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request Money feature!')),
                    );
                  },
                ),
                _buildQuickActionButton(
                  context,
                  icon: Icons.account_balance_rounded,
                  label: 'Self Transfer',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Self Transfer feature!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Recent Transactions (linking to HistoryScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Recent Transactions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to HistoryScreen
                    // In a real app, you might want to switch the bottom nav tab directly.
                    // For this setup, we'll just push it.
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HistoryScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Mock recent transactions
            Card(
              child: Column(
                children: <Widget>[
                  _buildRecentTransactionTile(
                    context,
                    'Amazon Pay',
                    750,
                    Icons.shopping_bag,
                    primaryColor,
                    isCredit: false,
                  ),
                  const Divider(height: 0),
                  _buildRecentTransactionTile(
                    context,
                    'Salary Deposit',
                    25000,
                    Icons.work,
                    Colors.green,
                  ),
                  const Divider(height: 0),
                  _buildRecentTransactionTile(
                    context,
                    'Swiggy',
                    280,
                    Icons.fastfood,
                    primaryColor,
                    isCredit: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Promotional Banners
            Text(
              'Offers & Rewards',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _buildPromoBanner(
                    context,
                    'Get 10% Cashback on Bill Payments!',
                    Icons.local_offer,
                    Colors.orange,
                  ),
                  _buildPromoBanner(
                    context,
                    'Refer a Friend, Earn ₹100!',
                    Icons.card_giftcard,
                    Colors.blue,
                  ),
                  _buildPromoBanner(
                    context,
                    'Pay with FDT UPI, Win Rewards!',
                    Icons.celebration,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: <Widget>[
        InkWell(
          key: ValueKey(
            'quick_action_${label.replaceAll(' ', '_').toLowerCase()}',
          ), // Add a unique ValueKey
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Icon(icon, size: 30, color: Colors.white), // Corrected icon color
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionTile(
    BuildContext context,
    String title,
    double amount,
    IconData icon,
    Color iconColor, {
    bool isCredit = true,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor,
        child: Icon(icon, color: Colors.white, size: 24), // Corrected icon color
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        isCredit ? 'Credit' : 'Debit',
        style: TextStyle(color: isCredit ? Colors.green : Colors.red),
      ),
      trailing: Text(
        '₹ ${amount.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on transaction: $title')),
        );
      },
    );
  }

  Widget _buildPromoBanner(
    BuildContext context,
    String text,
    IconData icon,
    MaterialColor color,
  ) {
    // Changed 'Color color' to 'MaterialColor color'
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: color,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 35), // Corrected icon color
            const SizedBox(height: 10),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        color[800], // Now 'color' is MaterialColor, so this is valid.
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// --- TRANSACTION SCREEN (PAY) ---
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _sendMoney() {
    if (_formKey.currentState!.validate()) {
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      String receiver = _receiverController.text;
      String message = _messageController.text;

      double calculatedRiskScore = 0.1; // Base safe score
      List<String> riskReasons = <String>[];

      // Amount risk
      if (amount > 20000) {
        calculatedRiskScore += 0.5; // High jump for very large amounts
        riskReasons.add(
            "The amount (₹${amount.toStringAsFixed(2)}) is unusually high for a single transaction.");
      } else if (amount > 5000) {
        calculatedRiskScore += 0.3; // Medium jump for higher amounts
        riskReasons.add(
            "The amount (₹${amount.toStringAsFixed(2)}) is higher than your typical transactions.");
      }

      // Receiver details risk
      final String lowerCaseReceiver = receiver.toLowerCase();
      bool isKnownReceiver = (lowerCaseReceiver == 'contact@upi' ||
          lowerCaseReceiver == 'alice.smith@fdtupi.com' ||
          lowerCaseReceiver == '9876543210');
      if (!isKnownReceiver) {
        calculatedRiskScore += 0.3; // New receiver adds some risk
        riskReasons.add(
            "The receiver '$receiver' is not in your frequent contacts list or is a new payee.");
      }

      // Suspicious keywords risk
      if (lowerCaseReceiver.contains('fraud') ||
          lowerCaseReceiver.contains('scam') ||
          lowerCaseReceiver.contains('spam') ||
          lowerCaseReceiver.contains('loan-shark')) {
        calculatedRiskScore += 0.4; // Significant jump for suspicious names
        riskReasons.add(
            "The receiver's details contain suspicious keywords, indicating potential risk.");
      }

      // Cap risk score at 1.0 and ensure it's not less than base 0.1
      calculatedRiskScore = calculatedRiskScore.clamp(0.1, 1.0);

      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AlertScreen(
            riskScore: calculatedRiskScore,
            amount: amount,
            receiver: receiver,
            message: message,
            riskReasons: riskReasons,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _receiverController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter Receiver Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _receiverController,
                decoration: InputDecoration(
                  labelText: 'Receiver UPI ID / Phone Number',
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'e.g., recipient@bank or 9876543210',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.contacts_rounded),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select from Contacts (mock)!'),
                        ),
                      );
                      _receiverController.text =
                          'contact@upi'; // Mock contact selection
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter receiver UPI ID or Phone Number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.currency_rupee_rounded),
                  hintText: 'e.g., 500.00',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Add a message (optional)',
                  prefixIcon: Icon(Icons.message_rounded),
                  hintText: 'e.g., For groceries, Birthday gift',
                ),
                maxLines: 2,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _sendMoney,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Proceed to Pay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ALERT SCREEN ---
class AlertScreen extends StatelessWidget {
  final double riskScore;
  final double amount;
  final String receiver;
  final String message;
  final List<String> riskReasons;

  const AlertScreen({
    super.key,
    required this.riskScore,
    required this.amount,
    required this.receiver,
    required this.message,
    required this.riskReasons,
  });

  @override
  Widget build(BuildContext context) {
    String alertMessage;
    String recommendation;
    Color color;
    IconData icon;

    if (riskScore < 0.4) {
      alertMessage = "Transaction Safe";
      recommendation = "This transaction appears to be safe.";
      color = Colors.green.shade700;
      icon = Icons.check_circle_outline;
    } else if (riskScore < 0.7) {
      alertMessage = "Unusual Activity Detected";
      recommendation =
          "Please review recipient details carefully before proceeding.";
      color = Colors.orange.shade700;
      icon = Icons.warning_amber_rounded;
    } else {
      alertMessage = "⚠ Potential Fraud Detected";
      recommendation =
          "We strongly advise against proceeding. Verify the recipient immediately.";
      color = Colors.red.shade700;
      icon = Icons.error_outline_rounded;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Alert')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 100, color: color),
              const SizedBox(height: 20),
              Text(
                alertMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                recommendation,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      _buildDetailRow(context, 'Receiver:', receiver),
                      _buildDetailRow(
                        context,
                        'Amount:',
                        '₹ ${amount.toStringAsFixed(2)}',
                        color: Theme.of(context).primaryColor,
                      ),
                      if (message.isNotEmpty)
                        _buildDetailRow(context, 'Message:', message),
                      _buildDetailRow(
                        context,
                        'Risk Score:',
                        '${(riskScore * 100).toStringAsFixed(0)}%',
                        color: color,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Explanation Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Explanation:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  if (riskReasons.isEmpty)
                    Text(
                      'No specific risks detected for this transaction.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    )
                  else
                    ...riskReasons.map<Widget>((String reason) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.info_outline, size: 20, color: color),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  reason,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Simulate transaction completion
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Transaction to $receiver of ₹$amount completed!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Pop alert screen and navigate to History (or Dashboard)
                    Navigator.popUntil(
                      context,
                      (Route<dynamic> route) => route.isFirst,
                    ); // Pop to root
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HomeScreen(),
                      ),
                    ); // Go to home
                    // In a real app, if you want to switch to history tab, you'd
                    // pass an argument to HomeScreen to set the selected index.
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Proceed Anyway'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        color, // Use alert color for proceed button
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaction Cancelled!')),
                    );
                    Navigator.pop(context); // Go back to TransactionScreen
                  },
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    'Cancel Transaction',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.black87,
                ),
          ),
        ],
      ),
    );
  }
}

// --- HISTORY SCREEN ---
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> _allTransactions = <Map<String, dynamic>>[
    {
      'id': 'TX1',
      'receiver': 'foodcourt@upi',
      'amount': 150.0,
      'type': 'Debit',
      'risk': 'Low',
      'date': '2023-10-26',
    },
    {
      'id': 'TX2',
      'receiver': 'salary@bank',
      'amount': 35000.0,
      'type': 'Credit',
      'risk': 'Low',
      'date': '2023-10-25',
    },
    {
      'id': 'TX3',
      'receiver': 'electric@bill',
      'amount': 1200.0,
      'type': 'Debit',
      'risk': 'Medium',
      'date': '2023-10-25',
    },
    {
      'id': 'TX4',
      'receiver': 'friend@upi',
      'amount': 500.0,
      'type': 'Debit',
      'risk': 'Low',
      'date': '2023-10-24',
    },
    {
      'id': 'TX5',
      'receiver': 'loan@shark',
      'amount': 8000.0,
      'type': 'Debit',
      'risk': 'High',
      'date': '2023-10-23',
    },
    {
      'id': 'TX6',
      'receiver': 'rent@house',
      'amount': 15000.0,
      'type': 'Debit',
      'risk': 'Low',
      'date': '2023-10-22',
    },
    {
      'id': 'TX7',
      'receiver': 'refund@ecommerce',
      'amount': 750.0,
      'type': 'Credit',
      'risk': 'Low',
      'date': '2023-10-21',
    },
  ];

  String _selectedFilter = 'All';

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == 'All') {
      return _allTransactions;
    }
    return _allTransactions
        .where((Map<String, dynamic> tx) => tx['type'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildFilterChip('All'),
                _buildFilterChip('Debit'),
                _buildFilterChip('Credit'),
              ],
            ),
          ),
          Expanded(
            child: _filteredTransactions.isEmpty
                ? Center(
                    child: Text(
                      'No transactions found for "$_selectedFilter".',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> tx =
                          _filteredTransactions[index];
                      Color riskBadgeColor;
                      if (tx['risk'] == 'Low') {
                        riskBadgeColor = Colors.green.shade500;
                      } else if (tx['risk'] == 'Medium') {
                        riskBadgeColor = Colors.orange.shade500;
                      } else {
                        riskBadgeColor = Colors.red.shade500;
                      }

                      Color amountColor = tx['type'] == 'Credit'
                          ? Colors.green.shade700
                          : Colors.red.shade700;
                      IconData transactionIcon = tx['type'] == 'Credit'
                          ? Icons.arrow_circle_down_rounded
                          : Icons.arrow_circle_up_rounded;

                      return Card(
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: amountColor,
                            child: Icon(
                              transactionIcon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            tx['receiver'] as String,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Date: ${tx['date']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                'ID: ${tx['id']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${tx['type'] == 'Credit' ? '+' : '-'} ₹${(tx['amount'] as double).toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: amountColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: riskBadgeColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tx['risk'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Details for transaction to ${tx['receiver']}',
                                ),
                              ),
                            );
                            // In a real app, navigate to a detailed transaction view
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Transaction Screen. In a real app, if HomeScreen
          // is managing tabs, you might want to switch the tab directly.
          // For now, pushing a new TransactionScreen is fine.
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const TransactionScreen()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String filterText) {
    bool isSelected = _selectedFilter == filterText;
    return ChoiceChip(
      label: Text(filterText),
      selected: isSelected,
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filterText;
          });
        }
      },
    );
  }
}

// --- PROFILE SCREEN (NEW) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final String loggedInUser =
        Provider.of<UserData>(context).loggedInIdentifier;

    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundColor: primaryColor,
                child: Icon(Icons.person, size: 70, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                loggedInUser, // Display the logged-in UPI ID/Phone Number
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'example@fdtupi.com', // Placeholder for email
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '+91 98765 43210', // Placeholder for phone
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),

              _buildProfileCard(
                context,
                title: 'Payment & Bank Accounts',
                icon: Icons.credit_card_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Manage Payment Methods!')),
                  );
                },
              ),
              _buildProfileCard(
                context,
                title: 'Manage UPI PIN', // Renamed this
                icon: Icons.vpn_key_rounded,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const UpiPinSettingsScreen(),
                    ),
                  );
                },
              ),
              _buildProfileCard(
                context,
                title: 'Notifications',
                icon: Icons.notifications_on_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Manage Notification Preferences!'),
                    ),
                  );
                },
              ),
              _buildProfileCard(
                context,
                title: 'Security & Privacy',
                icon: Icons.security_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Security Settings!')),
                  );
                },
              ),
              _buildProfileCard(
                context,
                title: 'Help & Support',
                icon: Icons.help_outline_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Access Help Center!')),
                  );
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Simulate logout by navigating back to LoginScreen
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LoginScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                    // Clear user data on logout
                    Provider.of<UserData>(context, listen: false)
                        .setLoggedInIdentifier('FDT User');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully!')),
                    );
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    color: theme.colorScheme.error,
                  ),
                  label: Text(
                    'Logout',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.error, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}

// --- UPI PIN SETTINGS SCREEN (NEW) ---
class UpiPinSettingsScreen extends StatefulWidget {
  const UpiPinSettingsScreen({super.key});

  @override
  State<UpiPinSettingsScreen> createState() => _UpiPinSettingsScreenState();
}

class _UpiPinSettingsScreenState extends State<UpiPinSettingsScreen> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureCurrentPin = true;
  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;

  void _setChangePin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network request for setting/changing PIN
      await Future<void>.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('UPI PIN updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to ProfileScreen
      }
    }
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage UPI PIN')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Set or Change your 4/6 digit UPI PIN.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _currentPinController,
                obscureText: _obscureCurrentPin,
                decoration: InputDecoration(
                  labelText: 'Current UPI PIN (if changing)',
                  prefixIcon: const Icon(Icons.lock_clock_outlined),
                  hintText: 'e.g., 1234',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPin
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPin = !_obscureCurrentPin;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6), // UPI PIN is typically 4 or 6 digits
                ],
                // Not strictly required to validate if user is only *setting* initial PIN
                // For changing, it would be required. Mock validation for now.
                validator: (String? value) {
                  if (_newPinController.text.isNotEmpty &&
                      (value == null || value.isEmpty)) {
                    return 'Please enter current PIN to change.';
                  }
                  if (value != null &&
                      value.isNotEmpty &&
                      value.length < 4) {
                    return 'Current PIN must be 4 or 6 digits.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPinController,
                obscureText: _obscureNewPin,
                decoration: InputDecoration(
                  labelText: 'New UPI PIN',
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  hintText: 'e.g., 5678',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPin ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPin = !_obscureNewPin;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new UPI PIN.';
                  }
                  if (value.length != 4 && value.length != 6) {
                    return 'UPI PIN must be 4 or 6 digits.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPinController,
                obscureText: _obscureConfirmPin,
                decoration: InputDecoration(
                  labelText: 'Confirm New UPI PIN',
                  prefixIcon: const Icon(Icons.check_circle_outline),
                  hintText: 'e.g., 5678',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPin
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPin = !_obscureConfirmPin;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new UPI PIN.';
                  }
                  if (value != _newPinController.text) {
                    return 'New PINs do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _setChangePin,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Set/Change UPI PIN'),
                      ),
                    ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Forgot UPI PIN flow initiated!'),
                      ),
                    );
                    // In a real app, this would navigate to a flow to reset UPI PIN via bank/debit card details.
                  },
                  child: const Text('Forgot UPI PIN?'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}