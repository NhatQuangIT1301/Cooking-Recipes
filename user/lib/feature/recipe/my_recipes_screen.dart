import '../home/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../recipe/add_recipe_screen.dart';
import 'update_recipe_screen.dart';// SỬA ĐỔI: Import trang Update

// --- Định nghĩa màu sắc (trích xuất từ theme) ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh lá chính
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorBorder = Color(0xFFE0E3E7);
const Color kColorError = Color(0xFFFF5963);
const Color kColorRatingStar = Color(0xFFFFA726);
const Color kColorOverlay = Color(0x80000000); // Đen mờ 50%
const Color kColorShadow = Color(0x1A000000);
const Color kColorAccent2 = Color(0xFF96CEB4); // (Màu giả định cho 'Published')
const Color kColorWhite = Colors.white;

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({super.key});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  // State cho danh sách công thức của tôi (dữ liệu giả)
  List<Map<String, String>> _myRecipes = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // SỬA ĐỔI: Cập nhật dữ liệu giả để có đủ thông tin cho trang Update
    _myRecipes = [
      {
        "id": "1",
        "title": "Creamy Garlic Pasta",
        "description":
            "1. Boil pasta.\n2. Sauté garlic and mushrooms.\n3. Add cream.\n4. Mix with pasta.",
        "imageUrl":
            "https://images.unsplash.com/photo-1672850342635-fd7b6540a917?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI4NDk3OTJ8&ixlib=rb-4.1.0&q=80&w=1080",
        "published": "Published 2 days ago",
        "category": "Dinner",
        "minutes": "25",
        "ingredients": "Pasta, Garlic, Cream, Mushrooms, Salt, Pepper",
      },
      {
        "id": "2",
        "title": "Double Chocolate Brownies",
        "description":
            "1. Melt butter and chocolate.\n2. Mix dry ingredients.\n3. Combine all.\n4. Bake.",
        "imageUrl":
            "https://images.unsplash.com/photo-1559955089-6e252512255e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI4NDk3OTJ8&ixlib=rb-4.1.0&q=80&w=1080",
        "published": "Published 1 week ago",
        "category": "Dessert",
        "minutes": "45",
        "ingredients": "Flour, Sugar, Cocoa, Chocolate Chips, Eggs, Butter",
      },
      {
        "id": "3",
        "title": "Hearty Tomato Basil Soup",
        "description":
            "1. Sauté onions and garlic.\n2. Add tomatoes and broth.\n3. Simmer.\n4. Blend and add basil.",
        "imageUrl":
            "https://images.unsplash.com/photo-1708335583165-57aa131a4969?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI4NDk3OTJ8&ixlib=rb-4.1.0&q=80&w=1080",
        "published": "Published 3 weeks ago",
        "category": "Lunch",
        "minutes": "30",
        "ingredients": "Tomatoes, Basil, Onion, Garlic, Vegetable Broth",
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // --- HÀM LOGIC ---

  // Hàm để XÓA một công thức
  void _removeRecipe(String id) {
    setState(() {
      _myRecipes.removeWhere((recipe) => recipe['id'] == id);
      print('Removed recipe $id');
    });
  }

  // Hàm để điều hướng đến trang THÊM
  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const AddRecipeScreen()),
    );
  
  }

  // SỬA ĐỔI: Hàm để điều hướng đến trang SỬA
  void _navigateToEditScreen(Map<String, String> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateRecipeScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kColorBackground,
        appBar: _buildAppBar(context),
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
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kColorCard, // secondaryBackground
      automaticallyImplyLeading: false,
      elevation: 2.0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: kColorPrimaryText,
          size: 24.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>const HomePage()),
    );
        },
      ),
      title: Text(
        'My Recipes',
        style: GoogleFonts.interTight(
          color: kColorPrimaryText,
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: kColorPrimaryText,
              size: 24.0,
            ),
            onPressed:
                _navigateToAddScreen, // Gọi hàm điều hướng khi nhấn Thêm
          ),
        ),
      ],
    );
  }

  // Hàm xây dựng thanh tìm kiếm
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search your recipes...',
          hintStyle: GoogleFonts.inter(
            color: kColorSecondaryText,
            fontSize: 14.0,
          ),
          filled: true,
          fillColor: kColorCard,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: kColorSecondaryText,
            size: 20.0,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kColorBorder, width: 1.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kColorBorder, width: 1.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kColorPrimary, width: 1.0),
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
    // Nếu không có công thức, hiển thị thông báo
    if (_myRecipes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.post_add_outlined,
              size: 80.0,
              color: kColorSecondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              'No Recipes Yet',
              style: GoogleFonts.interTight(
                color: kColorPrimaryText,
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Tap the \'+\' icon to add your first recipe.',
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
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _myRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _myRecipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildMyRecipeCard(
              recipe: recipe,
              onEdit: () => _navigateToEditScreen(recipe), // SỬA ĐỔI
              onDelete: () => _removeRecipe(recipe['id']!),
            ),
          );
        },
      ),
    );
  }

  // Hàm trợ giúp để tạo thẻ công thức của tôi
  Widget _buildMyRecipeCard({
    required Map<String, String> recipe,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
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
            // Ảnh và Nút More
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    recipe['imageUrl']!,
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
                // Nút More (FlutterFlow code có)
                Align(
                  alignment: const Alignment(0.9, -0.8),
                  child: Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: const BoxDecoration(
                      color: kColorOverlay,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: kColorWhite,
                        size: 18.0,
                      ),
                      onPressed: () {
                        // TODO: Hiển thị menu Sửa/Xóa từ đây
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 16.0,
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
                    recipe['title']!,
                    style: GoogleFonts.interTight(
                      color: kColorPrimaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    recipe['description']!,
                    style: GoogleFonts.inter(
                      color: kColorSecondaryText,
                      fontSize: 12.0,
                    ),
                    maxLines: 2, // Giới hạn mô tả
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12.0),
                  // Hàng thông tin (Ngày đăng và Nút Sửa/Xóa)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Ngày đăng
                      Text(
                        recipe['published']!,
                        style: GoogleFonts.inter(
                          color: kColorAccent2,
                          fontSize: 12.0,
                        ),
                      ),
                      // Nút Sửa/Xóa
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: kColorPrimary,
                              size: 18.0, // Nhỏ hơn
                            ),
                            onPressed: onEdit, // SỬA ĐỔI
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_rounded,
                              color: kColorError,
                              size: 18.0, // Nhỏ hơn
                            ),
                            onPressed: onDelete,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
}