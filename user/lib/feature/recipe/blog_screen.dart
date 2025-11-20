import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// THÊM MỚI: Import 2 thư viện
import 'package:fl_chart/fl_chart.dart';
import 'markdown_recipe_screen.dart'; // Sửa lỗi import: Dùng đường dẫn tương đối

// --- Định nghĩa màu sắc (trích xuất từ FlutterFlow) ---
const Color kColorBackground = Color(0xFFF1F4F8); // Sửa lại màu nền
const Color kColorCard = Color(0xFFFFFFFF); // secondaryBackground
const Color kColorCardHighlight = Color(0xFFF1F4F8); // Đổi màu card
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh lá chính
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorInfo = Colors.white; // info (màu chữ)
const Color kColorOverlay = Color(0x80000000); // Màu nền nút (đen mờ)
const Color kColorRatingStar = Color(0xFFFFA726);
const Color kColorSuccess = Color(0xFF4CAF50);
const Color kColorAlternate = Color(0xFFE0E3E7);

// THÊM MỚI: Màu cho biểu đồ
const Color kChartFat = Color(0xFFFBC02D); // Vàng
const Color kChartCarbs = Color(0xFF0288D1); // Xanh dương
const Color kColorProtein = Color(0xFFE64A19); // Cam

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late TextEditingController _commentController;
  late FocusNode _commentFocusNode;
  bool _isFavorited = false;
  final int _userRating = 4; // Giả sử người dùng đã đánh giá 4 sao

  // THÊM MỚI: Dữ liệu giả cho nutrition
  Map<String, dynamic>? _nutritionData;
  // THÊM MỚI: Dữ liệu giả cho tags
  final List<String> _tags = ['Healthy', 'Vietnamese', 'Quick Meal', 'Lunch'];

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _commentFocusNode = FocusNode();
    
    // Khởi tạo dữ liệu dinh dưỡng giả
    _nutritionData = {
      'calories': 485,
      'carbs_percent': 48,
      'fat_percent': 37,
      'protein_percent': 15,
      'carbs': 58.2,
      'protein': 18.1,
      'fat': 8.5,
      'saturated_fat': 2.8,
      'unsaturated_fat': 5.7,
      'trans_fat': 0.1,
      'sugars': 7.5,
      'fiber': 2.5,
      'cholesterol': 10,
      'sodium': 320,
    };
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kColorBackground,
        body: Stack(
          children: [
            // Lớp 1: Ảnh nền
            _buildBackgroundImage(),
            // Lớp 2: Nội dung cuộn
            _buildContentScrollable(context),
            // Lớp 3: Các nút bấm (Back, Favorite)
            _buildOverlayButtons(context),
          ],
        ),
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI ---

  // Lớp 1: Ảnh nền
  Widget _buildBackgroundImage() {
    return Container(
      width: double.infinity,
      height: 400.0,
      decoration: const BoxDecoration(
        color: kColorAlternate, // Màu nền lót khi ảnh chưa tải
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            'https://images.unsplash.com/photo-1630563775062-bbaf8ad3d73c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI2ODk3MjN8&ixlib=rb-4.1.0&q=80&w=1080',
          ),
        ),
      ),
    );
  }

  // Lớp 3: Các nút bấm trên ảnh
  Widget _buildOverlayButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nút Back
            _buildCircleButton(
              icon: Icons.keyboard_arrow_left,
              color: kColorInfo,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Nút Favorite
            _buildCircleButton(
              icon: _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? kColorError : kColorInfo, // Đổi màu
              onPressed: () {
                setState(() {
                  _isFavorited = !_isFavorited;
                });
                
                // SỬA ĐỔI: Thêm Flow (Luồng)
                if (_isFavorited) {
                  // TODO: Thêm logic lưu vào database
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MarkdownRecipeScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hàm trợ giúp tạo nút tròn
  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44.0,
      height: 44.0,
      decoration: const BoxDecoration(
        color: kColorOverlay, // Nền đen mờ
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 24.0),
        onPressed: onPressed,
      ),
    );
  }

  // Lớp 2: Nội dung cuộn
  Widget _buildContentScrollable(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Khoảng trống đẩy card nội dung xuống dưới ảnh
          const SizedBox(height: 320.0),
          // Card nội dung chính
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: kColorBackground, // SỬA ĐỔI: Màu nền
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecipeInfo(),
                  const SizedBox(height: 16.0),
                  _buildDescription(),
                  
                  // THÊM MỚI: Thêm Tags (Thẻ)
                  const SizedBox(height: 24.0),
                  _buildSectionTitle('Tags'),
                  const SizedBox(height: 16.0),
                  _buildTagsSection(),
                  
                  const SizedBox(height: 32.0),
                  _buildIngredientsSection(),
                  const SizedBox(height: 32.0),
                  _buildInstructionsSection(),
                  
                  // SỬA ĐỔI: Nâng cấp Nutrition
                  const SizedBox(height: 32.0),
                  _buildNutritionSection(),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC PHẦN CỦA CARD NỘI DUNG ---

  // Tên, thời gian, đánh giá
  Widget _buildRecipeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Creamy Mushroom Pasta',
          style: GoogleFonts.interTight(
            fontSize: 32.0, // displaySmall
            fontWeight: FontWeight.w600,
            color: kColorPrimaryText,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildInfoChip(Icons.access_time_rounded, '25 mins', kColorRatingStar),
            const SizedBox(width: 16.0),
            _buildInfoChip(Icons.restaurant_rounded, '4 servings', kColorPrimary),
            const SizedBox(width: 16.0),
            _buildInfoChip(Icons.star_rounded, '4.8 (127)', kColorSuccess),
          ],
        ),
      ],
    );
  }

  // Hàm trợ giúp cho (thời gian, khẩu phần, đánh giá)
  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16.0),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: GoogleFonts.inter(
            color: kColorSecondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Mô tả
  Widget _buildDescription() {
    return Text(
      'A rich and creamy pasta dish featuring sautéed mushrooms in a savory garlic sauce. Perfect for a quick weeknight dinner.',
      style: GoogleFonts.inter(
        color: kColorPrimaryText, // bodyMedium
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  // THÊM MỚI: Phần Tags
  Widget _buildTagsSection() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _tags.map((tag) => _buildTagChip(tag)).toList(),
    );
  }

  // Hàm trợ giúp cho 1 Thẻ (Tag)
  Widget _buildTagChip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: GoogleFonts.inter(
        color: kColorPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: kColorPrimary.withOpacity(0.1),
      side: const BorderSide(color: kColorPrimary, width: 1.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    );
  }


  // Tiêu đề chung (Ingredients, Instructions...)
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.interTight(
        color: kColorPrimaryText,
        fontSize: 22.0, // titleLarge
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
    );
  }

  // Phần Nguyên liệu
  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Ingredients'),
        const SizedBox(height: 16.0),
        _buildIngredientItem('400g pasta (penne or fettuccine)'),
        _buildIngredientItem('300g mixed mushrooms, sliced'),
        _buildIngredientItem('3 cloves garlic, minced'),
        _buildIngredientItem('200ml heavy cream'),
        _buildIngredientItem('50g parmesan cheese, grated'),
        _buildIngredientItem('2 tbsp olive oil'),
        _buildIngredientItem('Fresh thyme and parsley'),
        _buildIngredientItem('Salt and pepper to taste'),
      ],
    );
  }

  // Hàm trợ giúp cho một mục nguyên liệu
  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 6.0,
            height: 6.0,
            margin: const EdgeInsets.only(top: 6.0, right: 12.0),
            decoration:
                const BoxDecoration(color: kColorPrimary, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 14.0, color: kColorPrimaryText),
            ),
          ),
        ],
      ),
    );
  }

  // Phần Hướng dẫn
  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Instructions'),
        const SizedBox(height: 16.0),
        _buildInstructionItem('1',
            'Cook pasta according to package directions. Drain, reserving 1/4 cup of pasta water.'),
        _buildInstructionItem('2',
            'Heat olive oil in a large pan over medium heat. Add mushrooms and cook until browned (about 5-7 minutes).'),
        _buildInstructionItem('3',
            'Add minced garlic and cook for another minute until fragrant.'),
        _buildInstructionItem('4',
            'Pour in heavy cream and bring to a simmer. Let it thicken slightly (about 3-4 minutes).'),
        _buildInstructionItem('5',
            'Add parmesan cheese and fresh herbs. Stir until the cheese is melted and the sauce is smooth.'),
      ],
    );
  }

  // Hàm trợ giúp cho một mục hướng dẫn
  Widget _buildInstructionItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration:
                const BoxDecoration(color: kColorPrimary, shape: BoxShape.circle),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.inter(
                  color: kColorInfo,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: kColorPrimaryText,
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SỬA ĐỔI: Phần Thông tin Dinh dưỡng (Dùng Pie Chart)
  Widget _buildNutritionSection() {
    // (Lấy data từ initState)
    final data = _nutritionData ?? {};
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Nutrition Information'),
        const SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kColorCard,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Biểu đồ tròn
                SizedBox(
                  height: 150,
                  child: _buildPieChart(data),
                ),
                const SizedBox(height: 16.0),
                _buildPieChartLegend(),
                
                const SizedBox(height: 24.0),
                
                // Dropdown "Show All"
                Theme( 
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      'Show All Nutrients',
                       style: GoogleFonts.inter(
                        color: kColorSecondaryText,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),
                    ),
                    children: [
                      _buildNutritionRow('Calories', '${data['calories']} kcal'),
                      _buildNutritionRow('Carbs', '${data['carbs']} g'),
                      _buildNutritionRow('Protein', '${data['protein']} g'),
                      _buildNutritionRow('Total fat', '${data['fat']} g'),
                      _buildNutritionRow('Saturated fat', '${data['saturated_fat']} g'),
                      _buildNutritionRow('Unsaturated fat', '${data['unsaturated_fat']} g'),
                      _buildNutritionRow('Trans fat', '${data['trans_fat']} g'),
                      _buildNutritionRow('Sugars', '${data['sugars']} g'),
                      _buildNutritionRow('Fiber', '${data['fiber']} g'),
                      _buildNutritionRow('Cholesterol', '${data['cholesterol']} mg'),
                      _buildNutritionRow('Sodium', '${data['sodium']} mg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Hàm trợ giúp cho một hàng dinh dưỡng (Dropdown)
  Widget _buildNutritionRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              color: kColorSecondaryText,
              fontWeight: FontWeight.w500,
              fontSize: 14.0
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: kColorPrimaryText,
              fontWeight: FontWeight.w600,
              fontSize: 14.0
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC HÀM CHO BIỂU ĐỒ (fl_chart) ---

  Widget _buildPieChart(Map<String, dynamic> data) {
    final double protein = (data['protein_percent'] ?? 33.0).toDouble();
    final double carbs = (data['carbs_percent'] ?? 33.0).toDouble();
    final double fat = (data['fat_percent'] ?? 34.0).toDouble();

    final List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: kColorProtein, // Cam
        value: protein,
        title: '${protein.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, color: kColorInfo, fontSize: 12),
      ),
      PieChartSectionData(
        color: kChartCarbs, // Xanh dương
        value: carbs,
        title: '${carbs.toStringAsFixed(0)}%',
        radius: 50,
         titleStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, color: kColorInfo, fontSize: 12),
      ),
       PieChartSectionData(
        color: kChartFat, // Vàng
        value: fat,
        title: '${fat.toStringAsFixed(0)}%',
        radius: 50,
         titleStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, color: kColorInfo, fontSize: 12),
      ),
    ];

    return PieChart(
      PieChartData(
        sectionsSpace: 4, 
        centerSpaceRadius: 40, 
        sections: sections,
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            // (Tùy chọn)
          },
        ),
      ),
    );
  }

  Widget _buildPieChartLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Indicator(color: kColorProtein, text: 'Protein', isSquare: false),
        _Indicator(color: kChartCarbs, text: 'Carbs', isSquare: false),
        _Indicator(color: kChartFat, text: 'Fat', isSquare: false),
      ],
    );
  }


  // Hàm trợ giúp cho một mục bình luận
  Widget _buildCommentItem(
      String name, String time, String comment, String imageUrl) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kColorCard,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: kColorPrimaryText,
                          ),
                        ),
                        Text(
                          time,
                          style: GoogleFonts.inter(
                            color: kColorSecondaryText,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    // Hàng sao đánh giá (giả)
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < 4 ? Icons.star_rounded : Icons.star_border_rounded,
                          color: kColorRatingStar,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          // Nội dung bình luận
          Text(
            comment,
            style: GoogleFonts.inter(
              color: kColorPrimaryText,
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12.0),
          // Nút Like và Reply
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, size: 18, color: kColorSecondaryText),
              const SizedBox(width: 4),
              Text(
                'Like',
                style: GoogleFonts.inter(color: kColorSecondaryText, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.comment_outlined, size: 18, color: kColorSecondaryText),
              const SizedBox(width: 4),
              Text(
                'Reply',
                style: GoogleFonts.inter(color: kColorSecondaryText, fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const _Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF57636C),
          ),
        )
      ],
    );
  }
}