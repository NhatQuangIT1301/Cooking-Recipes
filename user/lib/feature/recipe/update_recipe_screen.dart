import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// THÊM MỚI: Import 2 thư viện (giống add_recipe_screen)
import 'package:fl_chart/fl_chart.dart';

// --- Định nghĩa màu sắc (trích xuất từ FlutterFlow) ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorAppBar = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorBorder = Color(0xFFE0E3E7);
const Color kColorPrimary = Color(0xFF568C4C);
const Color kColorSecondary = Color(0xFF45B7D1);
const Color kColorError = Color(0xFFFF5963);
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorInfo = Colors.white;

// THÊM MỚI: Màu cho biểu đồ
const Color kChartFat = Color(0xFFFBC02D); // Vàng
const Color kChartCarbs = Color(0xFF0288D1); // Xanh dương
const Color kColorProtein = Color(0xFFE64A19); // Cam

// --- Dữ liệu giả (Mock Data) cho các lựa chọn (Giống AddRecipe) ---
const Map<String, List<String>> kCategoryGroups = {
  'Bữa ăn (Meal Time)': ['Bữa sáng', 'Bữa trưa', 'Bữa tối', 'Ăn vặt', 'Khai vị', 'Tráng miệng'],
  'Phong cách/Khẩu vị (Style/Suitability)': ['Món mặn', 'Món canh', 'Món xào', 'Món nhậu', 'Ăn chay', 'Healthy', 'Đồ uống'],
};
const List<String> kTimeOptions = [
  'Dưới 15 phút',
  '15-30 phút',
  '30-60 phút',
  'Trên 1 giờ'
];
// SỬA ĐỔI: Thêm list cho Servings
final List<String> kServingsOptions = 
  List.generate(12, (index) => '${index + 1} ${index == 0 ? "person" : "people"}');

class UpdateRecipeScreen extends StatefulWidget {
  // THÊM MỚI: Nhận dữ liệu công thức cần sửa
  final Map<String, String> recipe;

  const UpdateRecipeScreen({
    super.key,
    required this.recipe, // Bắt buộc phải có
  });

  @override
  State<UpdateRecipeScreen> createState() => _UpdateRecipeScreenState();
}

// Lớp (class) để quản lý các controller của hàng Ingredient
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

