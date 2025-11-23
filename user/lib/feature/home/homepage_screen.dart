import 'aboutus_screen.dart';
import 'contactus_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ai/voice_search_screen.dart';
import '../recipe/add_recipe_screen.dart';
import '../recipe/blog_screen.dart';
import 'settings_screen.dart';
import '../scan/ingredient_scanner_screen.dart';
import '../recipe/markdown_recipe_screen.dart';
import '../recipe/my_recipes_screen.dart';
import 'filter_screen.dart';
import '../scan/qr_scanner_screen.dart';
import '../auth/login_screen.dart';
import 'pantry_screen.dart';
import 'notifications_screen.dart';

class HomePage extends StatefulWidget {
  final List<String>? suggestedMeals;

  const HomePage({
    super.key,
    this.suggestedMeals,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late PageController _pageController;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- TODO 1: MODEL DỮ LIỆU (Giả lập Database) ---
  // Sau này bạn sẽ thay thế cái này bằng dữ liệu lấy từ API Node.js
  final List<Map<String, dynamic>> _allRecipes = [
    {
      "id": "1",
      "title": "Creamy Garlic Pasta",
      "description": "A delicious creamy pasta with garlic sauce.",
      "image": "https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI3MDI0OTZ8&ixlib=rb-4.1.0&q=80&w=1080",
      "time": "25 min",
      "servings": "4",
      "isFavorite": false,
      "category": "Dinner"
    },
    {
      "id": "2",
      "title": "Berry Smoothie Bowl",
      "description": "Healthy breakfast with fresh berries.",
      "image": "https://images.unsplash.com/photo-1626078436812-7c7254ba0b48?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI3MDI0OTZ8&ixlib=rb-4.1.0&q=80&w=1080",
      "time": "10 min",
      "servings": "1",
      "isFavorite": true,
      "category": "Breakfast"
    },
    {
      "id": "3",
      "title": "Grilled Chicken Salad",
      "description": "Fresh salad with grilled chicken breast.",
      "image": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI3MDI0OTZ8&ixlib=rb-4.1.0&q=80&w=1080",
      "time": "20 min",
      "servings": "2",
      "isFavorite": false,
      "category": "Lunch"
    },
  ];

  // --- TODO 2: BIẾN ĐỂ LỌC DỮ LIỆU ---
  String _searchQuery = "";
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "Breakfast", "Lunch", "Dinner", "Dessert"];

  final List<Map<String, String>> _dailyRecommendations = [
    {
      "image": "assets/images/bunbo.jpg", 
      "title": "Bún Bò Huế Đậm Đà",
      "calories": "520 Kcal",
      "time": "45 min",
      "level": "Medium"
    },
    {
      "image": "assets/images/goicuon.jpg",
      "title": "Gỏi Cuốn Tôm Thịt",
      "calories": "180 Kcal",
      "time": "20 min",
      "level": "Easy"
    },
    {
      "image": "assets/images/pho.jpg",
      "title": "Phở Bò Gia Truyền",
      "calories": "450 Kcal",
      "time": "60 min",
      "level": "Hard"
    },
  ];

  // Colors
  final Color primaryBackground = const Color(0xFFF1F4F8);
  final Color secondaryBackground = Colors.white;
  final Color primaryColor = const Color(0xFF568C4C);
  final Color secondaryText = const Color(0xFF57636C);
  final Color primaryText = const Color(0xFF15161E);
  final Color alternateBorder = const Color(0xFFE0E3E7);
  final Color errorColor = const Color(0xFFFF5963);
  final Color successColor = const Color(0xFF4FB239);
  final Color orangeAccent = const Color(0xFFFF6B35);
  final Color lightRedFill = const Color(0xFFFFE8E8);
  final Color shadowColor = const Color(0x1A000000);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _pageController = PageController();

    // --- TODO: GỌI API LẤY RECIPES TỪ SERVER ---
    // _fetchRecipesFromBackend();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: primaryBackground,
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNav(),
        endDrawer: _buildAppDrawer(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryBackground,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1522075793577-0e6b86be585b?ixlib=rb-4.1.0&q=80&w=1080',
                ),
              ),
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2.0),
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back!', style: GoogleFonts.inter(color: secondaryText, fontSize: 12.0)),
              Text('Chef Maria', style: GoogleFonts.interTight(color: primaryText, fontWeight: FontWeight.w600, fontSize: 18.0)),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: primaryText, size: 24.0),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: secondaryBackground,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryText,
      onTap: (int index) {
        if (index == _selectedIndex) return;
        setState(() => _selectedIndex = index);
        switch (index) {
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyRecipeScreen()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRecipeScreen()));
            break;
          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PantryScreen()));
            break;
          case 4:
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Recipe'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 36.0), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Pantry'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(),
            _buildSearchBar(),
            
            // --- TODO 3: UI DANH MỤC MỚI ---
            _buildCategoryList(),

            _buildActionButtons(),
            _buildRecipeList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- THAY THẾ HÀM _buildBanner CŨ BẰNG HÀM NÀY ---
  Widget _buildBanner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề mục đề xuất
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 12.0),
          child: Text(
            "Cook Something New Today",
            style: GoogleFonts.interTight(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
        ),
        
        // Khung slide đề xuất
        SizedBox(
          height: 260.0, // Tăng chiều cao để chứa thông tin
          child: PageView.builder(
            controller: _pageController,
            itemCount: _dailyRecommendations.length,
            itemBuilder: (context, index) {
              final item = _dailyRecommendations[index];
              return _buildRecommendationCard(item);
            },
          ),
        ),
      ],
    );
  }

  // Widget con hiển thị từng thẻ trong khung đề xuất
  Widget _buildRecommendationCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(item['image']!), // Hoặc NetworkImage nếu dùng link
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge đề xuất
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: orangeAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Recommend",
                style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            
            // Tên món ăn
            Text(
              item['title']!,
              style: GoogleFonts.interTight(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Thông tin chi tiết (Time | Calo | Level)
            Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(item['time']!, style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
                
                const SizedBox(width: 16),
                const Icon(Icons.local_fire_department_outlined, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(item['calories']!, style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
                
                const SizedBox(width: 16),
                const Icon(Icons.bar_chart, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(item['level']!, style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        // --- TODO 2: LOGIC SEARCH REAL-TIME ---
        onChanged: (value) {
          setState(() {
            _searchQuery = value; // Cập nhật từ khóa tìm kiếm
          });
        },
        decoration: InputDecoration(
          hintText: 'Search recipes, ingredients...',
          hintStyle: GoogleFonts.inter(color: secondaryText),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: alternateBorder), borderRadius: BorderRadius.circular(25.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(25.0)),
          filled: true,
          fillColor: secondaryBackground,
          prefixIcon: Icon(Icons.search_rounded, color: secondaryText),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        style: GoogleFonts.inter(color: primaryText),
      ),
    );
  }

  // --- TODO 3: WIDGET DANH MỤC (MỚI THÊM) ---
  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0.0, 0.0),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (ctx, index) => const SizedBox(width: 8),
          itemBuilder: (ctx, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              labelStyle: GoogleFonts.inter(
                color: isSelected ? Colors.white : primaryText,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: secondaryBackground,
              selectedColor: primaryColor,
              side: BorderSide(color: isSelected ? primaryColor : alternateBorder),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.filter_list, iconColor: primaryText, bgColor: secondaryBackground, borderColor: alternateBorder,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterScreen())),
          ),
          const SizedBox(width: 12.0),
          _buildActionButton(
            icon: Icons.mic, iconColor: orangeAccent, bgColor: Colors.white, hasElevation: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VoiceSearchScreen())),
          ),
          const SizedBox(width: 12.0),
          _buildActionButton(
            icon: Icons.bookmark_border, iconColor: primaryText, bgColor: secondaryBackground, borderColor: primaryText,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MarkdownRecipeScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required Color iconColor, required Color bgColor, Color? borderColor, bool hasElevation = false, required VoidCallback onTap}) {
    return Container(
      width: 80.0, height: 80.0,
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(20.0),
        border: borderColor != null ? Border.all(color: borderColor) : null,
        boxShadow: hasElevation ? [BoxShadow(blurRadius: 4.0, color: shadowColor, offset: const Offset(0.0, 2.0))] : [],
      ),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20.0), child: Icon(icon, color: iconColor, size: 30.0)),
    );
  }

  Widget _buildRecipeList() {
    // --- TODO 2: LOGIC LỌC DANH SÁCH ---
    // Lọc theo Search text và Category
    final filteredRecipes = _allRecipes.where((recipe) {
      final matchSearch = recipe['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory = _selectedCategory == "All" || recipe['category'] == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // --- MÓN ĂN GỢI Ý TỪ AI ---
        if (widget.suggestedMeals != null && widget.suggestedMeals!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFFF6B35), size: 20),
              const SizedBox(width: 8),
              Text("AI Suggested For You", style: GoogleFonts.interTight(fontSize: 20.0, fontWeight: FontWeight.bold, color: primaryText)),
            ]),
          ),
          ...widget.suggestedMeals!.map((mealName) => Column(
            children: [
              InkWell(
                onTap: () {
                  // --- TODO: GỌI GEMINI API ĐỂ TẠO CÔNG THỨC CHO MÓN NÀY ---
                  // callGeminiApi(mealName);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RecipeDetailScreen()));
                },
                child: _buildRecipeCard(
                  id: "ai_generated", // ID giả
                  imageUrl: 'https://source.unsplash.com/random/?food,meal',
                  title: mealName,
                  description: 'Recommended based on your goals',
                  time: '30 min',
                  servings: '1',
                  isFavorite: false,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text("Popular Recipes", style: GoogleFonts.interTight(fontSize: 20.0, fontWeight: FontWeight.bold, color: primaryText)),
          ),
        ],

        // --- DANH SÁCH MÓN ĂN TỪ DATABASE ---
        // Nếu không tìm thấy món nào
        if (filteredRecipes.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: Text("No recipes found.", style: GoogleFonts.inter(color: secondaryText))),
          ),

        // Render danh sách đã lọc
        ...filteredRecipes.map((recipe) => Column(
          children: [
            InkWell(
              onTap: () {
                // --- TODO: TRUYỀN ID HOẶC OBJECT SANG TRANG CHI TIẾT ---
                // Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipeId: recipe['id'])));
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RecipeDetailScreen()));
              },
              child: _buildRecipeCard(
                id: recipe['id'],
                imageUrl: recipe['image'],
                title: recipe['title'],
                description: recipe['description'],
                time: recipe['time'],
                servings: recipe['servings'],
                isFavorite: recipe['isFavorite'],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        )),
      ],
    );
  }

  Widget _buildRecipeCard({
    required String id,
    required String imageUrl,
    required String title,
    required String description,
    required String time,
    required String servings,
    required bool isFavorite,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryBackground,
          boxShadow: [BoxShadow(blurRadius: 8.0, color: shadowColor, offset: const Offset(0.0, 2.0))],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl,
                  width: double.infinity, height: 180.0, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity, height: 180.0, color: alternateBorder,
                    child: Icon(Icons.fastfood, color: secondaryText, size: 50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(title, style: GoogleFonts.interTight(color: primaryText, fontWeight: FontWeight.w600, fontSize: 18.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(description, style: GoogleFonts.inter(color: secondaryText, fontSize: 12.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildInfoChip(Icons.schedule, time, orangeAccent),
                        const SizedBox(width: 12.0),
                        _buildInfoChip(Icons.people, "$servings servings", successColor),
                      ],
                    ),
                    Container(
                      width: 35.0, height: 35.0,
                      decoration: BoxDecoration(color: lightRedFill, shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border, color: errorColor, size: 18.0),
                        onPressed: () {
                          // --- TODO 4: XỬ LÝ LOGIC YÊU THÍCH ---
                          // 1. Cập nhật state cục bộ: setState(() { recipe['isFavorite'] = !recipe['isFavorite']; });
                          // 2. Gọi API cập nhật Backend
                          print('Favorite toggled for $id');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16.0),
        const SizedBox(width: 8.0),
        Text(text, style: GoogleFonts.inter(color: secondaryText, fontSize: 12.0)),
      ],
    );
  }

  Widget _buildAppDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Chef Maria', style: GoogleFonts.interTight(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text('maria.chef@example.com', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8))),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1522075793577-0e6b86be585b?ixlib=rb-4.1.0&q=80&w=1080'),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(color: primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: secondaryText),
            title: Text('Add Recipe', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRecipeScreen())),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner, color: secondaryText),
            title: Text('Scanner Barcode', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScannerScreen())),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt_outlined, color: secondaryText),
            title: Text('Scan Ingredient', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IngredientScannerScreen())),
          ),
           ListTile(
            leading: Icon(Icons.bookmark_border, color: secondaryText),
            title: Text('Bookmark', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MarkdownRecipeScreen())),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: secondaryText),
            title: Text('Settings', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: secondaryText),
            title: Text('About Us', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen())),
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined, color: secondaryText),
            title: Text('Notification', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
          ),
          ListTile(
            leading: Icon(Icons.contact_mail_outlined, color: secondaryText),
            title: Text('Contact Us', style: GoogleFonts.inter(color: primaryText)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsScreen())),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout_outlined, color: errorColor),
            title: Text('Logout', style: GoogleFonts.inter(color: errorColor)),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false),
          ),
        ],
      ),
    );
  }
}