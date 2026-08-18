import 'package:flutter/material.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/trip_details/trip_detail/presentation/pages/TripDetailPage.dart';
import 'package:frontend/features/trip_planning/templates/data/models/trip_template_model.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_header.dart';

class TemplatesPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const TemplatesPage({super.key, this.onBackToHome});

  @override
  State<TemplatesPage> createState() => _TripTemplatesState();
}

class _TripTemplatesState extends State<TemplatesPage> {
  final Set<String> _selectedCategories = {"All"};
  final List<String> _categoryOptions = [
    'All',
    'Culinary',
    'Beach',
    'Luxury',
    'Budget',
    'Nature',
    'Culture',
  ];
  List<TripTemplateModel> _templates = [];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final templates = await ApiClient.fetchTripTemplates();
      if (!mounted) return;
      setState(() {
        _templates = templates;
        _isLoading = false;
        _loadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _templates = const [];
        _isLoading = false;
        _loadError = error.toString();
      });
    }
  }

  List<TripTemplateModel> get _filteredTemplates {
    if (_selectedCategories.contains('All') || _selectedCategories.isEmpty) {
      return _templates;
    }

    final selected = _selectedCategories
        .where((item) => item != 'All')
        .map((item) => item.toLowerCase())
        .toSet();

    return _templates.where((template) {
      final category = (template.category ?? '').toLowerCase();
      return selected.contains(category);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: "Trip Templates",
                onBack: widget.onBackToHome,
                trailing: PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onSelected: (value) {},
                  itemBuilder: (context) => [
                    _buildPopupItem(Icons.sort_rounded, "Sort by usage"),
                    _buildPopupItem(
                        Icons.star_outline_rounded, "Highest rated"),
                    _buildPopupItem(
                        Icons.monetization_on_outlined, "Budget friendly"),
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
              const SizedBox(height: 30),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildRegionWrap(),
              const SizedBox(height: 30),
              _buildSectionHeader("TRENDING THIS WEEK", "View all"),
              const SizedBox(height: 15),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_loadError != null)
                _buildLoadError()
              else if (_filteredTemplates.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text('No templates found'),
                  ),
                )
              else
                for (final template in _filteredTemplates) ...[
                  _buildTemplateCard(
                    category: template.category ?? 'General',
                    usage: '${template.popularityScore?.toStringAsFixed(1) ?? '4.5'}k used',
                    title: template.title ?? 'Trip Template',
                    locations: template.destination ?? 'Destination',
                    duration: '${template.duration ?? 0} days',
                    pax: '${template.duration ?? 1} pax',
                    rating: '${template.popularityScore ?? 4.5}',
                    price: _formatPrice(template.estimatedBudget),
                    color: _colorForCategory(template.category ?? 'General'),
                    bgIcon: _iconForCategory(template.category ?? 'General'),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_rounded,
                color: Color(0xFFD32F2F), size: 42),
            const SizedBox(height: 12),
            const Text(
              'Không thể tải dữ liệu template',
              style: TextStyle(
                color: Color(0xFF1A1D2D),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _loadError ?? 'Kiểm tra backend và kết nối mạng.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF71768E), fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _loadError = null;
                });
                _loadTemplates();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
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

  Widget _buildSearchBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        style: TextStyle(color: Color(0xFF1A1D2D)),
        decoration: InputDecoration(
          hintText: "Search Templates, Destinations",
          hintStyle: TextStyle(color: Color(0xFFB0B3C1), fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFB0B3C1)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildRegionWrap() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categoryOptions.map((label) => _buildCategoriesChip(label)).toList(),
      ),
    );
  }

  Widget _buildCategoriesChip(String label) {
    bool isSelected = _selectedCategories.contains(label);
    return GestureDetector(
      onTap: () => setState(() => isSelected
          ? _selectedCategories.remove(label)
          : _selectedCategories.add(label)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D7132) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF71768E),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF71768E),
                letterSpacing: 1.2)),
        if (actionText != null)
          GestureDetector(
            onTap: () {},
            child: Text(
              actionText,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7132)),
            ),
          ),
      ],
    );
  }

  Widget _buildTemplateCard({
    required String category,
    required String usage,
    required String title,
    required String locations,
    required String duration,
    required String pax,
    required String rating,
    required String price,
    required Color color,
    required IconData bgIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(
                  child: Icon(
                    bgIcon,
                    size: 80,
                    color: color.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        usage,
                        style: const TextStyle(
                            color: Color(0xFF1A1D2D),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D2D)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 14, color: Color(0xFFB0B3C1)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        locations,
                        style: const TextStyle(
                            color: Color(0xFF71768E), fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSmallInfo(Icons.access_time_rounded, duration),
                    const SizedBox(width: 20),
                    _buildSmallInfo(Icons.people_outline_rounded, pax),
                    const SizedBox(width: 20),
                    _buildSmallInfo(Icons.star_rounded, rating,
                        iconColor: Colors.orange),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: price,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D2D)),
                        children: [
                          const TextSpan(
                            text: " est / person",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFB0B3C1)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: AppButton(
                        label: "Use template",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TripDetailPage()));
                        },
                        height: 48,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfo(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor ?? const Color(0xFFB0B3C1)),
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                color: Color(0xFF71768E),
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatPrice(dynamic amount) {
    if (amount == null) return '\$0';
    if (amount is num) {
      return '\$${amount.toStringAsFixed(0)}';
    }
    final value = double.tryParse(amount.toString()) ?? 0;
    return '\$${value.toStringAsFixed(0)}';
  }

  Color _colorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'culinary':
        return Colors.orange.shade700;
      case 'beach':
        return const Color(0xFF1E88E5);
      case 'luxury':
        return const Color(0xFF8E24AA);
      case 'nature':
        return const Color(0xFF2D7132);
      case 'culture':
        return const Color(0xFFFB8C00);
      default:
        return const Color(0xFF2D7132);
    }
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'culinary':
        return Icons.food_bank_outlined;
      case 'beach':
        return Icons.beach_access_outlined;
      case 'luxury':
        return Icons.celebration_outlined;
      case 'nature':
        return Icons.terrain_outlined;
      case 'culture':
        return Icons.temple_buddhist_outlined;
      default:
        return Icons.explore_outlined;
    }
  }
}
