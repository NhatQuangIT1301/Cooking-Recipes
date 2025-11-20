import '../ai/text_find_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// SỬA ĐỔI: Thêm import cho trang tìm kiếm bằng text

// --- Định nghĩa màu sắc (trích xuất từ theme) ---
const Color kColorBackground = Color(0xFFE3ECE1);
const Color kColorPrimary = Color(0xFF4B986C); // Xanh lá cây
const Color kColorPrimaryLight = Color(0x4D4B986C); // Xanh lá 30%
const Color kColorPrimaryText = Color(0xFF0B191E);
const Color kColorSecondaryText = Color(0xFF384E58);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorBorder = Color(0xFFC8D7E4);
const Color kColorError = Color(0xFFC4454D);

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({super.key});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  late TextEditingController _textController;
  late FocusNode _textFieldFocusNode;
  
  // State để quản lý hiệu ứng "đang nghe"
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFieldFocusNode = FocusNode();
    _isListening = false;
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  // --- HÀM LOGIC (Xử lý flow) ---

  // Hàm này được gọi khi nhấn vào micro
  void _onMicTapped() {
    setState(() {
      _isListening = !_isListening; // Bật/tắt trạng thái nghe
    });
    
    if (_isListening) {
      print('Started listening...');
      // TODO: Thêm logic của gói 'speech_to_text' để bắt đầu nghe
    } else {
      print('Stopped listening.');
      // TODO: Dừng nghe
    }
  }

  // Hàm này được gọi khi nhấn nút "Search Recipes"
  // (ĐÂY LÀ PHẦN BẠN YÊU CẦU - NÓ ĐÃ CÓ SẴN)
  void _onSearchPressed() {
    final query = _textController.text;
    // if (query.isEmpty) return; // Bỏ check này để luôn chuyển trang

    print('Navigating to AI Text Search');
    // SỬA ĐỔI: Điều hướng đến trang AI Text Search (thay vì in ra console)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AiTextSearchScreen(),
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
        body: _buildBody(context),
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kColorBackground,
      elevation: 0.0,
      centerTitle: false,
      automaticallyImplyLeading: false, // Tắt nút back tự động
      
      // SỬA LỖI LOGIC: Nút "Return" nên ở 'leading' (bên trái)
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: const Icon(Icons.keyboard_return, color: kColorPrimaryText),
          style: IconButton.styleFrom(
            backgroundColor: kColorCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      
      // Tiêu đề
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: kColorPrimaryLight,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: kColorPrimary,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Text(
            'Recipe Finder',
            style: GoogleFonts.urbanist(
              color: kColorPrimaryText,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
      actions: const [], // Bỏ nút 'actions' (đã chuyển sang leading)
    );
  }

  Widget _buildBody(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter, // Giống code gốc
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48.0),
              Text(
                'Find Your Recipe',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  color: kColorPrimaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Speak or type to discover delicious recipes',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: kColorSecondaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  height: 1.4, // Line height
                ),
              ),
              const SizedBox(height: 32.0),

              // Nút Micro (đã làm tương tác)
              _buildMicButton(),
              const SizedBox(height: 16.0),

              Text(
                _isListening ? 'Listening...' : 'Tap to speak',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: _isListening ? kColorPrimary : kColorPrimaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Say something like: "Chicken and rice"',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: kColorSecondaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 32.0),

              // Dải phân cách
              const Divider(color: kColorBorder, thickness: 1.0),
              const SizedBox(height: 16.0),

              Text(
                'Or type your request',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: kColorPrimaryText, // Đổi màu trắng -> đen
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 16.0),

              // Ô nhập liệu
              _buildTextField(),
              const SizedBox(height: 32.0),

              // Nút Search
              _buildSearchButton(),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm trợ giúp cho nút Micro (thêm animation)
  Widget _buildMicButton() {
    // Kích thước sẽ thay đổi khi _isListening
    final double size = _isListening ? 220.0 : 200.0;
    
    return GestureDetector(
      onTap: _onMicTapped,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 8.0),
            )
          ],
          gradient: LinearGradient(
            colors: [kColorPrimary, kColorPrimaryLight],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          shape: BoxShape.circle,
        ),
        // Vòng tròn trắng bên trong
        child: Center(
          child: Container(
            width: 180.0,
            height: 180.0,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F4F8), // Nền trắng nhạt
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic_rounded,
              color: kColorPrimary,
              size: 80.0,
            ),
          ),
        ),
      ),
    );
  }

  // Hàm trợ giúp cho ô nhập liệu
  Widget _buildTextField() {
    return TextFormField(
      controller: _textController,
      focusNode: _textFieldFocusNode,
      decoration: InputDecoration(
        hintText: 'What would you like to cook today?',
        hintStyle: GoogleFonts.plusJakartaSans(
          color: kColorSecondaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: kColorCard,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        suffixIcon: const Icon(Icons.search_rounded, color: kColorPrimary),
        // Border
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kColorBorder, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kColorPrimary, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kColorError, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kColorError, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      style: GoogleFonts.plusJakartaSans(
        color: kColorPrimaryText,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 3,
      minLines: 1,
      cursorColor: kColorPrimary,
    );
  }

  // Hàm trợ giúp cho nút Search
  Widget _buildSearchButton() {
    return ElevatedButton.icon(
      onPressed: _onSearchPressed,
      icon: const Icon(Icons.restaurant_menu_rounded, size: 24.0),
      label: Text(
        'Search Recipes',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kColorPrimary,
        foregroundColor: Colors.white,
        elevation: 0.0,
        minimumSize: const Size(double.infinity, 52.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}