import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
// ⭐ CORRECT IMPORT: Same folder
import 'role_public_home_page.dart'; 

// --- Theme Constants (Matching Login and Dashboard Pages) ---
const Color kPrimaryColor = Color(0xFF1E88E5); // Strong Blue/Indigo
const Color kAccentColor = Color(0xFF4DB6AC); // Soft Mint/Teal
const double kBorderRadius = 18.0;

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  // --- Widget for Application Logo/Header ---
  Widget _buildHeaderLogo() {
    return Card(
      elevation: 12, // Increased shadow for header
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius * 1.5)),
      child: Padding(
        padding: const EdgeInsets.all(30.0), // Slightly larger padding
        child: Column(
          children: [
            // Icon using the accent color
            Icon(Icons.spa, size: 60, color: kAccentColor),
            const SizedBox(height: 10),
            Text(
              "AyurSutra Wellness",
              style: TextStyle(
                fontSize: 28, // Larger, more prominent title
                fontWeight: FontWeight.w900,
                color: kPrimaryColor, // Use primary color for main brand text
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Holistic Health Dashboard",
              style: TextStyle(fontSize: 16, color: kPrimaryColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper to provide a subtitle for each role card ---
  String _getRoleSubtitle(String role) {
    switch (role) {
      case 'Patient': return 'Manage health & appointments';
      case 'Doctor': return 'Consultation & patient records';
      case 'Clinic': return 'Staff, facility & billing management';
      default: return '';
    }
  }

  // --- Widget for Role Selection Card ---
  Widget _buildRoleCard(
      BuildContext context, String role, IconData icon, Color color) {
    // Removed Expanded here. Will wrap with Flexible/Expanded in the calling widget.
    return Card(
      elevation: 8, // Higher elevation for prominence
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)), // Use theme radius
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Added haptic feedback for better UX
          HapticFeedback.lightImpact(); 
          // Navigate to the Public Home Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RolePublicHomePage(role: role),
            ),
          );
        },
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 50), // Use passed color for icon
              const SizedBox(height: 15),
              Text(
                role,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor, // Consistent text color
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _getRoleSubtitle(role),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- NEW: Responsive Widget for Role Cards ---
  Widget _buildRoleCardsResponsive(BuildContext context) {
    final List<Map<String, dynamic>> roles = [
      {"role": "Patient", "icon": Icons.person_outline, "color": kPrimaryColor},
      {"role": "Doctor", "icon": Icons.medical_services_outlined, "color": kAccentColor},
      {"role": "Clinic", "icon": Icons.local_hospital_outlined, "color": Colors.green.shade600},
    ];

    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 650.0; // Breakpoint for switching layout

    // Helper to build a card wrapper (handling padding/spacing)
    Widget cardWrapper(Map<String, dynamic> roleData) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: _buildRoleCard(
          context, 
          roleData["role"], 
          roleData["icon"], 
          roleData["color"]
        ),
      );
    }

    if (screenWidth > breakpoint) {
      // Desktop/Tablet layout (Horizontal Row)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Each card takes up equal space horizontally
        children: roles.map((role) => Expanded(child: cardWrapper(role))).toList(),
      );
    } else {
      // Mobile layout (Vertical Column)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: roles.map((role) => cardWrapper(role)).toList(),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.transparent, 
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark, 
      ),
      body: Container(
        // Added top padding to ensure content starts below system status bar
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 32), 
        // Use theme-aligned gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor.withOpacity(0.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900), // Max width for content container
              padding: const EdgeInsets.all(24.0), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderLogo(),
                  
                  const SizedBox(height: 20),
                  // NEW: Attractive Tagline
                  Text(
                    "Your path to holistic Ayurvedic health starts here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, 
                      fontStyle: FontStyle.italic,
                      color: kAccentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 50), 
                  
                  // Use primary color for instruction text
                  const Text(
                    "Select Your Portal:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kPrimaryColor),
                  ),
                  const SizedBox(height: 30),

                  // Responsive Roles Section
                  _buildRoleCardsResponsive(context),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}