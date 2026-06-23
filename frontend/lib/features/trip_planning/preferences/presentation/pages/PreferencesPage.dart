import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/features/navigation/MainNavigator.dart';

class PreferencesPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const PreferencesPage({super.key, this.onBackToHome});

  @override
  State<PreferencesPage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencesPage> {
  String _selectedBudget = "Mid-range";
  final Set<String> _selectedStyles = {"Cultural", "Culinary"};
  double _currentDuration = 14.0;
  final Set<String> _selectedRegions = {"Asia", "Europe"};

  // Pixel-perfect design colors
  static const Color kBackgroundColor = Color(0xFFF3F5F9);
  static const Color kPrimaryGreen =
      Color(0xFF6BB04D); // Vibrant Green from design
  static const Color kLightGreen =
      Color(0xFFEAF4E1); // Soft pastel green for selection
  static const Color kTextColor =
      Color(0xFF1A1D2D); // Deep navy/black for titles
  static const Color kTextSubColor =
      Color(0xFF71768E); // Muted blue-grey for subtext
  static const Color kUnselectedColor =
      Color(0xFFB0B3C1); // Light grey for dividers/unselected icons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopProgressBar(),
                const SizedBox(height: 25),
                const Text(
                  "STEP 2 OF 3",
                  style: TextStyle(
                    color: kTextSubColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Set your preferences",
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Help us personalise your experience. You can change these anytime in Settings.",
                  style: TextStyle(
                    color: kTextSubColor,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 35),
                _buildSectionHeader("BUDGET RANGE (PER TRIP)"),
                _buildBudgetGrid(),
                const SizedBox(height: 35),
                _buildSectionHeader("TRAVEL STYLE"),
                _buildStyleGrid(),
                const SizedBox(height: 35),
                _buildSectionHeader("AVG TRIP DURATION"),
                _buildDurationSlider(),
                const SizedBox(height: 35),
                _buildSectionHeader("PREFERRED REGION"),
                _buildRegionWrap(),
                const SizedBox(height: 45),
                _buildActionButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopProgressBar() {
    return Row(
      children: [
        _buildDash(true),
        const SizedBox(width: 8),
        _buildDash(true),
        const SizedBox(width: 8),
        _buildDash(false),
      ],
    );
  }

  Widget _buildDash(bool isActive) {
    return Container(
      width: 35,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? kPrimaryGreen : const Color(0xFFE2E4EB),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: kUnselectedColor,
          fontSize: 12,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildBudgetGrid() {
    final budgets = [
      {"label": "Budget", "range": "\$500-1,500"},
      {"label": "Mid-range", "range": "\$1,500-4,000"},
      {"label": "Premium", "range": "\$4,000-8,000"},
      {"label": "Luxury", "range": "\$8,000+"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        String label = budgets[index]["label"]!;
        bool isSelected = _selectedBudget == label;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _selectedBudget = label);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? kLightGreen : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? kPrimaryGreen : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? kPrimaryGreen : kTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  budgets[index]["range"]!,
                  style: TextStyle(
                    color: isSelected
                        ? kPrimaryGreen.withOpacity(0.7)
                        : kTextSubColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyleGrid() {
    final styles = [
      {"icon": Icons.museum_outlined, "label": "Cultural"},
      {"icon": Icons.restaurant_outlined, "label": "Culinary"},
      {"icon": Icons.terrain_outlined, "label": "Adventure"},
      {"icon": Icons.spa_outlined, "label": "Relaxation"},
      {"icon": Icons.workspace_premium_outlined, "label": "Luxury"},
      {"icon": Icons.backpack_outlined, "label": "Backpack"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: styles.length,
      itemBuilder: (context, index) {
        String label = styles[index]["label"] as String;
        bool isSelected = _selectedStyles.contains(label);
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => isSelected
                ? _selectedStyles.remove(label)
                : _selectedStyles.add(label));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? kLightGreen : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? kPrimaryGreen : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  styles[index]["icon"] as IconData,
                  color: isSelected ? kPrimaryGreen : kUnselectedColor,
                  size: 26,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? kPrimaryGreen : kTextSubColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10.0,
            activeTrackColor: kPrimaryGreen,
            inactiveTrackColor: const Color(0xFFE2E4EB),
            thumbColor: Colors.white,
            overlayColor: kPrimaryGreen.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12, elevation: 4),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: _currentDuration,
            min: 2.0,
            max: 30.0,
            onChanged: (value) {
              if (value.round() != _currentDuration.round()) {
                HapticFeedback.selectionClick();
              }
              setState(() => _currentDuration = value);
            },
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("2 days",
                  style: TextStyle(color: kUnselectedColor, fontSize: 13)),
              Text(
                "${_currentDuration.round()} days",
                style: const TextStyle(
                  color: kPrimaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Text("30 days",
                  style: TextStyle(color: kUnselectedColor, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegionWrap() {
    final regions = [
      "Asia",
      "Europe",
      "Americas",
      "Middle East",
      "Africa",
      "Oceania"
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: regions.map((region) {
        bool isSelected = _selectedRegions.contains(region);
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => isSelected
                ? _selectedRegions.remove(region)
                : _selectedRegions.add(region));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? kLightGreen : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? kPrimaryGreen : const Color(0xFFE2E4EB),
                width: 1.5,
              ),
            ),
            child: Text(
              region,
              style: TextStyle(
                color: isSelected ? kPrimaryGreen : kTextSubColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainNavigator()),
                  (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              "Save & continue",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainNavigator()),
                  (route) => false);
            },
            child: const Text(
              "Skip for now",
              style: TextStyle(
                color: Color(0xFF433E78), // Deep purple/navy from design image
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
