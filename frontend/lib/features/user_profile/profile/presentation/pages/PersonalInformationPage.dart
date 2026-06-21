// lib/features/user_profile/profile/presentation/pages/PersonalInformationPage.dart
import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              AppHeader(
                  title: "Personal Info", onBack: () => Navigator.pop(context)),
              const SizedBox(height: 30),
              _buildAvatarSection(),
              const SizedBox(height: 40),
              _buildInfoField("Full Name", "Alex Johnson"),
              _buildInfoField("Email Address", "alex.johnson@example.com"),
              _buildInfoField("Phone Number", "+1 234 567 890"),
              _buildInfoField("Location", "San Francisco, USA"),
              const SizedBox(height: 20),
              _buildEditButton(),
              const SizedBox(height: 10),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF172234),
            child: Icon(Icons.person, size: 50, color: Color(0xFF1ABC9C))),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Color(0xFF1ABC9C), shape: BoxShape.circle),
          child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
        )
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF172234),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF172234),
          foregroundColor: const Color(0xFF1ABC9C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade700, width: 1),
          ),
        ),
        child: const Text("Edit",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

Widget _buildSaveButton() {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1ABC9C),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: const Text("Save Changes",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    ),
  );
}
