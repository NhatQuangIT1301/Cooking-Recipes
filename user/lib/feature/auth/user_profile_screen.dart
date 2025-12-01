import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// (Giả sử file này nằm trong `feature/core/`)

// --- Định nghĩa màu sắc (Sao chép từ settings_screen) ---
const Color primaryBackground = Color(0xFFE3ECE1);
const Color appBarColor = Color(0xFF568C4C);
const Color primaryColor = Color(0xFF568C4C);
const Color secondaryBackground = Colors.white;
const Color primaryText = Color(0xFF15161E);
const Color secondaryText = Color(0xFF57636C);
const Color alternateBorder = Color(0xFFE0E3E7);
const Color errorColor = Color(0xFFFF5963);
const Color infoColor = Colors.white;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  // SỬA ĐỔI: Xóa Gender, Thêm Height, Weight, Goal
  // String? _selectedGender;
  // final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String? _selectedGoal;

  // SỬA ĐỔI: Thêm dữ liệu Goal (từ onboarding_flow)
  final List<String> _goalOptions = [
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
    'Build Muscle'
  ];

  // Dữ liệu giả lập, giả sử đã fetch từ Onboarding Flow
  final Map<String, dynamic> _userData = {
    'uid': '1234567890',
    'email': 'user@example.com',
    'username': 'Chef Maria',
    'phone': '0901234567', // Số điện thoại có thể sửa
    'gender': 'Female', // Giới tính (Giờ chỉ đọc)
    'age': '28',
    // SỬA ĐỔI: Thêm dữ liệu từ flow
    'height': '170', // Có thể sửa
    'weight': '65', // Có thể sửa
    'health_status': 'High Blood Pressure',
    'goal': 'Lose Weight', // Có thể sửa
    'diet_preference': 'Non-Vegetarian',
    'habits': ['Eats Late', 'Snacks Often'],
  };

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller và state với dữ liệu giả
    _phoneController = TextEditingController(text: _userData['phone']);
    // _selectedGender = _userData['gender']; // Xóa
    // SỬA ĐỔI: Thêm controllers
    _heightController = TextEditingController(text: _userData['height']);
    _weightController = TextEditingController(text: _userData['weight']);
    _selectedGoal = _userData['goal'];
  }

  @override
  void dispose() {
    _phoneController.dispose();
    // SỬA ĐỔI: Thêm dispose
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Hàm lưu thay đổi
  void _saveProfileChanges() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      // SỬA ĐỔI: Cập nhật logic lưu

      print('Profile Saved!');
      print('New Phone: ${_phoneController.text}');
      print('New Height: ${_heightController.text}');
      print('New Weight: ${_weightController.text}');
      print('New Goal: $_selectedGoal');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: primaryBackground,
        appBar: _buildAppBar(context),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
              child: _buildUserProfileSection(context),
            ),
          ),
        ),
      ),
    );
  }

  // Hàm xây dựng AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'User Profile',
        style: GoogleFonts.interTight(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Mục "User Profile"
  Widget _buildUserProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            'Your Profile Details', // Tiêu đề
            style: GoogleFonts.interTight(
              color: secondaryText,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          // Bọc trong Form để validate
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // --- Thông tin không thể sửa ---
                _buildSettingsItem(
                  context,
                  icon: Icons.badge_outlined,
                  title: "UID",
                  subtitle: _userData['uid'], // Lấy từ data
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.person_outline,
                  title: "Username",
                  subtitle: _userData['username'], // Lấy từ data
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.email_outlined,
                  title: "Email",
                  subtitle: _userData['email'], // Lấy từ data
                ),

                // --- Thông tin có thể sửa (Theo yêu cầu mới) ---
                _buildDivider(),
                _buildEditableTextFieldItem(
                  controller: _phoneController,
                  label: "Phone Number",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone, // Dùng keyboardType
                ),
                _buildDivider(),
                _buildEditableTextFieldItem(
                  controller: _heightController,
                  label: "Height (cm)",
                  icon: Icons.height,
                  keyboardType: TextInputType.number, // Dùng keyboardType
                ),
                _buildDivider(),
                _buildEditableTextFieldItem(
                  controller: _weightController,
                  label: "Weight (kg)",
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number, // Dùng keyboardType
                ),
                _buildDivider(),
                _buildEditableDropdownItem(
                  label: "Nutrition Goal",
                  icon: Icons.flag_outlined,
                  value: _selectedGoal,
                  items: _goalOptions,
                  onChanged: (value) {
                    setState(() => _selectedGoal = value);
                  },
                ),

                // --- Thông tin khảo sát (chỉ đọc) ---
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.wc_outlined,
                  title: "Gender",
                  subtitle: _userData['gender'], // Chuyển thành chỉ đọc
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.cake_outlined,
                  title: "Age",
                  subtitle: _userData['age'],
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.health_and_safety_outlined,
                  title: "Health Status",
                  subtitle: _userData['health_status'],
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.restaurant_outlined,
                  title: "Diet",
                  subtitle: _userData['diet_preference'],
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.nightlife_outlined,
                  title: "Habits",
                  subtitle: (_userData['habits'] as List).join(', '),
                ),
                // Nút lưu
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _saveProfileChanges,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                      backgroundColor: primaryColor,
                      foregroundColor: infoColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Hàm trợ giúp tạo một hàng trong Cài đặt (Read-Only)
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    final Color itemIconColor = iconColor ?? primaryColor;
    final Color itemTitleColor = titleColor ?? primaryText;

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: itemIconColor, size: 24.0),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: itemTitleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: secondaryText,
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
          if (showArrow)
            const Icon(Icons.chevron_right, color: secondaryText, size: 24.0),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  // Hàm trợ giúp tạo đường kẻ phân cách
  Widget _buildDivider() {
    return const Divider(
      height: 1.0,
      thickness: 1.0,
      indent: 16.0,
      endIndent: 16.0,
      color: alternateBorder,
    );
  }

  // Hàm trợ giúp cho ô Text có thể sửa
  Widget _buildEditableTextFieldItem({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    // SỬA ĐỔI: Thêm keyboardType
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        controller: controller,
        // SỬA ĐỔI: Sử dụng keyboardType
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(
            color: secondaryText,
            fontSize: 14.0,
          ),
          prefixIcon: Icon(icon, color: primaryColor, size: 24.0),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        ),
        style: GoogleFonts.inter(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
        cursorColor: primaryColor,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Hàm trợ giúp cho ô Dropdown có thể sửa
  Widget _buildEditableDropdownItem({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 12.0, 4.0),
      child: DropdownButtonFormField<String>(
        // SỬA LỖI: Dùng 'value' thay vì 'initialValue'
        initialValue: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item,
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: primaryText,
                )),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(
            color: secondaryText,
            fontSize: 14.0,
          ),
          prefixIcon: Icon(icon, color: primaryColor, size: 24.0),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        ),
        validator: (value) {
          if (value == null) {
            return 'Please select an option';
          }
          return null;
        },
      ),
    );
  }
}