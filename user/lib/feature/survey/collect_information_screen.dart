import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

// --- IMPORT MÀN HÌNH HOME CỦA BẠN ---
import '../home/homepage_screen.dart'; 

// --- ĐỊNH NGHĨA MÀU SẮC ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh lá chính
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorBorder = Color(0xFFE0E3E7);
const Color kColorError = Color(0xFFFF5963);
const Color kColorInfo = Colors.white;

// Màu biểu đồ
const Color kChartFat = Color(0xFFFBC02D); // Vàng
const Color kChartCarbs = Color(0xFF0288D1); // Xanh dương
const Color kChartProtein = Color(0xFFE64A19); // Cam

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final int _totalPages = 9;

  // --- DỮ LIỆU ---
  final Map<String, dynamic> _formData = {
    'gender': null,
    'age': '',
    'height': 160.0, 
    'weight': 60.0,  
    'target_weight': 60.0,
    'health_conditions': <String>[],
    'goal': null,
    'diet_preference': 'Non-Vegetarian',
    'habits': <String>[],
  };

  // --- KEYS & CONTROLLERS ---
  final _page2Key = GlobalKey<FormState>(); // Gender
  final _page3Key = GlobalKey<FormState>(); // Age
  final _pageGoalKey = GlobalKey<FormState>(); // Goal

  late TextEditingController _ageController;

  // --- DỮ LIỆU OPTIONS ---
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _goalOptions = [
    'Lose Weight', 'Maintain Weight', 'Gain Weight', 'Build Muscle'
  ];
  final List<String> _healthConditionOptions = [
    'Diabetes', 'High Blood Pressure', 'High Cholesterol', 
    'Peanut Allergy', 'Gluten Allergy', 'None'
  ];
  final List<String> _habitOptions = [
    'Skips Breakfast', 'Eats Late', 'Snacks Often', 
    'Eats Fast Food', 'Low Water Intake'
  ];
  final List<String> _dietOptions = ['Non-Vegetarian', 'Vegetarian'];

  // --- STATE CHO AI ANALYSIS ---
  bool _isAnalyzing = false;
  String _bmiResult = "";
  Map<String, double> _analysisData = {};
  List<String> _deficiencies = [];
  List<String> _recommendations = [];
  List<String> _mealSuggestions = [];

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _calculateBmi(); 
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // --- LOGIC ĐIỀU HƯỚNG & XỬ LÝ ---

  void _onBackPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNextPressed() {
    bool isValid = true;

    switch (_currentPage) {
      case 1: // Gender
        isValid = _page2Key.currentState!.validate();
        break;
      case 2: // Age
        isValid = _page3Key.currentState!.validate();
        if (isValid) _formData['age'] = _ageController.text;
        break;
      case 3: // Body Stats
      case 4: // Target Weight
      case 5: // Health/Habits
        isValid = true;
        break;
      case 6: // Goal
        isValid = _pageGoalKey.currentState!.validate();
        break;
      case 7: // AI Analysis
        isValid = true;
        break;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the required field'),
          backgroundColor: kColorError,
        ),
      );
      return;
    }

    if (_currentPage == 6) {
      _runAiAnalysis();
    }

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitProfile();
    }
  }

  void _submitProfile() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  void _calculateBmi() {
    final double height = _formData['height'];
    final double weight = _formData['weight'];

    if (height > 0 && weight > 0) {
      final double heightInMeters = height / 100.0;
      final double bmi = weight / (heightInMeters * heightInMeters);

      String category;
      if (bmi < 18.5) {
        category = "Underweight";
      } else if (bmi < 24.9) category = "Normal";
      else if (bmi < 29.9) category = "Overweight";
      else category = "Obese";
      
      setState(() {
        _bmiResult = "${bmi.toStringAsFixed(1)} ($category)";
      });
    }
  }

  Future<void> _runAiAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _analysisData.clear();
      _deficiencies.clear();
      _recommendations.clear();
      _mealSuggestions.clear();
    });

    await Future.delayed(const Duration(seconds: 3));

    String goal = _formData['goal'] ?? 'Maintain Weight';
    
    if (_formData['weight'] > _formData['target_weight'] && goal == 'Lose Weight') {
       _analysisData = {'Protein': 45, 'Carbs': 35, 'Fat': 20};
       _deficiencies = ['Vitamin D', 'Chất xơ (Fiber)'];
       _recommendations = ['Tăng cường rau xanh', 'Giảm Calo nạp vào'];
       _mealSuggestions = ['Salad Ức gà nướng', 'Cá hồi áp chảo măng tây'];
    } else if (_formData['weight'] < _formData['target_weight'] && (goal == 'Gain Weight' || goal == 'Build Muscle')) {
       _analysisData = {'Protein': 35, 'Carbs': 45, 'Fat': 20};
       _deficiencies = ['Calo (Calories)', 'Protein'];
       _recommendations = ['Ăn thêm bữa phụ', 'Tăng cường Carb phức tạp'];
       _mealSuggestions = ['Bò bít tết khoai tây', 'Yến mạch với bơ đậu phộng'];
    } else { 
       _analysisData = {'Protein': 30, 'Carbs': 40, 'Fat': 30};
       _deficiencies = ['Sắt (Iron)'];
       _recommendations = ['Ăn cân bằng, đủ chất'];
       _mealSuggestions = ['Bò lúc lắc', 'Salad rau trộn trứng'];
    }

    setState(() {
      _isAnalyzing = false;
    });
  }

  // --- XÂY DỰNG GIAO DIỆN (BUILD) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      appBar: _buildAppBar(context),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildPage_Intro(),           // 0
          _buildPage_Gender(),          // 1
          _buildPage_Age(),             // 2
          _buildPage_BodyStats(),       // 3 (Đã sửa màu sáng)
          _buildPage_TargetWeight(),    // 4 (Đã sửa màu sáng)
          _buildPage_HealthAndHabits(), // 5
          _buildPage_Goal(),            // 6
          _buildPage_AiAnalysis(),      // 7
          _buildPage_Done(),            // 8
        ],
      ),
      bottomNavigationBar: _buildBottomControls(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Đã xóa logic đổi màu nền tối, dùng nền sáng cho tất cả
    return AppBar(
      backgroundColor: kColorBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: _buildStepIndicator(),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(_totalPages, (index) {
        return Expanded(
          child: Container(
            height: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: _currentPage >= index ? kColorPrimary : kColorBorder,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    bool isLastPage = _currentPage == _totalPages - 1;
    bool isFirstPage = _currentPage == 0;
    bool isAnalyzing = _currentPage == 7 && _isAnalyzing;
    
    return Container(
      color: kColorCard, // Dùng màu nền sáng (trắng)
      padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, MediaQuery.of(context).padding.bottom + 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: isFirstPage ? 0.0 : 1.0,
            child: OutlinedButton(
              onPressed: isFirstPage ? null : _onBackPressed,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(120, 50),
                foregroundColor: kColorSecondaryText,
                side: const BorderSide(color: kColorBorder, width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.interTight(fontWeight: FontWeight.w600, fontSize: 16.0),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: isAnalyzing ? null : _onNextPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 50),
              backgroundColor: kColorPrimary, // Luôn dùng màu xanh chủ đạo
              foregroundColor: kColorInfo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: Text(
              isLastPage ? 'Enter App' : 'Next',
              style: GoogleFonts.interTight(fontWeight: FontWeight.w600, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC TRANG CON (PAGE VIEW) ---

  // 0. Intro
  Widget _buildPage_Intro() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu_rounded, color: kColorPrimary, size: 80.0),
          const SizedBox(height: 24.0),
          Text(
            'Welcome to CookBook!',
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(color: kColorPrimaryText, fontSize: 28.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Before we start, let\'s personalize your experience so we can recommend the best recipes for you.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: kColorSecondaryText, fontSize: 16.0, height: 1.5),
          ),
        ],
      ),
    );
  }

  // 1. Gender
  Widget _buildPage_Gender() {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _page2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Select your gender", "This helps in calculating nutritional needs."),
            const SizedBox(height: 32.0),
            _buildDropdownField(
              label: 'Gender',
              hint: 'Select an option',
              value: _formData['gender'],
              items: _genderOptions,
              onChanged: (value) => setState(() => _formData['gender'] = value),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Age
  Widget _buildPage_Age() {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _page3Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("How old are you?", "Your age helps customize your dietary plan."),
            const SizedBox(height: 32.0),
            _buildTextField(
              controller: _ageController,
              label: 'Age',
              hint: 'e.g., 25',
              icon: Icons.cake_outlined,
              keyboardType: TextInputType.number,
              // CẬP NHẬT VALIDATOR CHO TUỔI: 0 < Tuổi < 100
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your age';
                final n = int.tryParse(value);
                if (n == null) return 'Invalid number';
                if (n <= 0) return 'Age must be greater than 0';
                if (n >= 100) return 'Age must be less than 100';
                return null;
              }
            ),
          ],
        ),
      ),
    );
  }

  // 3. Body Stats (GIAO DIỆN SÁNG)
  Widget _buildPage_BodyStats() {
    return SingleChildScrollView( // Bọc trong SingleScrollView để tránh lỗi tràn màn hình
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            "Body Measurements",
            "Enter your height and weight to calculate BMI.",
            isDark: false, // Đổi thành False
          ),
          const SizedBox(height: 32.0),

          // --- SLIDER CHIỀU CAO ---
          _buildNumberSlider(
            currentValue: _formData['height'],
            minValue: 100,
            maxValue: 250,
            unit: 'cm',
            onChanged: (value) {
              setState(() => _formData['height'] = value);
              _calculateBmi();
            },
          ),

          const SizedBox(height: 24.0),
          const Divider(color: kColorBorder, height: 1),
          const SizedBox(height: 24.0),

          // --- SLIDER CÂN NẶNG ---
          _buildNumberSlider(
            currentValue: _formData['weight'],
            minValue: 30,
            maxValue: 200,
            unit: 'kg',
            onChanged: (value) {
              setState(() => _formData['weight'] = value);
              _calculateBmi();
            },
          ),

          const SizedBox(height: 32.0),

          // BMI Result (Màu sáng)
          if (_bmiResult.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: kColorCard, // Nền trắng
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: kColorPrimary, width: 1.0)),
              child: Column(
                children: [
                  Text("Your BMI (Chỉ số BMI)",
                      style: GoogleFonts.inter(color: kColorSecondaryText, fontSize: 14.0)),
                  const SizedBox(height: 8.0),
                  Text(_bmiResult,
                      style: GoogleFonts.interTight(color: kColorPrimary, fontSize: 22.0, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  // 4. Target Weight (GIAO DIỆN SÁNG)
  Widget _buildPage_TargetWeight() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            "What's your target weight?",
            "This helps us recommend the right meal plans for your goals.",
            isDark: false, // Đổi thành False
          ),
          const SizedBox(height: 40.0),
          
           // --- SLIDER MỤC TIÊU ---
          _buildNumberSlider(
            currentValue: _formData['target_weight'],
            minValue: 30,
            maxValue: 200,
            unit: 'kg',
            onChanged: (value) => setState(() => _formData['target_weight'] = value),
          ),
        ],
      ),
    );
  }

  // 5. Health & Habits
  Widget _buildPage_HealthAndHabits() {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           _buildHeader("Health & Habits", "Select any that apply (optional)."),
          const SizedBox(height: 32.0),
          _buildSectionTitle('Health Conditions (Tình trạng sức khỏe)'),
          _buildChipGroup(
            _healthConditionOptions,
            _formData['health_conditions'],
            (isSelected, option) {
              setState(() {
                isSelected ? _formData['health_conditions'].add(option) : _formData['health_conditions'].remove(option);
              });
            },
          ),
          const SizedBox(height: 24.0),
          _buildSectionTitle('Eating Habits (Thói quen ăn uống)'),
           _buildChipGroup(
            _habitOptions,
            _formData['habits'],
            (isSelected, option) {
              setState(() {
                isSelected ? _formData['habits'].add(option) : _formData['habits'].remove(option);
              });
            },
          ),
          const SizedBox(height: 24.0),
          _buildRadioGroup(
            label: 'Diet Type (Chay/Mặn)',
            options: _dietOptions,
            groupValue: _formData['diet_preference'],
            onChanged: (value) => setState(() => _formData['diet_preference'] = value!),
          ),
        ],
      ),
    );
  }
  
  // 6. Goal
  Widget _buildPage_Goal() {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _pageGoalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("What's your nutrition goal?", "Let us know what you want to achieve."),
            const SizedBox(height: 32.0),
            _buildDropdownField(
              label: 'Nutrition Goal',
              hint: 'Select your main goal',
              value: _formData['goal'],
              items: _goalOptions,
              onChanged: (value) => setState(() => _formData['goal'] = value),
            ),
          ],
        ),
      ),
    );
  }

  // 7. AI Analysis
  Widget _buildPage_AiAnalysis() {
     return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: _isAnalyzing 
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: kColorPrimary),
                const SizedBox(height: 24.0),
                Text(
                  'Analyzing your profile...',
                  style: GoogleFonts.inter(color: kColorSecondaryText, fontSize: 16.0),
                )
              ],
            )
          : _buildAnalysisReport(),
      ),
    );
  }

  // 8. Done
  Widget _buildPage_Done() {
     return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: kColorPrimary, size: 80.0),
          const SizedBox(height: 24.0),
          Text(
            'You are all set!',
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(color: kColorPrimaryText, fontSize: 28.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Your profile is complete. We are ready to find the perfect recipes for you. Let\'s start cooking!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: kColorSecondaryText, fontSize: 16.0, height: 1.5),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildHeader(String title, String subtitle, {bool isDark = false}) {
    // Vì đã chuyển sang giao diện sáng toàn bộ, ta có thể bỏ qua check isDark
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.interTight(
            color: kColorPrimaryText, // Luôn dùng màu đen
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: kColorSecondaryText, // Luôn dùng màu xám
            fontSize: 16.0,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // --- SLIDER ĐÃ SỬA MÀU SÁNG ---
  Widget _buildNumberSlider({
    required double currentValue,
    required double minValue,
    required double maxValue,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Column(
      children: [
        // Hiển thị số (Màu chính hoặc Đen)
        Text(
          '${currentValue.toStringAsFixed(1)} $unit',
          style: GoogleFonts.interTight(
            color: kColorPrimary, // Dùng màu xanh chủ đạo cho số
            fontSize: 44.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24.0),
        
        // Thanh trượt Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: kColorPrimary, // Màu thanh đã trượt (Xanh)
            inactiveTrackColor: kColorBorder, // Màu thanh chưa trượt (Xám nhạt)
            thumbColor: kColorCard, // Màu nút tròn kéo (Trắng)
            overlayColor: kColorPrimary.withOpacity(0.2),
            trackHeight: 6.0,
            // Viền xanh cho nút kéo để nổi bật trên nền trắng
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0, elevation: 4),
          ),
          child: Slider(
            value: currentValue,
            min: minValue,
            max: maxValue,
            divisions: (maxValue - minValue).toInt() * 2, 
            label: currentValue.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ),
        
        // Hiển thị min - max (Màu xám)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${minValue.toInt()}', style: const TextStyle(color: kColorSecondaryText)),
              Text('${maxValue.toInt()}', style: const TextStyle(color: kColorSecondaryText)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.interTight(color: kColorPrimary, fontWeight: FontWeight.w600, fontSize: 16.0),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator, // Thêm tham số validator tùy chỉnh
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: kColorSecondaryText, size: 20) : null,
        filled: true,
        fillColor: kColorCard,
        contentPadding: const EdgeInsets.all(16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorPrimary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder( // Thêm viền đỏ khi lỗi
           borderRadius: BorderRadius.circular(12.0),
           borderSide: const BorderSide(color: kColorError, width: 1.0),
        ),
         focusedErrorBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12.0),
           borderSide: const BorderSide(color: kColorError, width: 2.0),
        ),
      ),
      // Dùng validator được truyền vào, nếu không có thì dùng mặc định
      validator: validator ?? (value) => (value == null || value.isEmpty) ? 'Please enter this field' : null,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: kColorCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder),
        ),
      ),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildRadioGroup({
    required String label,
    required List<String> options,
    required String groupValue,
    required void Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: kColorSecondaryText, fontSize: 14.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: kColorCard,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: kColorBorder),
          ),
          child: Row(
            children: options.map((option) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(option, style: GoogleFonts.inter(fontSize: 14.0)),
                  value: option,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: kColorPrimary,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChipGroup(
    List<String> options,
    List<String> selectedValues,
    Function(bool, String) onSelected,
  ) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) => onSelected(selected, option),
          labelStyle: GoogleFonts.inter(
            color: isSelected ? Colors.white : kColorPrimaryText,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: kColorCard,
          selectedColor: kColorPrimary,
          showCheckmark: false,
          shape: StadiumBorder(side: BorderSide(color: isSelected ? kColorPrimary : kColorBorder)),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        );
      }).toList(),
    );
  }

  // --- AI REPORTS UI ---

  Widget _buildAnalysisReport() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("AI Nutrition Analysis", "Here is a summary based on your profile."),
          const SizedBox(height: 32.0),
          _buildSectionTitle('Your Daily Intake'),
          SizedBox(height: 200, child: _buildPieChart()),
          const SizedBox(height: 24.0),
          _buildPieChartLegend(),
          const SizedBox(height: 32.0),
          _buildSectionTitle('Recommendations'),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kColorCard,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: kColorBorder)
            ),
            child: Column(
              children: [
                if (_deficiencies.isNotEmpty) _buildAnalysisItem(Icons.warning_amber_rounded, 'Thiếu:', _deficiencies, kColorError),
                if (_deficiencies.isNotEmpty) const Divider(height: 24, color: kColorBorder),
                _buildAnalysisItem(Icons.add_circle_outline, 'Nên bổ sung:', _recommendations, kColorPrimary),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          _buildSectionTitle('Suggested Meals'),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kColorCard,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: kColorBorder)
            ),
            child: _buildAnalysisItem(Icons.restaurant_menu, 'Món ăn gợi ý:', _mealSuggestions, kColorSecondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 50,
        sections: [
          PieChartSectionData(color: kChartProtein, value: _analysisData['Protein'], title: '${_analysisData['Protein']?.toInt()}%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          PieChartSectionData(color: kChartCarbs, value: _analysisData['Carbs'], title: '${_analysisData['Carbs']?.toInt()}%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          PieChartSectionData(color: kChartFat, value: _analysisData['Fat'], title: '${_analysisData['Fat']?.toInt()}%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPieChartLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Indicator(color: kChartProtein, text: 'Protein'),
        _Indicator(color: kChartCarbs, text: 'Carbs'),
        _Indicator(color: kChartFat, text: 'Fat'),
      ],
    );
  }

  Widget _buildAnalysisItem(IconData icon, String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20.0),
            const SizedBox(width: 12.0),
            Text(title, style: GoogleFonts.inter(fontSize: 16.0, fontWeight: FontWeight.w600, color: kColorPrimaryText)),
          ],
        ),
        const SizedBox(height: 8.0),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 32.0, bottom: 4.0),
          child: Text('• $item', style: GoogleFonts.inter(fontSize: 14.0, color: kColorSecondaryText)),
        )),
      ],
    );
  }
}

// --- HELPER WIDGET ---
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const _Indicator({required this.color, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: kColorSecondaryText)),
      ],
    );
  }
}