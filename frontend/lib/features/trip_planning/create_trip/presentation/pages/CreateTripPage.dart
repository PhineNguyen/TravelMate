import 'package:flutter/material.dart';
import 'package:frontend/features/trip_planning/create_trip/presentation/pages/CreateTripManunal.dart';

import '../../../../../core/widgets/app_button.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  // --- BIẾN TRẠNG THÁI (STATE) ---
  String _selectedMode = "AI-Assisted";
  int _manualStep = 1; // Quản lý bước cho chế độ Manual

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

  // --- HÀM LOGIC ĐIỀU HƯỚNG NỘI BỘ ---
  void _nextManualStep() => setState(() => _manualStep++);
  void _prevManualStep() => setState(() => _manualStep--);
  void _switchToAI() => setState(() {
        _selectedMode = "AI-Assisted";
        _manualStep = 1;
      });

  // --- HÀM XỬ LÝ NGÀY THÁNG ---
  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1ABC9C),
              onPrimary: Color(0xFF0B1423),
              surface: Color(0xFF172234),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDeparture)
          _departureDate = picked;
        else
          _returnDate = picked;
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
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 25),
              _buildPlanningModeSelector(),
              const SizedBox(height: 25),
              _buildBodyContent(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
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
          icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedMode) {
      case "Manual":
        return CreateTripManualContent(
          currentStep: _manualStep,
          onNext: _nextManualStep,
          onBack: _prevManualStep,
          onUseAI: _switchToAI,
        );
      case "AI-Assisted":
      default:
        return _buildAIContent();
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF172234),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 15),
        const Text("Create Trip",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildPlanningModeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: ["AI-Assisted", "Manual"]
            .map((mode) => _buildModeItem(mode))
            .toList(),
      ),
    );
  }

  Widget _buildModeItem(String title) {
    bool isSelected = _selectedMode == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMode = title;
            _manualStep = 1;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1ABC9C) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color:
                    isSelected ? const Color(0xFF0B1423) : Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1ABC9C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1ABC9C).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: Color(0xFF1ABC9C), size: 18),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1ABC9C))),
            ],
          ),
          const SizedBox(height: 10),
          Text(content,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade400, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1.1)),
    );
  }

  Widget _buildCustomTextField({required String hint, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
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
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 18, color: Colors.grey.shade500),
            const SizedBox(width: 12),
            Text(date != null ? _formatDate(date) : hint,
                style: TextStyle(
                    color: date != null ? Colors.white : Colors.grey.shade600,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildTravellerInput() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(16)),
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
                    ? const Color(0xFF1ABC9C)
                    : Colors.grey.shade700),
          ),
          Expanded(
            child: TextFormField(
              controller: _travellerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
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
                const Icon(Icons.add_circle_outline, color: Color(0xFF1ABC9C)),
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
              color: isSelected
                  ? const Color(0xFF1ABC9C).withOpacity(0.1)
                  : const Color(0xFF172234),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color:
                      isSelected ? const Color(0xFF1ABC9C) : Colors.transparent,
                  width: 1.5),
            ),
            child: Text(style,
                style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1ABC9C)
                        : Colors.grey.shade400,
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
                  color: Color(0xFF1ABC9C),
                  fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildBudgetSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: const Color(0xFF1ABC9C),
        inactiveTrackColor: Colors.grey.shade800,
        thumbColor: Colors.white,
        overlayColor: const Color(0xFF1ABC9C).withOpacity(0.2),
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
