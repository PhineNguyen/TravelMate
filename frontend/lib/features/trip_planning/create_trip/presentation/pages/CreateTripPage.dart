import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/loading_screen.dart';
import 'package:frontend/features/trip_details/trip_detail/presentation/pages/TripDetailPage.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_header.dart';
import '../widgets/planning_mode_selector.dart';
import 'CreateTripManunal.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  String _selectedMode = "AI-Assisted";
  int _manualStep = 1;

  double _budget = 2100;
  final Set<String> _selectedStyles = {"Cultural", "Culinary"};
  int _travellerCount = 2;
  DateTime? _departureDate;
  DateTime? _returnDate;

  late TextEditingController _travellerController;

  @override
  void initState() {
    super.initState();
    _travellerController =
        TextEditingController(text: _travellerCount.toString());
  }

  @override
  void dispose() {
    _travellerController.dispose();
    super.dispose();
  }

  void _handleGenerateAI() async {
    // Show Loading Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingScreen(
          message: "TravelMate AI is crafting your perfect itinerary...",
        ),
      ),
    );

    // Simulate AI generation time
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Pop loading screen and push Trip Detail
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TripDetailPage()),
    );
  }

  void _nextManualStep() {
    if (_manualStep < 5) setState(() => _manualStep++);
  }

  void _prevManualStep() {
    if (_manualStep > 1) setState(() => _manualStep--);
  }

  void _switchToAI() => setState(() {
        _selectedMode = "AI-Assisted";
        _manualStep = 1;
      });

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2D7132),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1D2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    String headerTitle =
        _selectedMode == "Manual" ? "Plan your trip" : "Create new trip";

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: AppHeader(
                title: headerTitle,
                trailing: PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onSelected: (value) {},
                  itemBuilder: (context) => [
                    _buildPopupItem(Icons.save_outlined, "Save draft"),
                    _buildPopupItem(Icons.refresh, "Reset form"),
                    _buildPopupItem(Icons.help_outline, "Help"),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: Color(0xFF1A1D2D), size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: PlanningModeSelector(
                selectedMode: _selectedMode,
                onModeChanged: (mode) {
                  setState(() {
                    _selectedMode = mode;
                    _manualStep = 1;
                  });
                },
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildBodyContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(IconData icon, String label) {
    return PopupMenuItem(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A1D2D), size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(color: Color(0xFF1A1D2D), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_selectedMode == "Manual") {
      return CreateTripManualContent(
        currentStep: _manualStep,
        onNext: _nextManualStep,
        onBack: _prevManualStep,
        onUseAI: _switchToAI,
      );
    }
    return _buildAIContent();
  }

  Widget _buildAIContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          "AI itinerary builder",
          "Describe your trip and our AI generates a complete, colour-coded itinerary with accommodation, activities and transport.",
        ),
        const SizedBox(height: 30),
        _buildSectionLabel("DESTINATION(S)"),
        _buildCustomTextField(hint: "Tokyo, Japan"),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("DEPARTURE"),
                  _buildDateButton(
                    date: _departureDate,
                    hint: "Select date",
                    onTap: () => _selectDate(context, true),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("RETURN"),
                  _buildDateButton(
                    date: _returnDate,
                    hint: "Select date",
                    onTap: () => _selectDate(context, false),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        _buildSectionLabel("TRAVELLERS"),
        _buildTravellerInput(),
        const SizedBox(height: 25),
        _buildSectionLabel("TRAVEL STYLE"),
        _buildTravelStyleWrap(),
        const SizedBox(height: 25),
        _buildBudgetHeader(),
        _buildBudgetSlider(),
        const SizedBox(height: 25),
        _buildSectionLabel("NOTES"),
        _buildCustomTextField(
            hint: "Vegetarian meals, no red-eye flights", maxLines: 3),
        const SizedBox(height: 40),
        AppButton(
          label: "Generate AI itinerary",
          icon: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
          ),
          onTap: _handleGenerateAI,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D7132).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D7132).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: Color(0xFF2D7132), size: 18),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2D7132))),
            ],
          ),
          const SizedBox(height: 10),
          Text(content,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF71768E), height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF71768E),
              letterSpacing: 1.1)),
    );
  }

  Widget _buildCustomTextField({required String hint, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1A1D2D)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0B3C1), fontSize: 15),
          contentPadding: const EdgeInsets.all(18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateButton(
      {DateTime? date, required String hint, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: Color(0xFFB0B3C1)),
            const SizedBox(width: 12),
            Text(
              date != null ? _formatDate(date) : hint,
              style: TextStyle(
                  color: date != null
                      ? const Color(0xFF1A1D2D)
                      : const Color(0xFFB0B3C1),
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravellerInput() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_travellerCount > 1) {
                setState(() {
                  _travellerCount--;
                  _travellerController.text = _travellerCount.toString();
                });
              }
            },
            icon: Icon(Icons.remove_circle_outline,
                color: _travellerCount > 1
                    ? const Color(0xFF2D7132)
                    : const Color(0xFFE2E4EB)),
          ),
          Expanded(
            child: TextFormField(
              controller: _travellerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1A1D2D)),
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (value) {
                int? val = int.tryParse(value);
                if (val != null) setState(() => _travellerCount = val);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _travellerCount++;
                _travellerController.text = _travellerCount.toString();
              });
            },
            icon:
                const Icon(Icons.add_circle_outline, color: Color(0xFF2D7132)),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelStyleWrap() {
    final styles = [
      "Cultural",
      "Culinary",
      "Adventure",
      "Relaxation",
      "Luxury"
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: styles.map((style) {
        bool isSelected = _selectedStyles.contains(style);
        return GestureDetector(
          onTap: () => setState(() => isSelected
              ? _selectedStyles.remove(style)
              : _selectedStyles.add(style)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2D7132) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Text(style,
                style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF71768E),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBudgetHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionLabel("BUDGET PER PERSON"),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text("${_budget.round()}\$",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7132),
                  fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildBudgetSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: const Color(0xFF2D7132),
        inactiveTrackColor: const Color(0xFFE2E4EB),
        thumbColor: Colors.white,
        overlayColor: const Color(0xFF2D7132).withOpacity(0.1),
      ),
      child: Slider(
        value: _budget,
        min: 500,
        max: 10000,
        onChanged: (val) => setState(() => _budget = val),
      ),
    );
  }
}
