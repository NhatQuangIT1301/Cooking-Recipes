
import 'aboutus_screen.dart';
import 'contactus_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// SỬA LỖI IMPORT: Dùng đường dẫn tương đối
import '../ai/voice_search_screen.dart';
import '../recipe/add_recipe_screen.dart';
import '../recipe/blog_screen.dart';
import 'settings_screen.dart'; // Cùng thư mục 'core'
import '../scan/ingredient_scanner_screen.dart';
import '../recipe/markdown_recipe_screen.dart';
import '../recipe/my_recipes_screen.dart';
import 'filter_screen.dart'; // Cùng thư mục 'core'
import '../scan/qr_scanner_screen.dart';
import '../auth/login_screen.dart';
import 'pantry_screen.dart';
import 'notifications_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Quản lý state trực tiếp
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  int _selectedIndex = 0;

  // SỬA ĐỔI: Thêm PageController cho banner
  late PageController _pageController;

  // Khóa cho Scaffold (nếu cần mở Drawer)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // SỬA ĐỔI: Danh sách ảnh cho carousel
  final List<Map<String, String>> _carouselItems = [
    {"image": "assets/images/bunbo.jpg", "title": "Bún Bò Huế"},
    {"image": "assets/images/bundau.jpg", "title": "Bún Đậu Mắm Tôm"},
    {"image": "assets/images/goicuon.jpg", "title": "Gỏi Cuốn"},
    {"image": "assets/images/nemnuong.jpg", "title": "Nem Nướng"},
    {"image": "assets/images/pho.jpg", "title": "Phở Bò"},
  ];

  // Định nghĩa màu sắc (trích xuất từ theme)
  final Color primaryBackground = const Color(0xFFF1F4F8);
  final Color secondaryBackground = Colors.white;
  final Color primaryColor = const Color(0xFF568C4C); // Giả định từ file login
  final Color secondaryText = const Color(0xFF57636C); // Giả định từ file login
  final Color primaryText = const Color(0xFF15161E);
  final Color alternateBorder = const Color(0xFFE0E3E7); // Giả định từ file login
  final Color errorColor = const Color(0xFFFF5963); // Giả định từ file forgot
  final Color successColor = const Color(0xFF4FB239); // Giả định từ file forgot
  final Color orangeAccent = const Color(0xFFFF6B35);
  final Color lightRedFill = const Color(0xFFFFE8E8);
  final Color gradientStart = const Color(0xFFB2471F);
  final Color gradientEnd = const Color(0xFFF7931E);
  final Color shadowColor = const Color(0x1A000000);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    // Khởi tạo PageController
    _pageController = PageController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _pageController.dispose(); // Hủy PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector để unfocus khi nhấn ra ngoài
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey, // Thêm key
        backgroundColor: primaryBackground,
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNav(),
        endDrawer: _buildAppDrawer(), // Thêm Drawer
      ),
    );
  }

  // Hàm xây dựng AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryBackground,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Avatar
          Container(
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1522075793577-0e6b86be585b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI3MDI0OTZ8&ixlib=rb-4.1.0&q=80&w=1080',
                ),
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
                width: 2.0,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          // Lời chào
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: GoogleFonts.inter(
                  color: secondaryText,
                  letterSpacing: 0.0,
                  fontSize: 12.0, // Ước tính từ 'bodySmall'
                ),
              ),
              Text(
                'Chef Maria',
                style: GoogleFonts.interTight(
                  color: primaryText, // Ước tính từ 'titleMedium'
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Nút Menu
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Container(
            decoration: BoxDecoration(
              color: secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: primaryText,
                size: 24.0,
              ),
              onPressed: () {
                // Mở Drawer
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        ),
      ],
    );
  }

  // Hàm xây dựng Bottom Navigation Bar
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: secondaryBackground,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryText,
      onTap: (int index) {
        // Xử lý điều hướng
        if (index == _selectedIndex) return; // Không làm gì nếu nhấn tab hiện tại

        setState(() {
          _selectedIndex = index;
        });

        // Xử lý điều hướng
        switch (index) {
          case 0:
            // Home: Đã ở đây
            break;
          case 1:
            // My Recipe
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyRecipeScreen()));
            break;
          case 2:
            // Plus (Add)
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddRecipeScreen()));
            break;
            case 3:
            // Plus (Add)
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
        // SỬA ĐỔI: Icon bự hơn và xóa chữ
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline, size: 36.0), // 1. Icon bự ra
          label: '', // 2. Xóa chữ 'Plus'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Pantry'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
      ],
    );
  }

  // Hàm xây dựng Body
  Widget _buildBody() {
    return SafeArea(
      top: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // SỬA ĐỔI: Banner Carousel
            _buildBanner(),
            // Thanh tìm kiếm
            _buildSearchBar(),
            // Hàng các nút chức năng
            _buildActionButtons(),
            // Danh sách công thức
            _buildRecipeList(),
            // Thêm khoảng đệm dưới cùng để không bị che bởi FAB
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // SỬA ĐỔI: Widget con cho Banner (Carousel)
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        height: 300.0, // Chiều cao "bự"
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors
              .black, // Màu nền đen nếu ảnh dùng BoxFit.contain
        ),
        // Dùng ClipRRect để bo góc các ảnh con bên trong
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            children: [
              // PageView để trượt
              PageView.builder(
                controller: _pageController,
                itemCount: _carouselItems.length,
                itemBuilder: (context, index) {
                  final item = _carouselItems[index];
                  return _buildCarouselItem(
                    imagePath: item['image']!,
                  );
                },
              ),

              // Nút mũi tên Trái
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),

              // Nút mũi tên Phải
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SỬA ĐỔI: Hàm trợ giúp: Xây dựng 1 slide (Chỉ ảnh)
  Widget _buildCarouselItem({required String imagePath}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          fit: BoxFit.contain, // Hiển thị toàn bộ ảnh
          image: AssetImage(imagePath),
        ),
      ),
    );
  }

  // Widget con cho thanh tìm kiếm
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0), // Giảm padding top
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'Search recipes, ingredients...',
          hintStyle: GoogleFonts.inter(
            color: secondaryText,
            letterSpacing: 0.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: alternateBorder,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor, // Thay đổi màu khi focus
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: errorColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: errorColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: secondaryBackground,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: secondaryText,
            size: 24.0,
          ),
        ),
        style: GoogleFonts.inter(
          color: primaryText,
          letterSpacing: 0.0,
        ),
      ),
    );
  }

  // Widget con cho hàng nút bấm
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildActionButton(
              icon: Icons.filter_list,
              iconColor: primaryText,
              bgColor: secondaryBackground,
              borderColor: alternateBorder,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterScreen()));
              },
            ),
            const SizedBox(width: 12.0),
            _buildActionButton(
              icon: Icons.mic,
              iconColor: orangeAccent,
              bgColor: Colors.white,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VoiceSearchScreen()));
              },
              hasElevation: true,
            ),       
            // Hết nút mới    
            const SizedBox(width: 12.0),
            _buildActionButton(
              icon: Icons.bookmark_border,
              iconColor: primaryText,
              bgColor: secondaryBackground,
              borderColor: primaryText,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MarkdownRecipeScreen()));
              },
            ),
            const SizedBox(width: 12.0),
            _buildActionButton(
              icon: Icons.add,
              iconColor: primaryText,
              bgColor: secondaryBackground,
              borderColor: successColor, // Giả định 'secondary' là success
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRecipeScreen()));
              },
            ),
            const SizedBox(width: 12.0),
            _buildActionButton(
              icon: Icons.settings_sharp,
              iconColor: primaryText,
              bgColor: secondaryBackground,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hàm trợ giúp để tạo nút bấm ICON
  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    Color? borderColor,
    bool hasElevation = false,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0), // Thống nhất 20.0
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.0)
            : null,
        boxShadow: hasElevation
            ? [
                BoxShadow(
                  blurRadius: 4.0,
                  color: shadowColor,
                  offset: const Offset(0.0, 2.0),
                )
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: Icon(
            icon,
            color: iconColor,
            size: 30.0, // Thống nhất size
          ),
        ),
      ),
    );
  }

  // SỬA ĐỔI: THÊM HÀM MỚI (để tạo nút bấm ASSET)
  Widget _buildAssetButton({
    required String assetPath,
    required Color bgColor,
    Color? borderColor,
    bool hasElevation = false,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.0)
            : null,
        boxShadow: hasElevation
            ? [
                BoxShadow(
                  blurRadius: 4.0,
                  color: shadowColor,
                  offset: const Offset(0.0, 2.0),
                )
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: Center(
            child: Image.asset(
              assetPath,
              width: 30.0, // Đặt kích thước cho ảnh
              height: 30.0,
            ),
          ),
        ),
      ),
    );
  }

  // Widget con cho danh sách công thức
  Widget _buildRecipeList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
      shrinkWrap: true, // Không tốt cho hiệu năng, nhưng giống code gốc
      physics:
          const NeverScrollableScrollPhysics(), // Vì đã ở trong SingleChildScrollView
      children: [
        // SỬA ĐỔI: Bọc card trong InkWell
        InkWell(
          onTap: () {
            // SỬA LỖI FLOW: Mở RecipeDetailScreen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RecipeDetailScreen()));
          },
          child: _buildRecipeCard(
            imageUrl:
                'https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI3MDI0OTZ8&ixlib=rb-4.1.0&q=80&w=1080',
            title: 'Creamy Garlic Pasta',
            description: 'A delicious creamy pasta with garlic sauce.',
            time: '25 min',
            servings: '4 servings',
            isFavorite: false,
          ),
        ),
        const SizedBox(height: 16.0),
        // SỬA ĐỔI: Bọc card trong InkWell
      ],
    );
  }

  // Hàm trợ giúp để tạo thẻ công thức
  Widget _buildRecipeCard({
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: shadowColor,
              offset: const Offset(0.0, 2.0),
            )
          ],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: alternateBorder,
                    child: Icon(Icons.broken_image, color: secondaryText),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  title,
                  style: GoogleFonts.interTight(
                    color: primaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  description,
                  style: GoogleFonts.inter(
                    color: secondaryText,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _buildInfoChip(Icons.schedule, time, orangeAccent),
                        const SizedBox(width: 12.0),
                        _buildInfoChip(Icons.people, servings, successColor),
                      ],
                    ),
                    Container(
                      width: 35.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                        color: lightRedFill,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.bookmark : Icons.bookmark_border,
                          color: errorColor,
                          size: 18.0,
                        ),
                        onPressed: () {
                          print('Markdown button pressed for $title');
                          // TODO: Xử lý logic 
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

  // Hàm trợ giúp cho chip thông tin (thời gian, khẩu phần)
  Widget _buildInfoChip(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 16.0,
        ),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: GoogleFonts.inter(
            color: secondaryText,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  // SỬA ĐỔI: Thêm hàm xây dựng Drawer (Đã gộp)
  Widget _buildAppDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Chef Maria',
              style: GoogleFonts.interTight(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              'maria.chef@example.com',
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1522075793577-0e6b86be585b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjI3MDI0OTZ8&ixlib=rb-4.1.0&q=80&w=1080',
              ),
              backgroundColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: primaryColor,
            ),
          ),
          // --- THÊM 4 MỤC MỚI VÀO ĐÂY ---
          ListTile(
            leading:
                Icon(Icons.add_circle_outline, color: secondaryText),
            title: Text('Add Recipe',
                style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
              );
            },
          ),
          ListTile(
            leading:
                Icon(Icons.qr_code_scanner, color: secondaryText),
            title: Text('Scanner Barcode',
                style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrScannerScreen()),
              );
            },
          ),
          ListTile(
            leading:
                Icon(Icons.camera_alt_outlined, color: secondaryText),
            title: Text('Scan Ingredient',
                style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IngredientScannerScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark_border, color: secondaryText),
            title: Text('Bookmark',
                style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MarkdownRecipeScreen()),
              );
            },
          ),
          const Divider(), // Dòng kẻ phân cách
          // --- HẾT PHẦN THÊM MỚI ---
          ListTile(
            leading: Icon(Icons.settings_outlined, color: secondaryText),
            title: Text('Settings', style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: secondaryText),
            title: Text('About Us', style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
          ),
           ListTile(
            leading: Icon(Icons.info_outline, color: secondaryText),
            title: Text('Nofication', style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          ListTile( 
            leading: Icon(Icons.contact_mail_outlined, color: secondaryText),
            title: Text('Contact Us', style: GoogleFonts.inter(color: primaryText)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout_outlined, color: errorColor),
            title: Text('Logout', style: GoogleFonts.inter(color: errorColor)),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}