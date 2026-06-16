import 'package:flutter/material.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  // --- STATE VARIABLES ---
  String _selectedMode = "Manual";
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

  // --- LOGIC FUNCTIONS ---

  // Hàm mở lịch chọn ngày
  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2D68FF)),
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

  // Hàm định dạng ngày hiển thị (Ví dụ: Apr 12, 2025)
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                _buildPlanningModeSelector(),
                const SizedBox(height: 10),
                _buildInfoCard(
                  "AI itinerary builder",
                  "Describe your trip and our AI generates a complete, colour-coded itinerary with accommodation, activities and transport.",
                ),
                const SizedBox(height: 15),

                _buildSectionLabel("DESTINATION(S)"),
                const SizedBox(height: 5),
                _buildCustomTextField(hint: "Tokyo, Japan"),
                const SizedBox(height: 15),

                // 2. DEPARTURE & RETURN
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel("DEPARTURE"),
                          const SizedBox(height: 5),
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
                          const SizedBox(height: 5),
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
                const SizedBox(height: 15),

                _buildSectionLabel("TRAVELLERS"),
                const SizedBox(height: 5),
                _buildTravellerInput(),
                const SizedBox(height: 15),

                _buildSectionLabel("TRAVEL STYLE"),
                const SizedBox(height: 10),
                _buildTravelStyleWrap(),
                const SizedBox(height: 15),

                _buildBudgetHeader(),
                _buildBudgetSlider(),
                const SizedBox(height: 5),

                _buildSectionLabel("NOTES"),
                const SizedBox(height: 5),
                _buildCustomTextField(
                    hint: "Vegetarian meals, no red-eye flights", maxLines: 3),
                const SizedBox(height: 15),

                _buildGenerateButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- COMPONENT BUILDERS ---

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFEBF4FF), Colors.white],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF101828), size: 22),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 15),
        const Text(
          "Create new trip",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101828)),
        ),
      ],
    );
  }

  Widget _buildPlanningModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: ["AI-Assisted", "Manual", "Template"]
            .map((mode) => _buildModeItem(mode))
            .toList(),
      ),
    );
  }

  Widget _buildModeItem(String title) {
    bool isSelected = _selectedMode == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF101828) : Colors.grey[500],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: Color(0xFF8B5CF6), size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
            ],
          ),
          const SizedBox(height: 8),
          Text(content,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[700], height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
            letterSpacing: 1.1));
  }

  Widget _buildCustomTextField({required String hint, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: TextFormField(
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Color(0xFF101828)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 18, color: Colors.grey[600]),
            const SizedBox(width: 10),
            Text(
              date != null ? _formatDate(date) : hint,
              style: TextStyle(
                  color:
                      date != null ? const Color(0xFF101828) : Colors.grey[400],
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravellerInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
                    ? const Color(0xFF2D68FF)
                    : Colors.grey),
          ),
          Expanded(
            child: TextFormField(
              controller: _travellerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                const Icon(Icons.add_circle_outline, color: Color(0xFF2D68FF)),
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
                  ? const Color(0xFF2D68FF).withOpacity(0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2D68FF)
                      : Colors.grey.withOpacity(0.2),
                  width: 1.5),
            ),
            child: Text(style,
                style: TextStyle(
                    color:
                        isSelected ? const Color(0xFF2D68FF) : Colors.grey[700],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500)),
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
        Text("${_budget.round()}\$",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildBudgetSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
        activeTrackColor: const Color(0xFF2D68FF),
        inactiveTrackColor: Colors.grey[200],
        thumbColor: const Color(0xFF2D68FF),
        overlayColor: const Color(0xFF2D68FF).withOpacity(0.1),
      ),
      child: Slider(
        value: _budget,
        min: 500,
        max: 10000,
        onChanged: (val) => setState(() => _budget = val),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          // Logic AI Generation
        },
        icon: const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
        label: const Text("Generate AI itinerary",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
