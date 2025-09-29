// lib/pages/role/role_public_home_page.dart

import 'package:flutter/material.dart';
// Corrected Import Path
import '../auth/login_page.dart'; 

// --- Theme Constants ---
// Define MaterialColor constants if needed, but using standard Colors is fine if we return the base swatch
const Color kCardShadowColor = Color(0xFFE0F2F1); // Very Light Teal/Mint shadow

class RolePublicHomePage extends StatelessWidget {
  final String role;
  const RolePublicHomePage({super.key, required this.role});

  // --- Role-Specific Data ---
  // IMPORTANT FIX: Return the base MaterialColor (e.g., Colors.teal) so shades can be accessed later.
  Map<String, dynamic> _getRoleData(String role) {
    switch (role.toLowerCase()) {
      case 'patient':
        return {
          'color': Colors.teal, // Base MaterialColor
          'icon': Icons.person_pin_circle_outlined,
          'info': 'Discover personalized Ayurvedic consultation, seamless appointment booking, and comprehensive health records.',
          'reviews': [
            {'review': 'The booking process was seamless, and the Ayurvedic consultation was insightful.', 'author': 'Anil K.', 'rating': 5.0, 'tag': 'Ease of Use'},
            {'review': 'I felt truly cared for. My personalized treatment plan has made a huge difference.', 'author': 'Priya S.', 'rating': 4.8, 'tag': 'Personalized Care'},
            {'review': 'Easy access to my reports and timely reminders for follow-up appointments.', 'author': 'Rahul M.', 'rating': 5.0, 'tag': 'Digital Access'},
          ]
        };
      case 'doctor':
        return {
          'color': Colors.indigo, // Base MaterialColor
          'icon': Icons.medical_information,
          'info': 'Join our esteemed network to access streamlined patient management, secure records, and collaborative diagnostic tools.',
          'reviews': [
            {'review': 'The system streamlines patient record management, freeing up time for care.', 'author': 'Dr. Sharma', 'rating': 4.9, 'tag': 'Efficiency'},
            {'review': 'Excellent platform for collaborative diagnosis and sharing research updates.', 'author': 'Dr. Gupta', 'rating': 5.0, 'tag': 'Collaboration'},
            {'review': 'Joining the network was simple. I appreciate the professional development resources.', 'author': 'Dr. Varma', 'rating': 4.7, 'tag': 'Professional Growth'},
          ]
        };
      case 'clinic':
        return {
          'color': Colors.deepOrange, // Base MaterialColor
          'icon': Icons.local_hospital_outlined,
          'info': 'Optimize operations with advanced clinic management tools, efficient billing, and integrated digital services.',
          'reviews': [
            {'review': 'The clinic management tools drastically improved scheduling efficiency and billing.', 'author': 'Nandi Clinic Admin', 'rating': 4.9, 'tag': 'Operational Excellence'},
            {'review': 'Our patient satisfaction scores increased thanks to the seamless digital experience.', 'author': 'Wellness Center Mgmt', 'rating': 5.0, 'tag': 'Patient Satisfaction'},
            {'review': 'Fantastic support for integrating new services into our existing setup.', 'author': 'AyurCare Hospital', 'rating': 4.8, 'tag': 'Integration Support'},
          ]
        };
      default:
        return {'color': Colors.grey, 'icon': Icons.info, 'info': 'Portal information unavailable.', 'reviews': []};
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleData = _getRoleData(role);
    // Explicitly cast to MaterialColor if we intend to use shades outside of what Dart infers from Map access
    final MaterialColor roleColor = roleData['color'] as MaterialColor; 
    final List<Map<String, dynamic>> reviews = roleData['reviews'];

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Very light background
      appBar: AppBar(
        title: Text('${role} Portal'),
        backgroundColor: roleColor.shade700, // Use a specific shade for AppBar
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Stylish Hero Banner (Header)
            _buildWelcomeBanner(roleColor, roleData['icon'], roleData['info']),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2. Premium Call-to-Action Card
                  _buildAuthButtons(context, roleColor),
                  
                  const SizedBox(height: 50),

                  // 3. Reviews Section Title
                  Center(
                    child: Text(
                      'Voices of the Community',
                      style: TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.w900, 
                        color: roleColor.withOpacity(0.9),
                        letterSpacing: -0.5
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'What our verified ${role}s are saying about their experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.grey.shade600, 
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // 4. Testimonial Cards (Wrapped for responsive stacking)
                  Wrap(
                    spacing: 20.0, // horizontal spacing
                    runSpacing: 20.0, // vertical spacing
                    alignment: WrapAlignment.center,
                    children: reviews.map((r) => _buildReviewCard(
                      context, // FIX: Pass context here
                      r['review'], 
                      r['author'], 
                      r['rating'],
                      r['tag'],
                      roleColor,
                    )).toList(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildWelcomeBanner(MaterialColor roleColor, IconData icon, String info) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // FIX: Now roleColor is a MaterialColor, we can safely use shades
          colors: [roleColor.shade700, roleColor.shade400], 
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: roleColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Card
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                icon,
                size: 36,
                color: roleColor.shade700, // Use a specific shade
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome, ${role}!',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5
            ),
          ),
          const SizedBox(height: 10),
          Text(
            info, 
            style: const TextStyle(
              fontSize: 17, 
              color: Colors.white70,
              fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButtons(BuildContext context, MaterialColor roleColor) {
    return Card(
      elevation: 10, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      shadowColor: kCardShadowColor,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              'Secure Access to Your Dedicated Portal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: roleColor.shade700),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToLoginPage(context, isSignUp: false),
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text('Login', style: TextStyle(fontSize: 17, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: roleColor.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () => _navigateToLoginPage(context, isSignUp: true),
                      icon: Icon(Icons.person_add, color: roleColor.shade700),
                      label: Text('Sign Up', style: TextStyle(fontSize: 17, color: roleColor.shade700)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: roleColor.shade700, 
                        side: BorderSide(color: roleColor.shade700, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToLoginPage(BuildContext context, {required bool isSignUp}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleLoginPage(selectedRole: role, startInSignUpMode: isSignUp),
      ),
    );
  }

  // FIX: Added BuildContext context as the first argument
  Widget _buildReviewCard(BuildContext context, String review, String author, double rating, String tag, MaterialColor roleColor) {
    // FIX: context is now available for MediaQuery
    final double cardWidth = (MediaQuery.of(context).size.width > 600) 
        ? (MediaQuery.of(context).size.width / 3) - 30 // Approx 1/3 width minus spacing
        : double.infinity;

    return Container(
      width: cardWidth,
      child: Card(
        margin: EdgeInsets.zero, // Margin handled by Wrap spacing
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
        shadowColor: kCardShadowColor,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 5-Star Rating and Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRatingStars(rating, roleColor.shade600),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(fontWeight: FontWeight.w600, color: roleColor.shade700, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Large Quotation Mark
              Icon(
                Icons.format_quote_rounded, 
                size: 40, 
                color: roleColor.withOpacity(0.3)
              ),
              const SizedBox(height: 10),

              // Review Text (The main content)
              Text(
                review,
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic, 
                  color: Colors.grey.shade800,
                  height: 1.4, // Improved line spacing
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 20),
              
              // Author / Signature
              Row(
                children: [
                  // Subtle vertical divider for professionalism
                  Container(
                    width: 3, 
                    height: 30, 
                    color: roleColor.shade700, 
                    margin: const EdgeInsets.only(right: 10)
                  ),
                  Text(
                    '— $author',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: roleColor.shade700.withOpacity(0.9)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for displaying rating stars
  Widget _buildRatingStars(double rating, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: color, size: 20);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: color, size: 20);
        } else {
          return Icon(Icons.star_border, color: color.withOpacity(0.5), size: 20);
        }
      }),
    );
  }
}