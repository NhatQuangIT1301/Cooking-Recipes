import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// THÊM MỚI: Import 2 thư viện
import 'package:fl_chart/fl_chart.dart';
// SỬA ĐỔI: Thêm 'as' để tránh xung đột tên (nếu bạn chạy pub get)

// --- Định nghĩa màu sắc (trích xuất từ FlutterFlow) ---
const Color kColorBackground = Color(0xFFF1F4F8); // Đổi nền 1 chút
const Color kColorAppBar = Color(0xFFF1F4F8); // primaryBackground
const Color kColorCard = Color(0xFFFFFFFF); // secondaryBackground
const Color kColorBorder = Color(0xFFE0E3E7); // alternate
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh (từ file settings)
const Color kColorSecondary = Color(0xFF45B7D1); // Màu xanh dương (từ chart)
const Color kColorError = Color(0xFFFF5963);
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorInfo = Colors.white; // Màu chữ của nút Submit

// THÊM MỚI: Màu cho biểu đồ (copy từ onboarding_flow)
const Color kChartFat = Color(0xFFFBC02D); // Vàng
const Color kChartCarbs = Color(0xFF0288D1); // Xanh dương
const Color kColorProtein = Color(0xFFE64A19); // Cam

// --- Dữ liệu giả (Mock Data) cho các lựa chọn ---
// SỬA ĐỔI: Dữ liệu Tags (phân loại theo món Việt)
const Map<String, List<String>> kCategoryGroups = {
  'Bữa ăn (Meal Time)': [
    'Bữa sáng',
    'Bữa trưa',
    'Bữa tối',
    'Ăn vặt', // Snack
    'Khai vị', // Appetizer
    'Tráng miệng', // Dessert
  ],
  'Phong cách/Khẩu vị (Style/Suitability)': [
    'Món mặn', // Main course
    'Món canh', // Soup
    'Món xào', // Stir-fry
    'Món nhậu', // Drinking food
    'Ăn chay', // Vegetarian
    'Healthy',
    'Đồ uống', // Drinks
  ],
};
const List<String> kTimeOptions = [
  'Dưới 15 phút',
  '15-30 phút',
  '30-60 phút',
  'Trên 1 giờ'
];

// THÊM MỚI: Dữ liệu cho Servings Dropdown (1 đến 12 người)
final List<String> kServingsOptions = 
  List.generate(12, (index) => '${index + 1} ${index == 0 ? "person" : "people"}');

// THÊM MỚI: Dữ liệu giả cho tìm kiếm Nguyên liệu (để ở dạng chú thích)

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

// SỬA LỖI: Quay lại IngredientController cũ
class IngredientController {
  final TextEditingController name;
  final TextEditingController quantity;

  IngredientController()
      : name = TextEditingController(),
        quantity = TextEditingController();
  
  void dispose() {
    name.dispose();
    quantity.dispose();
  }
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  // SỬA ĐỔI: Xóa Servings Controller
  // late TextEditingController _servingsController;

  // --- SỬA ĐỔI STATE ---
  final List<String> _selectedCategories = [];
  String? _selectedTime;
  // SỬA ĐỔI: Thêm state cho Servings
  String? _selectedServings;
  final List<IngredientController> _ingredientRows = []; 
  Map<String, dynamic>? _nutritionData; 

  // SỬA LỖI: Controller cho thanh tìm kiếm (để ở dạng chú thích)
  // final TextEditingController _ingredientSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    // SỬA ĐỔI: Đặt giá trị mặc định cho dropdown
    _selectedServings = "4 people"; // (tương đương 4 người)
    
    _addIngredientRow(); // Thêm 1 hàng nhập tay
    
    // Khởi tạo dữ liệu dinh dưỡng giả
    _nutritionData = {
      'calories': 172,
      'carbs_percent': 66, // (66%)
      'fat_percent': 24, // (24%)
      'protein_percent': 10, // (10%)
      'carbs': 23.4,
      'protein': 3.7,
      'fat': 8.5,
      'saturated_fat': 2.8,
      'unsaturated_fat': 5.7,
      'trans_fat': 0.1,
      'sugars': 7.5,
      'fiber': 2.5,
      'cholesterol': 10,
      'sodium': 472,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    // SỬA ĐỔI: Xóa Servings Controller
    // _servingsController.dispose();
    
    for (var row in _ingredientRows) {
      row.dispose();
    }
    super.dispose();
  }

