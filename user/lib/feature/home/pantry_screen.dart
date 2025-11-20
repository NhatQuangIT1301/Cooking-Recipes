
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // THÊM MỚI (nếu chưa có)
import 'package:intl/intl.dart';
import '../scan/qr_scanner_screen.dart';
import '../scan/ingredient_scanner_screen.dart';
class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  // --- DỮ LIỆU GIẢ (MOCK DATA) ---
  final List<Map<String, dynamic>> _pantryItems = [
    {
      'id': '1', 'name': 'Thịt bò Mỹ', 'quantity': '500g',
      'image': 'https://cdn.tgdd.vn/2020/06/CookProduct/1200-1200x676-30.jpg',
      'expirationDate': DateTime.now().add(const Duration(days: 5)),
    },
    {
      'id': '2', 'name': 'Sữa tươi Vinamilk', 'quantity': '900ml',
      'image': 'https://cdn.tgdd.vn/Products/Images/2386/79569/bhx/sua-tuoi-tiet-trung-vinamilk-100-sua-tuoi-khong-duong-hop-1-lit-202104141423207811.jpg',
      'expirationDate': DateTime.now().add(const Duration(days: 2)),
    },
    {
      'id': '3', 'name': 'Cải bó xôi', 'quantity': '1 bó',
      'image': 'https://cdn.tgdd.vn/2021/08/CookProduct/cai-bo-xoi-la-gi-co-tac-dung-gi-cai-bo-xoi-nau-mon-gi-ngon-0-1200x676.jpg',
      'expirationDate': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '4', 'name': 'Trứng gà', 'quantity': '10 quả',
      'image': 'https://cdn.tgdd.vn/Products/Images/8687/236245/bhx/trung-ga-ta-v-food-hop-10-qua-202212061424242979.jpg',
      'expirationDate': DateTime.now().add(const Duration(days: 10)),
    },
  ];

  // --- THÊM MỚI: Biến trạng thái cho nút Gợi ý ---
  bool _isSuggesting = false;

  // --- LOGIC UI (Giữ nguyên) ---
  Color _getExpirationColor(DateTime expirationDate) {
    final now = DateTime.now();
    final difference = expirationDate.difference(now).inDays;
    if (difference < 0) return Colors.red.shade100;
    if (difference <= 3) return Colors.orange.shade100;
    return Colors.white;
  }
  
  Color _getTextColor(DateTime expirationDate) {
    final now = DateTime.now();
    final difference = expirationDate.difference(now).inDays;
    if (difference < 0) return Colors.red.shade700; 
    if (difference <= 3) return Colors.orange.shade800; 
    return Colors.green.shade700;
  }

  String _getStatusText(DateTime expirationDate) {
    final now = DateTime.now();
    final difference = expirationDate.difference(now).inDays;
    if (difference < 0) return "Đã hết hạn";
    if (difference == 0) return "Hết hạn hôm nay";
    if (difference <= 3) return "Còn $difference ngày";
    return DateFormat('dd/MM/yyyy').format(expirationDate);
  }

  void _deleteItem(int index) {
    setState(() {
      _pantryItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xóa nguyên liệu"), duration: Duration(seconds: 1)),
    );
  }

  // --- HÀM MỚI: GỌI GỢI Ý (GIẢ LẬP) ---
  Future<void> _showRecipeSuggestions() async {
    setState(() => _isSuggesting = true);

    // 1. Lấy tên các nguyên liệu
    final ingredientNames = _pantryItems.map((item) => item['name'] as String).toList();

    // 2. Giả lập AI/Backend làm việc (2 giây)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Dữ liệu món ăn giả lập (Mockup Recipes)
    final List<Map<String, dynamic>> suggestions = [
      {
        'name': 'Bò xào lúc lắc',
        'image': 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?w=300',
        'match': 'Bạn có: Thịt bò Mỹ, Trứng gà'
      },
      {
        'name': 'Salad cải bó xôi',
        'image': 'https://images.unsplash.com/photo-1551247906-e7526A19866e?w=300',
        'match': 'Bạn có: Cải bó xôi. (Thiếu: Dầu giấm)'
      },
      {
        'name': 'Sữa tươi trứng gà (Món bổ)',
        'image': 'https://images.unsplash.com/photo-1559598467-f8b76c8155d0?w=300',
        'match': 'Bạn có: Sữa tươi Vinamilk, Trứng gà'
      }
    ];

    setState(() => _isSuggesting = false);

    // 4. Hiển thị BottomSheet
    if (!mounted) return; 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6, // Chiếm 60% màn hình
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Gợi ý từ AI cho bạn",
                style: GoogleFonts.interTight(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "Dựa trên: ${ingredientNames.join(', ')}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (ctx, index) {
                    final recipe = suggestions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(recipe['image'], width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        title: Text(recipe['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(recipe['match'], style: const TextStyle(fontSize: 12)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Chuyển sang trang chi tiết món ăn (sau này)
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF568C4C);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Tủ lạnh của tôi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      // --- SỬA BODY: BỌC TRONG COLUMN ---
      body: Column(
        children: [
          // --- WIDGET 1: NÚT GỢI Ý MÓN ĂN (MỚI) ---
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            width: double.infinity,
            color: const Color(0xFFF5F7FA), // Màu nền
            child: ElevatedButton.icon(
              onPressed: _isSuggesting ? null : _showRecipeSuggestions,
              icon: _isSuggesting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.lightbulb_outline, color: Colors.white),
              label: Text(
                _isSuggesting ? "Đang tìm món..." : "Tìm món ăn theo nguyên liệu!",
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Màu xanh
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          
          // --- WIDGET 2: DANH SÁCH NGUYÊN LIỆU (CŨ) ---
          Expanded( // Bọc ListView trong Expanded
            child: _pantryItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pantryItems.length,
                    itemBuilder: (context, index) {
                      final item = _pantryItems[index];
                      return _buildPantryItem(item, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMenu(context),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Thêm đồ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- WIDGET: THẺ MÓN ĂN (Giữ nguyên) ---
  Widget _buildPantryItem(Map<String, dynamic> item, int index) {
    final DateTime expDate = item['expirationDate'];
    final Color cardColor = _getExpirationColor(expDate);
    final Color statusColor = _getTextColor(expDate);

    return Dismissible(
      key: Key(item['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) => _deleteItem(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardColor, 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: statusColor.withOpacity(0.3), width: 1)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Số lượng: ${item['quantity']}", 
                      style: TextStyle(color: Colors.grey[700], fontSize: 14)
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(expDate),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET: KHI TỦ TRỐNG (Giữ nguyên) ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.kitchen, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "Tủ lạnh trống trơn!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[400]),
          ),
          const SizedBox(height: 10),
          Text("Thêm thực phẩm để nhận gợi ý món ngon nhé.", style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  // --- HÀM XỬ LÝ KHI SCAN XONG (Giữ nguyên) ---
  void _handleReturnData(dynamic result) {
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _pantryItems.insert(0, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã cập nhật tủ lạnh!")),
      );
    }
  }

  // --- MENU THÊM ĐỒ (Giữ nguyên) ---
  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Thêm nguyên liệu mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildMenuItem(Icons.qr_code_scanner, "Quét mã vạch (Barcode)", Colors.blue, () async {
                   Navigator.pop(context); 
                   final result = await Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const QrScannerScreen()), // Sửa lại Qr -> Barcode nếu cần
                   );
                   _handleReturnData(result);
                }),
                _buildMenuItem(
                  Icons.camera_enhance, // Thay đường dẫn này nếu bạn lưu ở chỗ khác
                   "Quét nguyên liệu (AI)", Colors.orange, () async {
                   Navigator.pop(context); 
                   final result = await Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const IngredientScannerScreen()),
                   );
                   _handleReturnData(result);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET MENU ITEM (Giữ nguyên) ---
  Widget _buildMenuItem(dynamic iconOrPath, String text, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), 
          shape: BoxShape.circle
        ),
        child: iconOrPath is String 
            ? Image.asset(iconOrPath, width: 24, height: 24)
            : Icon(iconOrPath as IconData, color: color),
      ),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}