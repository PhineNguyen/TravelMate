import 'package:flutter/material.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/widgets/confirmation_dialog.dart';
import 'package:frontend/features/chat/presentation/pages/ChatPage.dart';
import 'package:frontend/features/finance/budget/presentation/pages/BudgetPage.dart';
import 'package:frontend/features/finance/expense/presentation/pages/AddExpensePage.dart';
import 'package:frontend/features/trip_details/itinerary/presentation/pages/ItineraryPage.dart';
import 'package:frontend/features/trip_details/map/presentation/pages/MapPage.dart';
import 'package:frontend/features/trip_details/share/presentation/pages/ShareTripPage.dart';
import 'package:frontend/features/trip_planning/home/data/models/trip_model.dart';

class TripDetailPage extends StatefulWidget {
  final int tripId;

  const TripDetailPage({super.key, this.tripId = 1});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  TripModel? _trip;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    try {
      final trip = await ApiClient.fetchTrip(widget.tripId);
      if (!mounted) return;
      setState(() {
        _trip = trip;
        _isLoading = false;
        _loadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = error.toString();
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Delete Trip",
        message:
            "Are you sure you want to delete '${_trip?.destination ?? 'this trip'}'?",
        confirmLabel: "Delete",
        isDestructive: true,
        onConfirm: () async {
          try {
            await ApiClient.deleteTrip(widget.tripId);
            if (!mounted) return;
            Navigator.pop(context);
            Navigator.pop(context);
          } catch (error) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Delete failed: $error')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF1F4FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError != null || _trip == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F4FA),
        body: Center(child: Text(_loadError ?? 'Trip not found')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                  const SizedBox(height: 30),
                  _buildTripInfoCard(),
                  const SizedBox(height: 20),
                  _buildCollaboratorsCard(context),
                  const SizedBox(height: 20),
                  _buildBudgetOverviewCard(context),
                  const SizedBox(height: 20),
                  _buildWeatherAlertCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2D7132).withOpacity(0.1),
            const Color(0xFFF1F4FA),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleActionIcon(
                  Icons.arrow_back, () => Navigator.pop(context)),
              Row(
                children: [
                  _buildCircleActionIcon(Icons.ios_share, () {}),
                  const SizedBox(width: 12),
                  PopupMenuButton<String>(
                    offset: const Offset(0, 50),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    onSelected: (value) {
                      if (value == "delete") {
                        _showDeleteConfirmation(context);
                      }
                    },
                    itemBuilder: (context) => [
                      _buildPopupItem(Icons.edit_outlined, "Edit trip"),
                      _buildPopupItem(Icons.copy_outlined, "Duplicate"),
                      _buildPopupItem(Icons.delete_outline, "Delete trip",
                          isDestructive: true, value: "delete"),
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
                      child: const Icon(Icons.more_horiz,
                          color: Color(0xFF1A1D2D), size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              _buildBadge(_trip!.status, const Color(0xFF2D7132), Colors.white),
              const SizedBox(width: 10),
              _buildBadge("Day 8 of 22", Colors.white, const Color(0xFF71768E)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _trip!.destination.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF71768E),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _trip!.destination,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D2D),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(IconData icon, String label,
      {bool isDestructive = false, String? value}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon,
              color:
                  isDestructive ? Colors.red.shade600 : const Color(0xFF1A1D2D),
              size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: isDestructive
                      ? Colors.red.shade600
                      : const Color(0xFF1A1D2D),
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCircleActionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
        child: Icon(icon, color: const Color(0xFF1A1D2D), size: 20),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: bgColor == Colors.white
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(
            Icons.list_alt_rounded, "Itinerary", const Color(0xFF2D7132), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItineraryPage(tripId: widget.tripId)));
        }),
        _buildActionItem(Icons.account_balance_wallet_outlined, "Budget",
            const Color(0xFF009688), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BudgetPage(tripId: widget.tripId)));
        }),
        _buildActionItem(Icons.map_outlined, "Map", const Color(0xFF673AB7),
            () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapPage(tripId: widget.tripId)));
        }),
        _buildActionItem(
            Icons.chat_bubble_outline_rounded, "Chat", const Color(0xFFD84315),
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChatPage()));
        }),
      ],
    );
  }

  Widget _buildActionItem(
      IconData icon, String label, Color color, VoidCallback ontap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: ontap,
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF71768E)),
        ),
      ],
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionLabel("TRIP INFO"),
              _buildBadge(
                  _trip!.status,
                  const Color(0xFF2D7132).withOpacity(0.1),
                  const Color(0xFF2D7132)),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              _buildInfoColumn(
                  Icons.calendar_today_rounded, "Start date", _trip!.startDate),
              _buildInfoColumn(
                  Icons.timer_outlined, "Duration", "${_trip!.duration} days"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildInfoColumn(Icons.people_outline_rounded, "Travellers",
                  "${_trip!.travelerCount} persons"),
              _buildInfoColumn(Icons.account_balance_wallet_outlined, "Budget",
                  "\$${_trip!.totalBudget.toStringAsFixed(0)}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String title, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFB0B3C1)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF71768E),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2D),
                    fontSize: 14)),
          ]),
        ],
      ),
    );
  }

  Widget _buildCollaboratorsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionLabel("COLLABORATORS"),
              _buildTextButton(
                "Invite",
                context: context,
                page: ShareTripPage(
                    tripId: widget.tripId, senderId: _trip!.ownerId),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildAvatar("AJ", const Color(0xFF2D7132)),
              const SizedBox(width: 10),
              _buildAvatar("SK", const Color(0xFF673AB7)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4FA),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.add, color: Color(0xFF71768E), size: 20),
                ),
              ),
              const SizedBox(width: 15),
              const Text("2 members",
                  style: TextStyle(color: Color(0xFF71768E), fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String text, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBudgetOverviewCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionLabel("BUDGET OVERVIEW"),
              _buildTextButton("Add expense",
                  context: context,
                  page: AddExpensePage(
                      tripId: widget.tripId, createdById: _trip!.ownerId)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Spent \$${_trip!.totalBudget.toStringAsFixed(0)} budget",
                  style: TextStyle(
                      color: Color(0xFF1A1D2D),
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text("${_trip!.travelerCount} travellers",
                  style: TextStyle(color: Color(0xFF71768E), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.44,
              minHeight: 10,
              backgroundColor: Color(0xFFF1F4FA),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D7132)),
            ),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Full budget tracker",
                  style: TextStyle(
                      color: Color(0xFF1A1D2D),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF71768E),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextButton(String title, {Widget? page, BuildContext? context}) {
    return GestureDetector(
      onTap: (page != null && context != null)
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                ),
              )
          : null,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2D7132),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildWeatherAlertCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFD32F2F), size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Heavy rain — Apr 16–17",
                  style: TextStyle(
                      color: Color(0xFF1A1D2D),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: Color(0xFF71768E), fontSize: 13, height: 1.4),
                    children: [
                      const TextSpan(
                          text: "AI rescheduled 3 outdoor activities. "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "See forecast →",
                            style: TextStyle(
                                color: Color(0xFF2D7132),
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