class _UpdateRecipeScreenState extends State<UpdateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  // --- SỬA ĐỔI STATE (Giống AddRecipe) ---
  List<String> _selectedCategories = [];
  String? _selectedTime;
  String? _selectedServings; // Sửa từ Controller -> String
  final List<IngredientController> _ingredientRows = []; 
  Map<String, dynamic>? _nutritionData; 

  @override
  void initState() {
    super.initState();
    
    // --- SỬA ĐỔI: Khởi tạo controller với dữ liệu cũ từ 'widget.recipe' ---
    _nameController = TextEditingController(text: widget.recipe['title']);
    _descriptionController = TextEditingController(text: widget.recipe['description']);
    
    // SỬA LỖI: Kiểm tra giá trị cũ trước khi gán cho Dropdown
    String? oldTime = widget.recipe['minutes'];
    if (kTimeOptions.contains(oldTime)) {
      _selectedTime = oldTime;
    } else {
      // Nếu "25 min" (cũ) không có trong list, hãy chọn "15-30 phút"
      _selectedTime = kTimeOptions[1]; // Mặc định là '15-30 phút'
    }

    // SỬA LỖI: Gán giá trị Dropdown cho Servings
    String? oldServings = widget.recipe['servings'];
    if (kServingsOptions.contains(oldServings)) {
      _selectedServings = oldServings;
    } else {
      _selectedServings = "4 people"; // Mặc định
    }

    // Xử lý Category (Tags)
    if (widget.recipe['category'] != null && widget.recipe['category']!.isNotEmpty) {
      _selectedCategories = [widget.recipe['category']!];
    }
    
    // Xử lý Ingredients (Nguyên liệu)
    _addIngredientRow(
      name: widget.recipe['ingredients'] ?? '', // Đưa chuỗi cũ vào ô Tên
      quantity: '', // Để trống số lượng
    );

    // Khởi tạo dữ liệu dinh dưỡng giả
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    
    for (var row in _ingredientRows) {
      row.dispose();
    }
    super.dispose();
  }

  // --- HÀM LOGIC ---

  // SỬA ĐỔI: Hàm thêm hàng (cho phép truyền giá trị ban đầu)
  void _addIngredientRow({String name = '', String quantity = ''}) {
    setState(() {
      final newController = IngredientController();
      newController.name.text = name;
      newController.quantity.text = quantity;
      _ingredientRows.add(newController);
    });
  }

  void _removeIngredientRow(int index) {
    setState(() {
      _ingredientRows[index].dispose();
      _ingredientRows.removeAt(index);
    });
  }

  // Hàm xử lý "Update"
  void _updateRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipeName = _nameController.text;
      final servings = _selectedServings; 
      final description = _descriptionController.text;
      
      final ingredients = _ingredientRows.map((row) {
        return {
          'name': row.name.text, 
          'quantity': row.quantity.text,
        };
      }).toList();
      
      print('Recipe UPDATED: $recipeName');
      print('Servings: $servings');
      print('Categories: $_selectedCategories');
      print('Time: $_selectedTime');
      print('Description: $description');
      print('Ingredients: $ingredients');
      print('Nutrition: $_nutritionData');
      
      // TODO: Gửi dữ liệu CẬP NHẬT này lên server (Node.js)

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
            'Update Recipe', // Sửa tiêu đề
            style: GoogleFonts.interTight(
              color: kColorPrimaryText,
              fontWeight: FontWeight.w600,
              fontSize: 22.0,
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
                    // 1. Image Picker (Giữ nguyên logic hiển thị ảnh cũ)
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

                    _buildSectionTitle('Ingredients (Nguyên liệu)'),
                    _buildIngredientList(), // Danh sách
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton.icon(
                        icon: const Icon(Icons.add, color: kColorPrimary),
                        label: Text('Add Ingredient', style: GoogleFonts.inter(color: kColorPrimary, fontWeight: FontWeight.w600)),
                        onPressed: () => _addIngredientRow(), // Thêm hàng rỗng
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

  // SỬA ĐỔI: _buildImagePicker (giữ nguyên logic của Update)
  Widget _buildImagePicker() {
    // TODO: Cần thêm state để lưu ảnh MỚI (nếu người dùng chọn)
    return InkWell(
      onTap: () {
        print('Image Picker Tapped');
        // TODO: Thêm logic chọn ảnh (image_picker)
      },
      child: Container(
        width: double.infinity,
        height: 200.0,
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: kColorBorder, width: 2.0),
          // THAY ĐỔI: Hiển thị ảnh cũ nếu có
          image: (widget.recipe['imageUrl'] != null &&
                  widget.recipe['imageUrl']!.isNotEmpty)
              ? DecorationImage(
                  image: NetworkImage(widget.recipe['imageUrl']!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: (widget.recipe['imageUrl'] != null &&
                widget.recipe['imageUrl']!.isNotEmpty)
            ? null // Nếu có ảnh thì không cần hiển thị icon
            : Padding(
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
                        'Tap to change recipe image', // Sửa text
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

  // --- Xây dựng Category (Tags) (Giống AddRecipe) ---
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

  // --- Chú thích (comment out) thanh tìm kiếm ---
  /*
  Widget _buildIngredientSearch() {
    return typeahead.TypeAheadFormField<Map<String, String>>(
      // ... (code thanh tìm kiếm được chú thích) ...
    );
  }
  */

  // --- Danh sách Ingredients (nhập tay 7-3) ---
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

  // Hàm trợ giúp cho 1 hàng Ingredient (7-3) (NHẬP TAY)
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
          // Nút Xóa
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


  // Hàm trợ giúp cho phần Phân tích Dinh dưỡng
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
                  
                  SizedBox(
                    height: 150, 
                    child: _buildPieChart(),
                  ),
                  const SizedBox(height: 16.0),
                  _buildPieChartLegend(),
                  
                  const SizedBox(height: 24.0),
                  
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

  // Hàm trợ giúp cho một hàng dinh dưỡng
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

  // Hàm trợ giúp cho các nút bấm cuối form (SỬA ĐỔI)
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
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
            onPressed: _updateRecipe, // SỬA ĐỔI: Gọi hàm _updateRecipe
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50.0),
              backgroundColor: kColorPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Update', // SỬA ĐỔI: Chữ trên nút
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