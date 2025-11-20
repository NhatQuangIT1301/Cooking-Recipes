import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Định nghĩa màu sắc (trích xuất từ theme)
const Color kPrimaryBackground = Color(0xFFF1F4F8);
const Color kCardBackground = Color(0xFFE3ECE1);
const Color kListBackground = Color(0xFFF1F4F8);
const Color kPrimaryText = Color(0xFF14181B);
const Color kSecondaryText = Color(0xFF57636C);
const Color kBorderColor = Color(0xFFE0E3E7);
const Color kIndicatorColor = Color(0xFF4B39EF);
const Color kIconBorder = Color(0xFF4B39EF);
const Color kIconBackground = Color(0x4C4B39EF);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector để unfocus khi nhấn ra ngoài
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kPrimaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              /// Nội dung chính
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Card chính chứa nội dung thông báo
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      height: 450.0,
                      decoration: BoxDecoration(
                        color: kCardBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 2.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildTabBar(),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        _buildNewNotificationsList(),
                                        _buildAllNotificationsList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// Nút Đóng ở góc trên bên phải
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kBorderColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: kPrimaryText,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    splashRadius: 22.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header (bạn có thể thay nội dung nếu cần)
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Notifications',
        style: GoogleFonts.plusJakartaSans(
          color: kPrimaryText,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Xây dựng thanh Tab
  Widget _buildTabBar() {
    return Align(
      alignment: const Alignment(-1.0, 0.0),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: kPrimaryText,
        unselectedLabelColor: kSecondaryText,
        labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: kPrimaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(),
        indicatorColor: kIndicatorColor,
        indicatorWeight: 4.0,
        padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
        tabs: const [
          Tab(text: 'New'),
          Tab(text: 'All'),
        ],
      ),
    );
  }

  // Tab 1: Danh sách Thông báo MỚI
  Widget _buildNewNotificationsList() {
    return _buildNotificationsList(true);
  }

  // Tab 2: Danh sách TẤT CẢ Thông báo
  Widget _buildAllNotificationsList() {
    return _buildNotificationsList(false);
  }

  // Danh sách chung
  Widget _buildNotificationsList(bool isNew) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isNew ? Colors.white : kListBackground,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: List.generate(
            3,
            (index) => _buildNotificationItem(
              title: 'New Product View',
              subtitle: 'Sally Mandrus viewed your profile...',
              time: '3m ago',
              backgroundColor: isNew && index == 0
                  ? kCardBackground
                  : Colors.white,
              iconWidget:
                  index == 0 ? _buildCheckIcon() : _buildRadioIcon(),
            ),
          ),
        ),
      ),
    );
  }

  // Mục thông báo
  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required Color backgroundColor,
    required Widget iconWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Container(
        width: double.infinity,
        height: 84.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: const [
            BoxShadow(
              blurRadius: 0.0,
              color: kBorderColor,
              offset: Offset(0.0, 1.0),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          color: kPrimaryText,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          color: kSecondaryText,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: GoogleFonts.plusJakartaSans(
                          color: kSecondaryText,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              iconWidget,
            ],
          ),
        ),
      ),
    );
  }

  // Icon dấu check màu xanh
  Widget _buildCheckIcon() {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        color: kIconBackground,
        shape: BoxShape.circle,
        border: Border.all(color: kIconBorder, width: 2.0),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.check_rounded, color: kIconBorder, size: 16.0),
    );
  }

  // Icon radio button màu xám
  Widget _buildRadioIcon() {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        color: kPrimaryBackground,
        shape: BoxShape.circle,
        border: Border.all(color: kBorderColor, width: 2.0),
      ),
      alignment: Alignment.center,
      child:
          const Icon(Icons.radio_button_checked, color: kBorderColor, size: 16.0),
    );
  }
}
