import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';

class CreateTripManualContent extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onUseAI;

  const CreateTripManualContent({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onBack,
    required this.onUseAI,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStepper(),
        const SizedBox(height: 30),
        _buildStepContent(),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 1:
        return _buildStep1Info();
      case 2:
        return _buildStep2Dates();
      case 3:
        return _buildStep3Schedule();
      case 4:
        return _buildStep4Budget();
      case 5:
        return _buildStep5Review();
      default:
        return _buildStep1Info();
    }
  }

  // --- Step 1: Info ---
  Widget _buildStep1Info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("TRIP NAME"),
        _buildTextField("e.g. Vietnam Road Trip 2025"),
        const SizedBox(height: 25),
        _buildSectionTitle("DESTINATION(S)"),
        _buildTextField("Search cities, countries..."),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(child: _buildSectionColumn("TRAVELLERS", "2")),
            const SizedBox(width: 15),
            Expanded(child: _buildSectionColumn("TRIP TYPE", "Leisure")),
          ],
        ),
        const SizedBox(height: 25),
        _buildSectionTitle("TRAVEL STYLE"),
        _buildTravelStyleChips(),
        const SizedBox(height: 25),
        _buildSectionTitle("NOTES / PREFERENCES"),
        _buildTextField("e.g. Vegetarian meals, no red-eye flights...",
            maxLines: 4),
        const SizedBox(height: 40),
        AppButton(label: "Continue to dates →", onTap: onNext),
        const SizedBox(height: 15),
        AppButton(label: "Use AI instead", onTap: onUseAI, isPrimary: false),
      ],
    );
  }

  // --- Step 2: Dates ---
  Widget _buildStep2Dates() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xFF172234),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.chevron_left, color: Colors.white),
                  Text("September 2026",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                  child: Text("Calendar Grid Placeholder",
                      style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: 40),
        AppButton(label: "Continue to schedule →", onTap: onNext),
        const SizedBox(height: 15),
        AppButton(
            label: "Back",
            onTap: onBack,
            isPrimary: false,
            icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white)),
      ],
    );
  }

  // --- Step 3: Schedule ---
  Widget _buildStep3Schedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("DAY-BY-DAY SCHEDULE"),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color(0xFF172234),
              borderRadius: BorderRadius.circular(20)),
          child: const Text("Plan your activities here...",
              style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 40),
        AppButton(label: "Continue to budget →", onTap: onNext),
        const SizedBox(height: 15),
        AppButton(
            label: "Back",
            onTap: onBack,
            isPrimary: false,
            icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white)),
      ],
    );
  }

  // --- Step 4: Budget ---
  Widget _buildStep4Budget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("TOTAL BUDGET (USD)"),
        _buildTextField("4000"),
        const SizedBox(height: 40),
        AppButton(label: "Review trip →", onTap: onNext),
        const SizedBox(height: 15),
        AppButton(
            label: "Back",
            onTap: onBack,
            isPrimary: false,
            icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white)),
      ],
    );
  }

  // --- Step 5: Review ---
  Widget _buildStep5Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: const Color(0xFF172234),
              borderRadius: BorderRadius.circular(20)),
          child: const Text("Trip Summary Detail...",
              style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 40),
        AppButton(
            label: "Save Trip",
            onTap: () {},
            icon: const Icon(Icons.check, color: Colors.white)),
        const SizedBox(height: 15),
        AppButton(
            label: "Back",
            onTap: onBack,
            isPrimary: false,
            icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white)),
      ],
    );
  }

  // --- Helper Widgets ---
  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepItem(1, "Info"),
        _buildStepLine(1),
        _buildStepItem(2, "Dates"),
        _buildStepLine(2),
        _buildStepItem(3, "Schedule"),
        _buildStepLine(3),
        _buildStepItem(4, "Budget"),
        _buildStepLine(4),
        _buildStepItem(5, "Review"),
      ],
    );
  }

  Widget _buildStepItem(int number, String label) {
    bool isActive = currentStep == number;
    bool isCompleted = currentStep > number;
    Color color = (isActive || isCompleted)
        ? const Color(0xFF1ABC9C)
        : Colors.grey.shade700;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text("$number",
                style: TextStyle(
                    color: isActive ? Colors.black : color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                color: (isActive || isCompleted) ? color : Colors.grey.shade600,
                fontSize: 11)),
      ],
    );
  }

  Widget _buildStepLine(int stepIndex) {
    bool isPassed = currentStep > stepIndex;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
        color: isPassed ? const Color(0xFF1ABC9C) : Colors.grey.shade800,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildSectionColumn(String title, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildSectionTitle(title), _buildTextField(hint)],
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            border: InputBorder.none),
      ),
    );
  }

  Widget _buildTravelStyleChips() {
    return Wrap(
      spacing: 10,
      children: ["Adventure", "Luxury", "Culinary", "Budget"].map((style) {
        bool isSelected = style == "Culinary"; // Hardcoded for UI demo
        return Chip(
          label: Text(style),
          backgroundColor:
              isSelected ? const Color(0xFF1ABC9C) : const Color(0xFF172234),
          labelStyle: TextStyle(
              color: isSelected ? Colors.black : Colors.white, fontSize: 12),
        );
      }).toList(),
    );
  }
}
