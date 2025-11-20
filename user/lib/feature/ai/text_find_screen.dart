import 'voice_search_screen.dart';
import '../recipe/blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import trang chi tiết để kết nối 'flow'

// --- Định nghĩa màu sắc ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C);
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorBorder = Color(0xFFE0E3E7); // alternate
const Color kColorRatingStar = Color(0xFFFFA500); // Màu vàng cam cho sao
const Color kColorAccent1 = Color(0x33568C4C); // Nền cho nút 'View All'
const Color kColorSuccess = Color(0xFF4FB239); // (Màu giả định)
const Color kColorInfo = Colors.white; // Màu icon bookmark

class AiTextSearchScreen extends StatefulWidget {
  const AiTextSearchScreen({super.key});

  @override
  State<AiTextSearchScreen> createState() => _AiTextSearchScreenState();
}

class _AiTextSearchScreenState extends State<AiTextSearchScreen> {
  late TextEditingController _textController;
  late FocusNode _textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

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
      centerTitle: false, // Tiêu đề căn trái
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: kColorPrimaryText,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8.0),
          Text(
            'AI Recipe Finder',
            style: GoogleFonts.interTight(
              color: kColorPrimaryText,
              fontWeight: FontWeight.w600,
              fontSize: 22.0, // headlineMedium
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: kColorPrimaryText,
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchCard(context),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Recipe Suggestions',
                  style: GoogleFonts.interTight(
                    color: kColorPrimaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0, // titleMedium
                  ),
                ),
              ),
              _buildSuggestionList(context),
            ],
          ),
        ),
      ),
    );
  }

  // Thẻ Tìm kiếm
  Widget _buildSearchCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kColorPrimary,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.mic_rounded, color: kColorPrimary, size: 24),
                  const SizedBox(width: 8.0),
                  Text(
                    'AI Voice Recipe Search',
                    style: GoogleFonts.interTight(
                      color: kColorPrimaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0, // titleMedium
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              // Ô nhập liệu
              TextFormField(
                controller: _textController,
                focusNode: _textFieldFocusNode,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Tell me what ingredients you have...',
                  hintStyle: GoogleFonts.inter(
                    color: kColorSecondaryText,
                    fontSize: 14.0,
                  ),
                  filled: true,
                  fillColor: kColorBackground,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: kColorBorder, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: kColorPrimary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.inter(fontSize: 14.0),
                maxLines: 3,
                minLines: 1,
                cursorColor: kColorPrimary,
              ),
              const SizedBox(height: 12.0),
              // Hàng nút bấm
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic_rounded),
                    iconSize: 24.0,
                    color: kColorPrimary,
                    style: IconButton.styleFrom(
                      backgroundColor: kColorAccent1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const VoiceSearchScreen()));
                    },
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('Search Recipes pressed: ${_textController.text}');
                        // TODO: Logic tìm kiếm
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Search Recipes',
                        style: GoogleFonts.interTight(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Danh sách các công thức gợi ý
  Widget _buildSuggestionList(BuildContext context) {
    // Dữ liệu giả cho danh sách
    final suggestions = [
      {
        "imageUrl":
            'https://images.unsplash.com/photo-1646940930570-35ffcaedfd24?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjMwMzAwOTl8&ixlib=rb-4.1.0&q=80&w=1080',
        "title": 'Classic Tomato Pasta',
        "details": 'Italian • 25 mins • Easy',
        "rating": '4.2 (156)',
        "tags": 'Using: Pasta, Garlic, Cream, P...',
        "isBookmarked": false,
        "difficulty": "Easy",
        "difficultyColor": kColorSuccess,
      },
      {
        "imageUrl":
            'https://images.unsplash.com/photo-1725030660031-585ea459d55f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjMwMzAwOTl8&ixlib=rb-4.1.0&q=80&w=1080',
        "title": 'Mediterranean Tomato Salad',
        "details": 'Mediterranean • 15 mins • Easy',
        "rating": '4.8 (89)',
        "tags": 'Using: Tomatoes, Feta, Olives, ...',
        "isBookmarked": true,
        "difficulty": "Easy",
        "difficultyColor": kColorSuccess,
      },
      {
        "imageUrl":
            'https://images.unsplash.com/photo-1637438333468-2ea466032288?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjMwMzAwOTl8&ixlib=rb-4.1.0&q=80&w=1080',
        "title": 'Roasted Tomato Soup',
        "details": 'Comfort Food • 35 mins • Medium',
        "rating": '4.7 (342)',
        "tags": 'Using: Tomatoes, Cream, Onions, ...',
        "isBookmarked": false,
        "difficulty": "Medium",
        "difficultyColor": kColorRatingStar, // Màu cam
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(12.0),
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final recipe = suggestions[index];
        return _buildSuggestionCard(
          context: context,
          imageUrl: recipe['imageUrl'] as String,
          title: recipe['title'] as String,
          details: recipe['details'] as String,
          rating: recipe['rating'] as String,
          tags: recipe['tags'] as String,
          isBookmarked: recipe['isBookmarked'] as bool,
          difficulty: recipe['difficulty'] as String,
          difficultyColor: recipe['difficultyColor'] as Color,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12.0),
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
    required String difficulty,
    required Color difficultyColor,
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
        decoration: BoxDecoration(
          color: kColorCard,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x1A000000),
              offset: Offset(0, 2),
            )
          ],
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
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: kColorBorder,
                    child:
                        const Icon(Icons.broken_image, color: kColorSecondaryText),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: SizedBox(
                  height: 80, // Giữ chiều cao cố định
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.interTight(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0, // titleSmall
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            details,
                            style: GoogleFonts.inter(
                              color: kColorSecondaryText,
                              fontSize: 12.0, // bodySmall
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            difficulty,
                            style: GoogleFonts.inter(
                              color: difficultyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: kColorPrimary,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}