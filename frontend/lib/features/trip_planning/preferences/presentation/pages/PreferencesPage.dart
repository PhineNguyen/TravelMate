import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencesPage> {
  // --- STATE VARIABLES ---
  RangeValues _currentRangeValues = const RangeValues(500, 10000);
  double _currentDuration = 14.0;
  final Set<String> _selectedRegions = {};
  final Set<String> _selectedStyles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
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
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Set your preferences",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          "Help us personalise your experience. You can change these anytime in Settings.",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.grey[600],
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildBudgetSelector() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Text("to",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${_currentRangeValues.start.round()}\$",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5CF6)),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${_currentRangeValues.end.round()}\$${_currentRangeValues.end >= 10000 ? "+" : ""}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5CF6)),
                ),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.0,
            activeTrackColor: const Color(0xFF8B5CF6),
            inactiveTrackColor: const Color(0xFF8B5CF6).withOpacity(0.15),
            thumbColor: Colors.white,
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
            trackHeight: 12.0,
            activeTrackColor: const Color(0xFF8B5CF6),
            inactiveTrackColor: Colors.white,
            thumbColor: const Color(0xFF8B5CF6),
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 14.0, elevation: 6),
          ),
          child: Slider(
            value: _currentDuration,
            min: 1.0,
            max: 31.0,
            divisions: 30,
            onChanged: (value) => setState(() => _currentDuration = value),
          ),
        ),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2)
              ],
            ),
            child: Text(
              _currentDuration >= 31
                  ? "30+ days"
                  : "${_currentDuration.round()} days",
              style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionWrap() {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
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
        _buildButton(
          label: "Save & Continue",
          onPressed: () {},
          isPrimary: true,
        ),
        const SizedBox(height: 10),
        _buildButton(
          label: "Skip for now",
          onPressed: () {},
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            fontSize: 12,
            letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildButton(
      {required String label,
      required VoidCallback onPressed,
      required bool isPrimary}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF8B5CF6) : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.grey[700],
        elevation: isPrimary ? 2 : 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.grey[200]!),
        ),
      ),
      onPressed: onPressed,
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              ? const Color(0xFF8B5CF6).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[200]!,
              width: isSelected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[400]),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF101828))),
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
          color: isSelected ? const Color(0xFF8B5CF6) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[200]!),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF101828),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13)),
      ),
    );
  }
}
