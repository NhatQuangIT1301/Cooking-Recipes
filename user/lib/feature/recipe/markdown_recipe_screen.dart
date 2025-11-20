import '../home/homepage_screen.dart';
import '../recipe/my_recipes_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// SỬA ĐỔI: Sửa lại toàn bộ import cho chính xác
import '../recipe/add_recipe_screen.dart';
import '../home/settings_screen.dart';
import '../home/pantry_screen.dart';
// (Không cần import recipe_detail_screen.dart ở đây)

// --- Định nghĩa màu sắc (trích xuất từ theme) ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C);
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorBorder = Color(0xFFE0E3E7);
const Color kColorError = Color(0xFFFF5963);
const Color kColorRatingStar = Color(0xFFFFA726);
const Color kColorOverlay = Color(0x80000000); // Đen mờ 50%
const Color kColorShadow = Color(0x1A000000);

class MarkdownRecipeScreen extends StatefulWidget {
  const MarkdownRecipeScreen({super.key});

  @override
  State<MarkdownRecipeScreen> createState() => _MarkdownRecipeState();
}

class _MarkdownRecipeState extends State<MarkdownRecipeScreen> {
  // Quản lý state cho thanh tìm kiếm
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  // SỬA ĐỔI: Thêm state cho BottomNavBar
  final int _selectedIndex = 0; // Mặc định tab Home

  // State cho danh sách yêu thích (dữ liệu giả)
  List<Map<String, String>> _favoriteRecipes = [];

  @override
  void initState() {
// ... (code initState giữ nguyên)
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Khởi tạo danh sách yêu thích (dữ liệu giả)
    _favoriteRecipes = [
      {
        "id": "1",
        "title": "Creamy Garlic Pasta",
        "details": "Italian • 25 mins • Easy",
        "rating": "4.8",
        "added": "Added 2 days ago",
        "imageUrl":
            "https://images.unsplash.com/photo-1614163596093-44d9348f0a80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI4NTA2MTR8&ixlib=rb-4.1.0&q=80&w=1080",
      },
      {
        "id": "2",
        "title": "Honey Glazed Chicken",
        "details": "American • 35 mins • Medium",
        "rating": "4.6",
        "added": "Added 1 week ago",
        "imageUrl":
            "https://images.unsplash.com/photo-1694984717272-d1b42e73709c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI4NTA2MTR8&ixlib=rb-4.1.0&q=80&w=1080",
      },
      {
        "id": "3",
        "title": "Mediterranean Quinoa Salad",
        "details": "Mediterranean • 15 mins • Easy",
        "rating": "4.9",
        "added": "Added 3 days ago",
        "imageUrl":
            "https://images.unsplash.com/photo-1598298125619-ac63f5c89d90?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI4NTA2MTR8&ixlib=rb-4.1.0&q=80&w=1080",
      },
    ];
  }