  // --- HÀM LOGIC ---

  // SỬA LỖI: Hàm thêm hàng (nhập tay)
  void _addIngredientRow() {
    setState(() {
      _ingredientRows.add(IngredientController());
    });
  }

  // Xóa một hàng nguyên liệu
  void _removeIngredientRow(int index) {
    setState(() {
      _ingredientRows[index].dispose();
      _ingredientRows.removeAt(index);
    });
  }

  // Hàm xử lý "Submit"
  void _submitRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipeName = _nameController.text;
      // SỬA ĐỔI: Lấy data từ state
      final servings = _selectedServings; 
      final description = _descriptionController.text;
      
      // SỬA LỖI: Lấy text từ controller
      final ingredients = _ingredientRows.map((row) {
        return {
          'name': row.name.text, 
          'quantity': row.quantity.text,
        };
      }).toList();
      
      print('Recipe Name: $recipeName');
      print('Servings: $servings'); // Đã cập nhật
      print('Categories: $_selectedCategories');
      print('Time: $_selectedTime');
      print('Description: $description');
      print('Ingredients: $ingredients');
      print('Nutrition: $_nutritionData');
      
      // TODO: Gửi dữ liệu này lên server (Node.js)

      Navigator.of(context).pop();
    }
  }
  
  // Hàm giả lập gọi API
  void _analyzeNutrition() {
    // TODO: Gọi API Dinh dưỡng
    print('Analyze Nutrition Tapped');
    
    setState(() {
      _nutritionData = {
        'calories': 172,
        'carbs_percent': 66,
        'fat_percent': 24,
        'protein_percent': 10,
        'carbs': 23.4,
        'protein': 3.7,
        'fat': 8.5,
        'saturated_fat': 2.8,
        'unsaturated_fat': 5.7,
        'trans_fat': 0.1,
        'sugars': 7.5,
        'fiber': 2.5,
        'cholesterol': 10,
        'sodium': 472,
      };
    });
  }

  // SỬA LỖI: Chú thích hàm _getIngredientSuggestions
  /*
  Future<List<Map<String, String>>> _getIngredientSuggestions(String pattern) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (pattern.isEmpty) {
      return [];
    }
    return kIngredientDatabase
        .where((item) =>
            item['name']!.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }
  */
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kColorBackground,
        appBar: AppBar(
          backgroundColor: kColorAppBar,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: kColorPrimaryText,
              size: 20.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Add Recipe',
            style: GoogleFonts.interTight(
              color: kColorPrimaryText,
              fontWeight: FontWeight.w600,
              fontSize: 22.0, // titleLarge
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    // 1. Image Picker
                    _buildImagePicker(),
                    const SizedBox(height: 20.0),

                    // 2. Form Fields
                    _buildTextField(
                      controller: _nameController,
                      label: 'Recipe Name',
                      hint: 'Enter recipe name',
                    ),
                    const SizedBox(height: 20.0),
                    
                    // SỬA ĐỔI: Dùng Dropdown cho Servings
                    _buildDropdownField(
                      label: 'Servings (Khẩu phần)',
                      hint: 'Select servings',
                      value: _selectedServings,
                      items: kServingsOptions, // Dùng list 1-12
                      onChanged: (value) {
                        setState(() => _selectedServings = value);
                      },
                    ),
                    
                    const SizedBox(height: 20.0),

                    // SỬA ĐỔI: Category (Tags)
                    _buildSectionTitle('Category'),
                    _buildCategorySection(),
                    
                    const SizedBox(height: 20.0),
                    
                    _buildDropdownField(
                      label: 'Cooking Time (Thời gian nấu)',
                      hint: 'Select cooking time',
                      value: _selectedTime,
                      items: kTimeOptions,
                      onChanged: (value) {
                        setState(() => _selectedTime = value);
                      },
                    ),
                    
                    const SizedBox(height: 20.0),

                    // SỬA ĐỔI: Ingredients (Dynamic List)
                    _buildSectionTitle('Ingredients (Nguyên liệu)'),
                    
                    // SỬA LỖI: Xóa thanh tìm kiếm (chỉ để lại danh sách)
                    // _buildIngredientSearch(), 
                    
                    const SizedBox(height: 12.0),
                    _buildIngredientList(), // Danh sách
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton.icon(
                        icon: const Icon(Icons.add, color: kColorPrimary),
                        label: Text('Add Ingredient', style: GoogleFonts.inter(color: kColorPrimary, fontWeight: FontWeight.w600)),
                        onPressed: _addIngredientRow, // Nút thêm hàng
                      ),
                    ),

                    const SizedBox(height: 20.0),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Instructions (Hướng dẫn)',
                      hint: 'Step 1...\nStep 2...\nStep 3...',
                      minLines: 5,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 20.0),

                    // 3. Nutrition Section
                    _buildNutritionSection(),
                    const SizedBox(height: 20.0),

                    // 4. Action Buttons
                    _buildActionButtons(),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- CÁC HÀM TRỢ GIÚP (HELPER) ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: kColorSecondaryText,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: () {
        // TODO: Thêm logic chọn ảnh (camera/gallery)
        print('Image Picker Tapped');
      },
      child: Container(
        width: double.infinity,
        height: 200.0,
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: kColorBorder, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                color: kColorSecondaryText,
                size: 48.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Tap to add recipe image',
                  style: GoogleFonts.inter(
                    color: kColorSecondaryText,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int minLines = 1,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Style cho label
    final labelStyle = GoogleFonts.inter(
      color: kColorSecondaryText,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    );
    // Style cho hint/text
    final textStyle = GoogleFonts.inter(
      color: kColorPrimaryText,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        hintText: hint,
        hintStyle: textStyle.copyWith(color: kColorSecondaryText),
        filled: true,
        fillColor: kColorCard,
        contentPadding: const EdgeInsets.all(16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorPrimary, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorError, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorError, width: 1.0),
        ),
      ),
      style: textStyle,
      cursorColor: kColorPrimary,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  // --- SỬA ĐỔI: Xây dựng Category (Tags) ---
  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: kColorCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: kColorBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: kCategoryGroups.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 12.0, left: 4.0),
                child: Text(
                  entry.key, // Tên Nhóm (ví dụ: "Bữa ăn")
                  style: GoogleFonts.inter(
                    color: kColorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: entry.value.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? Colors.white : kColorPrimaryText,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: kColorBackground,
                    selectedColor: kColorPrimary,
                    showCheckmark: false,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected ? kColorPrimary : kColorBorder,
                        width: 1.0,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8.0),
            ],
          );
        }).toList(),
      ),
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
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item,
              style: GoogleFonts.inter(
                  color: kColorPrimaryText, fontSize: 16.0)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            GoogleFonts.inter(color: kColorSecondaryText, fontSize: 14.0),
        hintText: hint,
        hintStyle:
            GoogleFonts.inter(color: kColorSecondaryText, fontSize: 16.0),
        filled: true,
        fillColor: kColorCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorPrimary, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select an option';
        }
        return null;
      },
    );
  }

  // --- SỬA LỖI: Chú thích (comment out) thanh tìm kiếm ---
  /*
  Widget _buildIngredientSearch() {
    return typeahead.TypeAheadFormField<Map<String, String>>(
      // SỬA LỖI: Dùng cú pháp v5+
      controller: _ingredientSearchController,
      style: GoogleFonts.inter(
        color: kColorPrimaryText,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: 'Search & add ingredients...',
        hintStyle: GoogleFonts.inter(color: kColorSecondaryText, fontSize: 16.0),
        prefixIcon: const Icon(Icons.search, color: kColorSecondaryText),
        filled: true,
        fillColor: kColorCard,
        contentPadding: const EdgeInsets.all(16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kColorPrimary, width: 1.0),
        ),
      ),
      suggestionsCallback: (pattern) async {
        // TODO: Thay thế bằng API call
        // return _getIngredientSuggestions(pattern);
        return []; // Tạm thời trả về rỗng
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Image.network(suggestion['image']!, width: 40, height: 40),
          title: Text(suggestion['name']!),
        );
      },
      onSelected: (suggestion) {
        // _addIngredientRow(suggestion); // Thêm vào danh sách
      },
    );
  }
  */

  // --- SỬA LỖI: Quay về _buildIngredientList (nhập tay 7-3) ---
  Widget _buildIngredientList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _ingredientRows.length,
      itemBuilder: (context, index) {
        return _buildIngredientRow(index);
      },
    );
  }

  // SỬA LỖI: Hàm trợ giúp cho 1 hàng Ingredient (7-3) (NHẬP TAY)
  Widget _buildIngredientRow(int index) {
    final rowController = _ingredientRows[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 70% (Tên nguyên liệu - Ghi tay)
          Expanded(
            flex: 7,
            child: _buildTextField(
              controller: rowController.name,
              label: 'Ingredient',
              hint: 'e.g., Chicken Breast',
            ),
          ),
          const SizedBox(width: 8.0),
          // 30% (Số lượng - Ghi tay)
          Expanded(
            flex: 3,
            child: _buildTextField(
              controller: rowController.quantity,
              label: 'Quantity',
              hint: 'e.g., 200g',
            ),
          ),
          // Nút Xóa (chỉ hiển thị nếu có nhiều hơn 1 hàng)
          if (_ingredientRows.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Căn nút
              child: IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: kColorError),
                onPressed: () => _removeIngredientRow(index),
              ),
            )
          else
            const SizedBox(width: 48), // Giữ chỗ
        ],
      ),
    );
  }


  // SỬA ĐỔI: Hàm trợ giúp cho phần Phân tích Dinh dưỡng
  Widget _buildNutritionSection() {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: _analyzeNutrition, // Gọi hàm
          icon: const Icon(Icons.analytics_outlined, color: kColorSecondary),
          label: Text(
            'Analyze Nutrition',
            style: GoogleFonts.interTight(
              color: kColorSecondary,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50.0),
            backgroundColor: kColorAppBar, // Màu nền nhạt
            side: const BorderSide(color: kColorSecondary, width: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        
        // SỬA ĐỔI: Hiển thị kết quả (nếu có)
        if (_nutritionData != null) ...[
          const SizedBox(height: 20.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: kColorCard,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: kColorBorder, width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Nutrition Analysis',
                    style: GoogleFonts.interTight(
                      color: kColorPrimaryText,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  
                  // SỬA ĐỔI: Biểu đồ tròn (fl_chart)
                  SizedBox(
                    height: 150, // Đặt chiều cao cho biểu đồ
                    child: _buildPieChart(),
                  ),
                  const SizedBox(height: 16.0),
                  _buildPieChartLegend(),
                  
                  const SizedBox(height: 24.0),
                  
                  // SỬA ĐỔI: Thêm ExpansionTile (Dropdown)
                  Theme( // Tùy chỉnh màu viền
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
                        // Dùng ListView
                        _buildNutritionRow('Calories', '${_nutritionData!['calories']} kcal'),
                        _buildNutritionRow('Carbs', '${_nutritionData!['carbs']} g'),
                        _buildNutritionRow('Protein', '${_nutritionData!['protein']} g'),
                        _buildNutritionRow('Total fat', '${_nutritionData!['fat']} g'),
                        _buildNutritionRow('Saturated fat', '${_nutritionData!['saturated_fat']} g'),
                        _buildNutritionRow('Unsaturated fat', '${_nutritionData!['unsaturated_fat']} g'),
                        _buildNutritionRow('Trans fat', '${_nutritionData!['trans_fat']} g'),
                        _buildNutritionRow('Sugars', '${_nutritionData!['sugars']} g'),
                        _buildNutritionRow('Fiber', '${_nutritionData!['fiber']} g'),
                        _buildNutritionRow('Cholesterol', '${_nutritionData!['cholesterol']} mg'),
                        _buildNutritionRow('Sodium', '${_nutritionData!['sodium']} mg'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ],
    );
  }

  // Hàm trợ giúp cho một hàng dinh dưỡng (giống recipe_detail)
  Widget _buildNutritionRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              color: kColorSecondaryText, // Màu xám
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

  // Hàm trợ giúp cho các nút bấm cuối form
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Nút Cancel = quay lại
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50.0),
              backgroundColor: kColorAppBar,
              side: const BorderSide(color: kColorError, width: 2.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.interTight(
                color: kColorError,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: ElevatedButton(
            onPressed: _submitRecipe, // Gọi hàm submit
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50.0),
              backgroundColor: kColorPrimary, // Màu xanh submit
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Submit',
              style: GoogleFonts.interTight(
                color: kColorInfo,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- CÁC HÀM CHO BIỂU ĐỒ (fl_chart) ---

  Widget _buildPieChart() {
    final data = _nutritionData ?? {};
    // Sửa lỗi: Chuyển đổi an toàn
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
        sectionsSpace: 4, // Khoảng cách giữa các phần
        centerSpaceRadius: 40, // Làm cho nó thành biểu đồ Donut
        sections: sections,
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            // (Tùy chọn: Thêm hiệu ứng khi nhấn vào)
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