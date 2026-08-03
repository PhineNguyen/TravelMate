import 'package:flutter/material.dart';
import 'package:frontend/features/trip_details/itinerary/presentation/pages/ItineraryPage.dart';

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
        _buildStepContent(context),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context) {
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
        return _buildStep5Review(context);
      default:
        return _buildStep1Info();
    }
  }

  Widget _buildStep1Info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("TRIP NAME"),
        _buildTextField("e.g. Vietnam Road Trip 2025"),
        const SizedBox(height: 25),
        _buildSectionTitle("DESTINATION(S)"),
        _buildDestinationField(),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _buildSectionTitle("TRAVELLERS"),
                  _buildTextField("2")
                ])),
            const SizedBox(width: 15),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _buildSectionTitle("TRIP TYPE"),
                  _buildTextField("Leisure")
                ])),
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
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildTravelStyleChips() {
    final styles = ["Budget", "Luxury", "Adventure", "Relaxing"];
    return Wrap(
      spacing: 8,
      children: styles.map((style) {
        bool isSelected = style == "Adventure";
        return ChoiceChip(
          label: Text(style),
          selected: isSelected,
          onSelected: (val) {},
          selectedColor: const Color(0xFF2D7132),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF71768E),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFFE2E4EB))),
        );
      }).toList(),
    );
  }

  Widget _buildStep2Dates() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ]),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.chevron_left, color: Color(0xFF1A1D2D)),
                  Text("September 2026",
                      style: TextStyle(
                          color: Color(0xFF1A1D2D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, color: Color(0xFF1A1D2D)),
                ],
              ),
              const SizedBox(height: 20),
              _buildCalendarGrid(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend(const Color(0xFF2D7132), "Selected"),
                  const SizedBox(width: 15),
                  _buildLegend(const Color(0xFF2D7132), "Range",
                      isOutline: true),
                  const SizedBox(width: 15),
                  _buildLegend(const Color(0xFF2D7132), "Today"),
                ],
              ),
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2D)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildStep3Schedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _buildSectionTitle("DAY-BY-DAY SCHEDULE"),
          const Text("Expand all",
              style: TextStyle(
                  color: Color(0xFF2D7132),
                  fontSize: 12,
                  fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  _buildD1Icon(),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text("Day 1",
                            style: TextStyle(
                                color: Color(0xFF1A1D2D),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Text("Add activities below",
                            style: TextStyle(
                                color: Color(0xFFB0B3C1), fontSize: 12))
                      ])),
                  const Icon(Icons.keyboard_arrow_up, color: Color(0xFFB0B3C1)),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _buildActivityChip(Icons.train, "Transport"),
                    _buildActivityChip(Icons.hotel, "Hotel"),
                    _buildActivityChip(Icons.restaurant, "Food"),
                    _buildActivityChip(Icons.local_activity, "Activity"),
                    _buildActivityChip(Icons.park, "Nature", isSelected: true)
                  ])),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildTextField("Activity name or notes...")),
                const SizedBox(width: 12),
                _buildAddButton()
              ]),
            ],
          ),
        ),
        const SizedBox(height: 40),
        AppButton(label: "Continue to budget →", onTap: onNext),
        const SizedBox(height: 15),
        AppButton(
          label: "Back",
          onTap: onBack,
          isPrimary: false,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2D)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildStep4Budget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ESTIMATED TOTAL",
                  style: TextStyle(
                      color: Color(0xFF71768E),
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
              const Text("\$4",
                  style: TextStyle(
                      color: Color(0xFF1A1D2D),
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildProgressBar(),
              const SizedBox(height: 15),
              Wrap(spacing: 8, children: [
                _buildBudgetTag("Flights \$1", Colors.deepPurple.shade600),
                _buildBudgetTag("Accommodation \$2", Colors.teal.shade600),
                _buildBudgetTag("Food & Dining \$1", Colors.orange.shade700)
              ]),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildSectionTitle("TOTAL BUDGET (USD)"),
        _buildTextField("4000"),
        const SizedBox(height: 25),
        _buildBudgetItem(
            Icons.flight, "Flights", "1", Colors.deepPurple.shade600),
        _buildBudgetItem(
            Icons.hotel, "Accommodation", "2", Colors.teal.shade600),
        _buildBudgetItem(
            Icons.restaurant, "Food & Dining", "1", Colors.orange.shade700),
        _buildBudgetItem(
            Icons.confirmation_number, "Activities", "0", Colors.red.shade600),
        const SizedBox(height: 40),
        AppButton(label: "Review trip →", onTap: onNext),
        const SizedBox(height: 15),
        AppButton(
          label: "Back",
          onTap: onBack,
          isPrimary: false,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2D)),
        ),
      ],
    );
  }

  Widget _buildStep5Review(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("-",
                  style: TextStyle(
                      color: Color(0xFF1A1D2D),
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(children: [
                _buildSummaryTag(Icons.people_outline, "2 travellers"),
                const SizedBox(width: 12),
                _buildSummaryTag(Icons.calendar_today_outlined, "1 days"),
                const SizedBox(width: 12),
                _buildSummaryTag(
                    Icons.account_balance_wallet_outlined, "\$4,000")
              ]),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildSectionTitle("ITINERARY SUMMARY"),
        Row(children: [
          Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: const Color(0xFF2D7132).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4)),
              child: const Text("1",
                  style: TextStyle(
                      color: Color(0xFF2D7132), fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          const Text("No activities planned",
              style: TextStyle(
                  color: Color(0xFFB0B3C1), fontStyle: FontStyle.italic))
        ]),
        const SizedBox(height: 30),
        _buildTipBox(
            "Your manual schedule is ready. You can always add AI suggestions later from the trip detail page."),
        const SizedBox(height: 40),
        AppButton(
          label: "Save trip",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ItineraryPage()));
          },
          icon: const Icon(Icons.check, color: Colors.white),
        ),
        const SizedBox(height: 15),
        AppButton(
          label: "Back",
          onTap: onBack,
          isPrimary: false,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2D)),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStep(1, "Info"),
        _buildStepLine(1),
        _buildStep(2, "Dates"),
        _buildStepLine(2),
        _buildStep(3, "Schedule"),
        _buildStepLine(3),
        _buildStep(4, "Budget"),
        _buildStepLine(4),
        _buildStep(5, "Review"),
      ],
    );
  }

  Widget _buildStep(int number, String label) {
    bool isCompleted = currentStep > number;
    bool isActive = currentStep == number;
    Color color = (isCompleted || isActive)
        ? const Color(0xFF2D7132)
        : const Color(0xFFE2E4EB);
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: isActive ? color : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2)),
          child: Center(
              child: Text("$number",
                  style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : (isCompleted ? color : const Color(0xFFB0B3C1)),
                      fontSize: 12,
                      fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                color: (isCompleted || isActive)
                    ? const Color(0xFF1A1D2D)
                    : const Color(0xFFB0B3C1),
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStepLine(int stepAfter) {
    bool isPassed = currentStep > stepAfter;
    return Expanded(
        child: Container(
            height: 2,
            color: isPassed ? const Color(0xFF2D7132) : const Color(0xFFE2E4EB),
            margin: const EdgeInsets.only(bottom: 20)));
  }

  Widget _buildSectionTitle(String title) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              color: Color(0xFF71768E),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1)));

  Widget _buildTextField(String hint, {int maxLines = 1}) => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ]),
      child: TextField(
          maxLines: maxLines,
          style: const TextStyle(color: Color(0xFF1A1D2D)),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFFB0B3C1), fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16))));

  Widget _buildDestinationField() => Row(children: [
        Expanded(child: _buildTextField("City or country")),
        const SizedBox(width: 12),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
                color: const Color(0xFF2D7132),
                borderRadius: BorderRadius.circular(12)),
            child: const Text("+ Add",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)))
      ]);

  Widget _buildLegend(Color color, String label, {bool isOutline = false}) =>
      Row(children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: isOutline ? Colors.transparent : color,
                shape: BoxShape.circle,
                border: Border.all(color: color))),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(color: Color(0xFF71768E), fontSize: 12))
      ]);

  Widget _buildD1Icon() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: const Color(0xFF2D7132).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4)),
      child: const Text("D1",
          style: TextStyle(
              color: Color(0xFF2D7132), fontWeight: FontWeight.bold)));

  Widget _buildAddButton() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: const Color(0xFF2D7132),
          borderRadius: BorderRadius.circular(12)),
      child: const Text("Add",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  Widget _buildActivityChip(IconData icon, String label,
          {bool isSelected = false}) =>
      Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2D7132) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFFE2E4EB))),
          child: Row(children: [
            Icon(icon,
                size: 14,
                color: isSelected ? Colors.white : const Color(0xFFB0B3C1)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF71768E),
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal))
          ]));

  Widget _buildProgressBar() => ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
          value: 0.7,
          backgroundColor: const Color(0xFFF1F4FA),
          valueColor: const AlwaysStoppedAnimation(Color(0xFF2D7132)),
          minHeight: 4));

  Widget _buildBudgetItem(
          IconData icon, String title, String value, Color color) =>
      Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]),
          child: Row(children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 20)),
            const SizedBox(width: 15),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(
                          color: Color(0xFF1A1D2D),
                          fontWeight: FontWeight.bold)),
                  const Text("Notes...",
                      style: TextStyle(color: Color(0xFFB0B3C1), fontSize: 12))
                ])),
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.bold))
          ]));

  Widget _buildTipBox(String text) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF2D7132).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2D7132).withOpacity(0.1))),
      child: Row(children: [
        const Icon(Icons.auto_awesome, color: Color(0xFF2D7132), size: 18),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style: const TextStyle(color: Color(0xFF71768E), fontSize: 12)))
      ]));

  Widget _buildSummaryTag(IconData icon, String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F4FA),
          borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFB0B3C1), size: 14),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                color: Color(0xFF71768E),
                fontSize: 12,
                fontWeight: FontWeight.bold))
      ]));

  Widget _buildBudgetTag(String label, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)));

  Widget _buildCalendarGrid() => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemCount: 35,
      itemBuilder: (c, i) => Center(
          child: Text("${i + 1 > 30 ? '' : i + 1}",
              style: TextStyle(
                  color: (i == 0 || i == 1)
                      ? const Color(0xFF2D7132)
                      : const Color(0xFF1A1D2D)))));
}