  @override
  void dispose() {
// ... (code dispose giữ nguyên)
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Hàm để xóa một món ăn khỏi danh sách yêu thích
  void _removeFavorite(String id) {
// ... (code _removeFavorite giữ nguyên)
    setState(() {
      _favoriteRecipes.removeWhere((recipe) => recipe['id'] == id);
      print('Removed recipe $id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kColorBackground,
        appBar: _buildAppBar(),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildSearchBar(),
                _buildRecipeList(),
              ],
            ),
          ),
        ),
        // SỬA ĐỔI: Thêm BottomNavBar vào Scaffold
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI ---

  PreferredSizeWidget _buildAppBar() {
// ... (code _buildAppBar giữ nguyên)
    return AppBar(
      backgroundColor: kColorBackground,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: false,
      title: Text(
        'My Favorite Recipes',
        style: GoogleFonts.interTight(
          color: kColorPrimaryText,
          fontWeight: FontWeight.w600,
          fontSize: 28.0, // headlineMedium
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: kColorPrimaryText,
                  size: 24.0,
                ),
                onPressed: () {
                  print('Filter pressed ...');
                  // TODO: Mở trang Filter
                },
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(
                  Icons.sort_rounded,
                  color: kColorPrimaryText,
                  size: 24.0,
                ),
                onPressed: () {
                  print('Sort pressed ...');
                  // TODO: Hiển thị menu sắp xếp
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Hàm xây dựng thanh tìm kiếm
  Widget _buildSearchBar() {
// ... (code _buildSearchBar giữ nguyên)
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search your favorite recipes...',
          hintStyle: GoogleFonts.inter(
            color: kColorSecondaryText,
            fontSize: 14.0, // bodyMedium
          ),
          filled: true,
          fillColor: kColorCard,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: kColorSecondaryText,
            size: 20.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        style: GoogleFonts.inter(
          color: kColorPrimaryText,
          fontSize: 14.0,
        ),
      ),
    );
  }

  // Hàm xây dựng danh sách công thức
  Widget _buildRecipeList() {
// ... (code _buildRecipeList giữ nguyên)
    // Nếu không có món yêu thích, hiển thị thông báo
    if (_favoriteRecipes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        height: 400, // Chiều cao cố định để căn giữa
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.0,
              color: kColorSecondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              'No Favorites Yet',
              style: GoogleFonts.interTight(
                color: kColorPrimaryText,
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Tap the heart icon on a recipe to add it to your favorites.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: kColorSecondaryText,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      );
    }

    // Nếu có, hiển thị ListView
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Vì đã ở trong SingleChildScrollView
        itemCount: _favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _favoriteRecipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildFavoriteRecipeCard(
              id: recipe['id']!,
              imageUrl: recipe['imageUrl']!,
              title: recipe['title']!,
              details: recipe['details']!,
              rating: recipe['rating']!,
              addedDate: recipe['added']!,
            ),
          );
        },
      ),
    );
  }

  // Hàm trợ giúp để tạo thẻ công thức yêu thích
  Widget _buildFavoriteRecipeCard({
// ... (code _buildFavoriteRecipeCard giữ nguyên)
    required String id,
    required String imageUrl,
    required String title,
    required String details,
    required String rating,
    required String addedDate,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kColorCard,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: kColorShadow,
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh và Nút Xóa
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 180.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 180.0,
                      color: kColorBorder,
                      child: const Icon(Icons.broken_image,
                          color: kColorSecondaryText),
                    ),
                  ),
                ),
                // Nút Xóa (Bỏ khỏi yêu thích)
                Align(
                  alignment: const Alignment(0.9, -0.8),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      color: kColorOverlay,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: kColorError,
                        size: 20.0,
                      ),
                      onPressed: () {
                        // Gọi hàm xóa và truyền ID
                        _removeFavorite(id);
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Thông tin
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.interTight(
                      color: kColorPrimaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0, // titleMedium
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    details,
                    style: GoogleFonts.inter(
                      color: kColorSecondaryText,
                      fontSize: 12.0, // bodySmall
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Hàng thông tin (Rating và Ngày thêm)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: kColorRatingStar,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            rating,
                            style: GoogleFonts.inter(
                                fontSize: 12.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: kColorPrimary,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            addedDate,
                            style: GoogleFonts.inter(
                              color: kColorSecondaryText,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SỬA ĐỔI: Thêm hàm xây dựng Bottom Navigation Bar
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      // SỬA LỖI STYLE: Dùng đúng tên biến màu kColor...
      backgroundColor: kColorCard,
      selectedItemColor: kColorPrimary,
      unselectedItemColor: kColorSecondaryText,
      onTap: (int index) {
        // SỬA ĐỔI LOGIC: Xử lý điều hướng TỪ trang Yêu thích

        switch (index) {
          case 0:
            // Home: Quay về
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
            break;
          case 1:
            // SỬA LỖI LOGIC: Phải trỏ đến MyRecipeScreen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyRecipeScreen()));
            break;
          case 2:
            // Plus (Add)
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddRecipeScreen()));
            break;
          case 3:
            // Pantry
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PantryScreen()));
            break;
          case 4:
            // Setting
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()));
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Recipe'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), label: 'Plus'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Pantry'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
      ],
    );
  }
}