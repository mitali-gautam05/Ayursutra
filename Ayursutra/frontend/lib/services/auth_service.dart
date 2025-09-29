// lib/services/auth_service.dart

// 🚨 CRITICAL: The class AuthService MUST be defined here for the provider to see it.
class AuthService {
  final List<String> registeredEmails = ['p@app.com', 'd@app.com', 'c@app.com'];

  // --- Login Method ---
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500)); 

    const String mockPassword = '123456';
    
    if (role.toLowerCase() == 'patient' && email == 'p@app.com' && password == mockPassword) {
      return {'success': true, 'token': 'patient_token_xyz'};
    }
    if (role.toLowerCase() == 'doctor' && email == 'd@app.com' && password == mockPassword) {
      return {'success': true, 'token': 'doctor_token_abc'};
    }
    if (role.toLowerCase() == 'clinic' && email == 'c@app.com' && password == mockPassword) {
      return {'success': true, 'token': 'clinic_token_123'};
    }

    throw Exception('Invalid credentials for $role. Please check email and password.');
  }

  // --- Sign Up Method ---
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2000)); 

    if (registeredEmails.contains(email)) {
      throw Exception('The email "$email" is already registered.');
    }
    
    registeredEmails.add(email);

    return {
      'success': true, 
      'message': 'Registration successful. You can now log in.',
      'token': 'new_${role}_token'
    };
  }
}