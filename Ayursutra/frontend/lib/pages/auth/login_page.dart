import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

// Import necessary dependencies (assuming existence)
// import '../role/role_dashboard_page.dart'; 
// import '../../providers/auth_provider.dart'; 

// --- Theme Constants for a Professional, Attractive Look ---
const Color kPrimaryColor = Color(0xFF1B5E20); // Dark Forest Green
const Color kAccentColor = Color(0xFF66BB6A); // Medium Vibrant Green
const Color kLightBgColor = Color(0xFFF1F8E9); // Very Light Green Background
const double kBorderRadius = 18.0;

// =========================================================
// NOTE: Placeholder classes needed for the file to be runnable
// In a real project, these are defined in separate files.
// =========================================================

// Placeholder for AuthProvider
class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? errorMessage;
  String? signupMessage;
  bool get isLoading => _isLoading;

  // Placeholder implementation for login
  Future<bool> login({required String email, required String password, required String role}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); 
    _isLoading = false;
    notifyListeners();
    if (email.contains('fail')) {
      errorMessage = 'Invalid credentials for $role. Please try again.'; 
      return false;
    }
    return true;
  }

  // Placeholder implementation for signup
  Future<bool> signup({required String email, required String password, required String role}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); 
    _isLoading = false;
    notifyListeners();
    if (email.contains('exist')) {
      errorMessage = 'User already exists. Please log in.';
      return false;
    }
    signupMessage = 'Account created successfully! Please log in.'; 
    return true;
  }
}

// Placeholder for RoleDashboardPage
class RoleDashboardPage extends StatelessWidget {
  final String role;
  const RoleDashboardPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$role Dashboard'), 
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Welcome to the $role Dashboard!', style: const TextStyle(fontSize: 24, color: kPrimaryColor)),
      ),
    );
  }
}

// =========================================================
// END PLACEHOLDERS
// =========================================================


class RoleLoginPage extends StatefulWidget { 
  final String selectedRole;
  final bool startInSignUpMode; 
  
  const RoleLoginPage({
    super.key, 
    required this.selectedRole,
    this.startInSignUpMode = false,
  }); 

  @override
  State<RoleLoginPage> createState() => _RoleLoginPageState();
}

