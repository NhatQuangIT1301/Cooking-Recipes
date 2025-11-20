import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DỮ LIỆU GIẢ LẬP (MOCK DATA) ---
// Sau này bạn sẽ thay thế cái này bằng dữ liệu lấy từ API Node.js về
class ScannedProduct {
  final String name;
  final String image;
  final double calories; // per serving
  final double carbs;
  final double fat;
  final double protein;
  final double salt;
  final String servingUnit; // e.g., "hộp", "gói", "gram"

  ScannedProduct({
    required this.name,
    required this.image,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.salt,
    required this.servingUnit,
  });
}

class BarcodeResultScreen extends StatefulWidget {
  // Nhận barcode từ màn hình trước (nếu cần)
  final String? barcode; 

  const BarcodeResultScreen({super.key, this.barcode});

  @override
  State<BarcodeResultScreen> createState() => _BarcodeResultScreenState();
}

class _BarcodeResultScreenState extends State<BarcodeResultScreen> {
  // --- GIẢ LẬP DỮ LIỆU TỪ API ---
  final ScannedProduct _product = ScannedProduct(
    name: "Margarine (Benecol margarine)",
    image: "https://cdn-icons-png.flaticon.com/512/1046/1046751.png", // Ảnh minh họa
    calories: 1120, // Calo gốc cho 1 đơn vị
    carbs: 0,
    fat: 128,
    protein: 0,
    salt: 4.4,
    servingUnit: "container (236g)",
  );

  // --- STATE QUẢN LÝ SỐ LƯỢNG ---
  final TextEditingController _quantityController = TextEditingController(text: "1");
  String _selectedUnit = "container (236g)";
  
  // Biến để tính toán lại dinh dưỡng khi số lượng thay đổi
  double _currentMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(() {
      setState(() {
        double? val = double.tryParse(_quantityController.text);
        _currentMultiplier = (val != null && val > 0) ? val : 0;
      });
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  // --- MÀU SẮC THEO ẢNH MẪU (DARK THEME) ---
  final Color kBgColor = const Color(0xFF151522); // Nền tối
  final Color kCardColor = const Color(0xFF222232); // Nền card
  final Color kPrimaryColor = const Color(0xFF568C4C); // Màu tím nút bấm
  final Color kTextWhite = Colors.white;
  final Color kTextGrey = const Color(0xFF9E9EA5);
  
  final Color kColorFat = const Color(0xFFFACC15); // Vàng
  final Color kColorCarb = const Color(0xFF3B82F6); // Xanh dương
  final Color kColorProtein = const Color(0xFFEF4444); // Đỏ

  @override
  Widget build(BuildContext context) {
    // Tính toán giá trị hiển thị
    double displayCal = _product.calories * _currentMultiplier;
    double displayFat = _product.fat * _currentMultiplier;
    double displayCarb = _product.carbs * _currentMultiplier;
    double displayProtein = _product.protein * _currentMultiplier;
    double displaySalt = _product.salt * _currentMultiplier;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Nguyên liệu", style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 1. HÌNH ẢNH & TÊN
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(_product.image, height: 80, width: 80),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _product.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: kTextWhite, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 24),

                  // 2. VÒNG TRÒN CALO & MACROS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Vòng tròn Calo
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: 1.0, // Full circle
                              strokeWidth: 6,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.shade700),
                              backgroundColor: Colors.grey.shade800,
                            ),
                          ),
                          Column(
                            children: [
                              Text(displayCal.toStringAsFixed(0), style: GoogleFonts.inter(color: kTextWhite, fontWeight: FontWeight.bold, fontSize: 18)),
                              Text("Cal", style: GoogleFonts.inter(color: kTextGrey, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                      
                      // 3 Chỉ số Macro
                      _buildMacroColumn("CHẤT ĐẠM", "${displayProtein.toStringAsFixed(1)} g", kColorProtein),
                      _buildMacroColumn("ĐƯỜNG BỘT", "${displayCarb.toStringAsFixed(1)} g", kColorCarb),
                      _buildMacroColumn("CHẤT BÉO", "${displayFat.toStringAsFixed(1)} g", kColorFat),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 3. BẢNG GIÁ TRỊ DINH DƯỠNG CHI TIẾT
                  Align(alignment: Alignment.centerLeft, child: Text("Giá trị dinh dưỡng", style: GoogleFonts.inter(color: kTextWhite, fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 16),
                  
                  _buildNutriRow("Năng lượng", "${displayCal.toStringAsFixed(0)} cal", isBold: true),
                  const Divider(color: Colors.white24),
                  _buildNutriRow("Đường bột (carb)", displayCarb == 0 ? "--" : "${displayCarb.toStringAsFixed(1)} g"),
                  _buildNutriRow("  Chất xơ", "--", isSub: true), // Giả sử ko có data
                  _buildNutriRow("  Đường", "--", isSub: true),
                  const Divider(color: Colors.white24),
                  _buildNutriRow("Chất béo (fat)", "${displayFat.toStringAsFixed(2)} g", isBold: true),
                  const Divider(color: Colors.white24),
                  _buildNutriRow("Chất đạm (protein)", displayProtein == 0 ? "--" : "${displayProtein.toStringAsFixed(1)} g"),
                  const Divider(color: Colors.white24),
                  _buildNutriRow("Cholesterol", "--"),
                  const Divider(color: Colors.white24),
                  _buildNutriRow("Muối", "${displaySalt.toStringAsFixed(1)} g"),

                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.warning_amber_rounded, color: Colors.blue),
                    label: const Text("Báo lỗi", style: TextStyle(color: Colors.blue)),
                  ),
                  const SizedBox(height: 80), // Khoảng trống để không bị che bởi bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // 4. THANH CÔNG CỤ PHÍA DƯỚI (Sticky Bottom)
      bottomSheet: Container(
        color: kCardColor, // Màu nền của thanh dưới
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Khẩu phần tuỳ chỉnh", style: TextStyle(color: kTextGrey, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              children: [
                // Ô nhập số lượng
                Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(color: kBgColor, borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kTextWhite, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Dropdown đơn vị
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: kBgColor, borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedUnit,
                        dropdownColor: kCardColor,
                        icon: Icon(Icons.keyboard_arrow_down, color: kTextGrey),
                        style: TextStyle(color: kTextWhite),
                        items: ["container (236g)", "gram", "muỗng canh"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedUnit = val!);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Nút Thêm vào
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final newItem = {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': _product.name,
                    'quantity': "${_currentMultiplier.toStringAsFixed(1)} $_selectedUnit",
                    'image': _product.image,
                    'expirationDate': DateTime.now().add(const Duration(days: 7)), 
                    'category': 'Khác' // Hoặc lấy từ API nếu có
                  };
                  // TODO: Logic thêm vào Database hoặc trả về màn hình trước
                  Navigator.pop(context, newItem);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã thêm ${_product.name}")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text("Thêm vào", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // Widget hiển thị 1 cột Macro (Đạm/Đường/Béo)
  Widget _buildMacroColumn(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          child: const Text("0%", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)), // Phần trăm giả
        ),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.inter(color: kTextWhite, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.flash_on, size: 12, color: kTextGrey), // Icon minh họa
            Text(label, style: GoogleFonts.inter(color: kTextGrey, fontSize: 10)),
          ],
        )
      ],
    );
  }

  // Widget hiển thị 1 dòng trong bảng dinh dưỡng
  Widget _buildNutriRow(String label, String value, {bool isBold = false, bool isSub = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isSub ? kTextGrey : kTextWhite,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: kTextWhite,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal
            ),
          ),
        ],
      ),
    );
  }
}