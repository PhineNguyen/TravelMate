import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_header.dart';

class PreferencesPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const PreferencesPage({super.key, this.onBackToHome});

  @override
  State<PreferencesPage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencesPage> {
  RangeValues _currentRangeValues = const RangeValues(500, 10000);
  double _currentDuration = 14.0;
  final Set<String> _selectedRegions = {};
  final Set<String> _selectedStyles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(
                  title: "Set your preferences",
                  onBack: widget.onBackToHome,
                  bottom: [
                    Text(
                      "Help us personalise your experience. You can change these anytime in Settings.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildSectionTitle("BUDGET RANGE (PER TRIP)"),
                _buildBudgetSelector(),
                const SizedBox(height: 30),
                _buildSectionTitle("TRAVEL STYLE"),
                _buildStyleGrid(),
                const SizedBox(height: 30),
                _buildSectionTitle("AVG TRIP DURATION"),
                _buildDurationSlider(),
                const SizedBox(height: 30),
                _buildSectionTitle("PREFERRED REGION"),
                _buildRegionWrap(),
                const SizedBox(height: 40),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetSelector() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text("to",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${_currentRangeValues.start.round()}\$",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1ABC9C)),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${_currentRangeValues.end.round()}\$${_currentRangeValues.end >= 10000 ? "+" : ""}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1ABC9C)),
                ),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            activeTrackColor: const Color(0xFF1ABC9C),
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: Colors.white,
            overlayColor: const Color(0xFF1ABC9C).withOpacity(0.2),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            max: 10000,
            onChanged: (values) => setState(() => _currentRangeValues = values),
          ),
        ),
      ],
    );
  }

  Widget _buildStyleGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStyleCard(Icons.museum_outlined, "Cultural"),
        _buildStyleCard(Icons.restaurant_outlined, "Culinary"),
        _buildStyleCard(Icons.terrain_outlined, "Adventure"),
        _buildStyleCard(Icons.spa_outlined, "Relaxation"),
        _buildStyleCard(Icons.workspace_premium_outlined, "Luxury"),
        _buildStyleCard(Icons.backpack_outlined, "Backpack"),
      ],
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8.0,
            activeTrackColor: const Color(0xFF1ABC9C),
            inactiveTrackColor: const Color(0xFF172234),
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12.0, elevation: 4),
          ),
          child: Slider(
            value: _currentDuration,
            min: 1.0,
            max: 31.0,
            divisions: 30,
            onChanged: (value) => setState(() => _currentDuration = value),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1ABC9C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _currentDuration >= 31
                  ? "30+ days"
                  : "${_currentDuration.round()} days",
              style: const TextStyle(
                  color: Color(0xFF1ABC9C),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionWrap() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildRegionChip("Asia"),
        _buildRegionChip("Europe"),
        _buildRegionChip("Americas"),
        _buildRegionChip("Middle East"),
        _buildRegionChip("Africa"),
        _buildRegionChip("Oceania"),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton(
          label: "Save & Continue",
          onTap: () {},
        ),
        const SizedBox(height: 15),
        AppButton(
          label: "Skip for now",
          onTap: () {},
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 4),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            fontSize: 12,
            letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildStyleCard(IconData icon, String title) {
    bool isSelected = _selectedStyles.contains(title);
    return GestureDetector(
      onTap: () => setState(() => isSelected
          ? _selectedStyles.remove(title)
          : _selectedStyles.add(title)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1ABC9C).withOpacity(0.1)
              : const Color(0xFF172234),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? const Color(0xFF1ABC9C) : Colors.transparent,
              width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelected ? const Color(0xFF1ABC9C) : Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionChip(String label) {
    bool isSelected = _selectedRegions.contains(label);
    return GestureDetector(
      onTap: () => setState(() => isSelected
          ? _selectedRegions.remove(label)
          : _selectedRegions.add(label)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1ABC9C) : const Color(0xFF172234),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color:
                  isSelected ? const Color(0xFF1ABC9C) : Colors.grey.shade800),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? const Color(0xFF0B1423) : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13)),
      ),
    );
  }
}