class _RoleLoginPageState extends State<RoleLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late bool _isLoginMode; 
  
  @override
  void initState() {
    super.initState();
    _isLoginMode = !widget.startInSignUpMode; 
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handles the login or signup submission based on [_isLoginMode].
  void _submitAuthForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    
    // Listen is false because we are only calling methods, not listening to state changes here
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = false;

    if (_isLoginMode) {
      // 1. LOGIN
      success = await authProvider.login(
        email: email,
        password: password,
        role: widget.selectedRole,
      );
      if (success && mounted) {
        // Navigate after a slight delay for better UX
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RoleDashboardPage(role: widget.selectedRole),
          ),
        );
      }
    } else {
      // 2. SIGN UP
      success = await authProvider.signup(
        email: email,
        password: password,
        role: widget.selectedRole,
      );
      if (success && mounted) {
        // Use Future.microtask to ensure SnackBar is shown after state update
        Future.microtask(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.signupMessage ?? 'Registration successful!'),
              backgroundColor: kAccentColor, 
              behavior: SnackBarBehavior.floating, 
            ),
          );
        });
        setState(() {
          _isLoginMode = true; // Switch to Login after successful signup
          _formKey.currentState?.reset(); // Clear fields after successful signup
        });
      }
    }

    // Show error message if not successful
    if (!success && mounted) {
      // Use Future.microtask to show error message
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'An unknown error occurred.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating, 
          ),
        );
      });
    }
  }

  /// Custom Input Decoration for professional UI.
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: kPrimaryColor.withOpacity(0.9), 
        fontWeight: FontWeight.w600, 
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0), 
        child: Icon(icon, color: kAccentColor, size: 24),
      ),
      filled: true,
      fillColor: kLightBgColor.withOpacity(0.5), 
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), 
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: BorderSide.none, 
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: BorderSide(color: kAccentColor.withOpacity(0.5), width: 1.0), 
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2.5), 
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: const BorderSide(color: Colors.red, width: 2.5),
      ),
    );
  }

  /// Widget for Role Icon enhanced with gradient.
  Widget _buildRoleIcon() {
    // Map role to icon data for cleaner logic
    final Map<String, IconData> roleIcons = {
      'Patient': Icons.person_pin_circle_outlined,
      'Doctor': Icons.medical_information,
      'Admin': Icons.local_hospital_outlined, 
    };
    
    final IconData icon = roleIcons[widget.selectedRole] ?? Icons.local_hospital_outlined;
    
    return Container(
      padding: const EdgeInsets.all(28), 
      decoration: BoxDecoration(
        color: kAccentColor.withOpacity(0.2), 
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            blurRadius: 15, 
            offset: const Offset(0, 5),
          ),
        ],
      ),
      // Use ShaderMask for a primary/accent color gradient on the icon itself
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [kPrimaryColor, kAccentColor], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Icon(
          icon,
          size: 70, 
          color: Colors.white, // Color must be white for the ShaderMask to work
        ),
      ),
    );
  }

  /// Extracted widget for the main form card content.
  Widget _buildAuthFormCard(AuthProvider authProvider) {
    final bool isLoading = authProvider.isLoading; 
    final String currentAction = _isLoginMode ? 'Login' : 'Sign Up';

    return Container(
      constraints: const BoxConstraints(maxWidth: 400), 
      padding: const EdgeInsets.fromLTRB(35.0, 50.0, 35.0, 40.0), 
      // Card Enhancements: Brighter white, deeper shadows
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius * 1.5),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.15), // Shadow matches primary color
            blurRadius: 60, // Very soft, large blur
            spreadRadius: 5, 
            offset: const Offset(0, 20), // Lifted appearance
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Header Icon
            _buildRoleIcon(),
            const SizedBox(height: 40.0), 

            // Main Title (Enhanced Typography)
            Text(
              '$currentAction to the ${widget.selectedRole} Portal',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26, 
                fontWeight: FontWeight.w900, 
                color: kPrimaryColor,
                letterSpacing: -0.5 
              ),
            ),
            const SizedBox(height: 12.0),

            // Subtitle
            Text(
              'Manage your account details securely.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15, 
                color: Colors.grey.shade600, 
                fontWeight: FontWeight.w400
              ),
            ),
            const SizedBox(height: 40.0),

            // Email Input
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email Address', Icons.alternate_email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => (value == null || !value.contains('@')) ? 'Please enter a valid email.' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20.0),

            // Password Input
            TextFormField(
              controller: _passwordController,
              decoration: _inputDecoration('Password', Icons.lock_outline),
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must be at least 6 characters.';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                if (_isLoginMode) _submitAuthForm();
              },
              textInputAction: _isLoginMode ? TextInputAction.done : TextInputAction.next,
            ),
            
            // Confirm Password for Sign Up
            if (!_isLoginMode) ...[
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: _inputDecoration('Confirm Password', Icons.lock_reset),
                obscureText: true,
                validator: (value) {
                  if (value == null || value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submitAuthForm(),
                textInputAction: TextInputAction.done,
              ),
            ],

            const SizedBox(height: 35.0),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitAuthForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor, 
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)), 
                  elevation: 10, 
                  shadowColor: kAccentColor.withOpacity(0.8), 
                  foregroundColor: kAccentColor, 
                ),
                child: isLoading 
                    ? const SizedBox(
                        height: 24, width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : Text(
                        currentAction.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18.0, 
                          color: Colors.white,
                          fontWeight: FontWeight.w900, 
                          letterSpacing: 1.0, 
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 30.0),

            // Toggle Button
            TextButton(
              onPressed: () {
                if (!isLoading) {
                  setState(() {
                    _isLoginMode = !_isLoginMode;
                    // Clear fields and validation state when switching modes
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    _formKey.currentState?.reset(); 
                  });
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                foregroundColor: kAccentColor,
              ),
              child: Text(
                _isLoginMode 
                  ? 'Don\'t have an account? Create one'
                  : 'Already have an account? Log In instead',
                style: const TextStyle(
                  color: kAccentColor, 
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, 
                  decorationColor: kAccentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Build Method (Layout and aesthetic refinement) ---
  @override
  Widget build(BuildContext context) {
    // Watch for loading state changes from the AuthProvider
    final authProvider = Provider.of<AuthProvider>(context); 
    
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        // Background: Enhanced Soft, calming linear gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kLightBgColor, Colors.white], // Subtle light green to white gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0), 
            child: _buildAuthFormCard(authProvider),
          ),
        ),
      ),
    );
  }
}