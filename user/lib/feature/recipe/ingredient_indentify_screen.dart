import '../recipe/blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Định nghĩa màu sắc ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C);
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorBorder = Color(0xFFE0E3E7);
const Color kColorRatingStar = Color(0xFFFFA500); // Màu vàng cam cho sao
const Color kColorAccent1 = Color(0x33568C4C); // Nền cho nút 'View All'
const Color kColorAccent2 = Color(0xFF96CEB4); // Màu icon 'schedule'
const Color kColorInfo = Colors.white; // Màu icon bookmark

class IngredientSuggestionsScreen extends StatelessWidget {
  const IngredientSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kColorBackground,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kColorBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: kColorPrimaryText,
          size: 24,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Recipe Suggestions',
        style: GoogleFonts.interTight(
          color: kColorPrimaryText,
          fontWeight: FontWeight.w600,
          fontSize: 22.0, // headlineMedium
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: kColorPrimaryText,
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
              // Quay lại trang scan
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      top: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildScannedIngredientCard(),
            _buildSuggestionsSectionHeader(context),
            _buildSuggestionList(context),
          ],
        ),
      ),
    );
  }

  // Thẻ hiển thị nguyên liệu đã quét (Cà chua)
  Widget _buildScannedIngredientCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_scanner,
                color: kColorPrimary,
                size: 48,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                child: Text(
                  'Scanned Ingredient',
                  style: GoogleFonts.interTight(
                    color: kColorPrimaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18, // titleMedium
                  ),
                ),
              ),
              Text(
                'Fresh Tomatoes',
                style: GoogleFonts.interTight(
                  color: kColorPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 28, // headlineMedium
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Organic • Red • Ripe',
                  style: GoogleFonts.inter(
                    color: kColorSecondaryText,
                    fontSize: 14, // bodyMedium
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tiêu đề cho phần "Suggested Recipes"
  Widget _buildSuggestionsSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Suggested Recipes',
            style: GoogleFonts.interTight(
              color: kColorPrimaryText,
              fontWeight: FontWeight.w600,
              fontSize: 24.0, // headlineSmall
            ),
          ),
          TextButton(
            onPressed: () {
              print('Button pressed ...');
              // TODO: Điều hướng đến trang xem tất cả gợi ý
            },
            style: TextButton.styleFrom(
              backgroundColor: kColorAccent1,
              foregroundColor: kColorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              minimumSize: const Size(0, 32), // Chiều cao 32
            ),
            child: Text(
              'View All',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Danh sách các công thức gợi ý
  Widget _buildSuggestionList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        _buildSuggestionCard(
          context: context,
          imageUrl:
              'https://images.unsplash.com/photo-1646940930570-35ffcaedfd24?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjMwMzAwOTl8&ixlib=rb-4.1.0&q=80&w=1080',
          title: 'Classic Tomato Pasta',
          details: 'Italian • 25 mins • Easy',
          rating: '4.2 (156)',
          tags: 'Tomatoes, Pasta, Garlic, Basil',
          isBookmarked: false,
        ),
        const SizedBox(height: 16.0),
        _buildSuggestionCard(
          context: context,
          imageUrl:
              'https://images.unsplash.com/photo-1725030660031-585ea459d55f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjMwMzAwOTl8&ixlib=rb-4.1.0&q=80&w=1080',
          title: 'Mediterranean Tomato Salad',
          details: 'Mediterranean • 15 mins • Easy',
          rating: '4.8 (89)',
          tags: 'Tomatoes, Feta, Olives, Herbs',
          isBookmarked: false,
        ),
        const SizedBox(height: 16.0),
        _buildSuggestionCard(
          context: context,
          imageUrl:
              'https://images.unsplash.com/photo-1637438333468-2ea466032288?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjMwMzAwOTl8&ixlib=rb-4.1.0&q=80&w=1080',
          title: 'Roasted Tomato Soup',
          details: 'Comfort Food • 35 mins • Medium',
          rating: '4.7 (342)',
          tags: 'Tomatoes, Cream, Onions, Herbs',
          isBookmarked: true, // Ví dụ đã bookmark
        ),
      ],
    );
  }

  // Hàm trợ giúp để tạo một thẻ Công thức Gợi ý
  Widget _buildSuggestionCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String details,
    required String rating,
    required String tags,
    required bool isBookmarked,
  }) {
    return GestureDetector(
      onTap: () {
        // Kết nối flow: Nhấn vào thẻ để mở trang chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RecipeDetailScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 120, // Chiều cao cố định từ code gốc
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 96,
                    height: 96,
                    color: kColorBorder,
                    child:
                        const Icon(Icons.broken_image, color: kColorSecondaryText),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0, // titleMedium
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Details
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                      child: Text(
                        details,
                        style: GoogleFonts.inter(
                          color: kColorSecondaryText,
                          fontSize: 12.0, // bodySmall
                        ),
                      ),
                    ),
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: kColorRatingStar, size: 16),
                        const Icon(Icons.star, color: kColorRatingStar, size: 16),
                        const Icon(Icons.star, color: kColorRatingStar, size: 16),
                        const Icon(Icons.star, color: kColorRatingStar, size: 16),
                        const Icon(Icons.star_border,
                            color: kColorSecondaryText, size: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            rating,
                            style: GoogleFonts.inter(
                              color: kColorSecondaryText,
                              fontSize: 12.0, // bodySmall
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(), // Đẩy hàng cuối cùng xuống
                    // Tags và Nút Bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            tags,
                            style: GoogleFonts.inter(
                              color: kColorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: kColorPrimary,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: kColorInfo, // Màu trắng
                              size: 16.0,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              print('Bookmark pressed for $title');
                            },
                          ),
                        ),
                      ],
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
}