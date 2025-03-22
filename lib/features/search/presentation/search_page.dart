import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:go_linguage/features/lesson/presentation/pages/learn_lesson.dart';
import 'package:go_router/go_router.dart';
import 'package:go_linguage/core/route/app_route_path.dart';

class SearchPage extends StatefulWidget {
  final HomeResponseModel data;
  const SearchPage({super.key, required this.data});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<TopicModel> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách tất cả các chủ đề từ tất cả các cấp độ
    _getAllTopics();

    // Lắng nghe thay đổi trong ô tìm kiếm
    _searchController.addListener(_filterTopics);
  }

  // Lấy tất cả các chủ đề từ tất cả các cấp độ
  void _getAllTopics() {
    _filteredTopics = [];
    for (var level in widget.data.levels) {
      _filteredTopics.addAll(level.topics);
    }
    // Sắp xếp theo thứ tự hiển thị
    _filteredTopics.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  // Lọc chủ đề dựa trên từ khóa tìm kiếm
  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _getAllTopics();
      } else {
        _filteredTopics = [];
        for (var level in widget.data.levels) {
          _filteredTopics.addAll(level.topics
              .where((topic) => topic.name.toLowerCase().contains(query)));
        }
        // Sắp xếp theo thứ tự hiển thị
        _filteredTopics
            .sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTopics);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5, color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  const CustomBackButton(),
                  Text(
                    "Tìm kiếm bài học",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài học',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 1.5),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
            ),
          ),

          // Danh sách chủ đề
          Expanded(
            child: _filteredTopics.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không tìm thấy bài học nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTopics.length,
                    itemBuilder: (context, index) {
                      return _buildTopicCard(_filteredTopics[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thẻ chủ đề
  Widget _buildTopicCard(TopicModel topic) {
    // Tìm cấp độ chứa chủ đề này
    final level = widget.data.levels.firstWhere(
      (level) => level.topics.any((t) => t.id == topic.id),
      orElse: () => widget.data.levels.first,
    );

    return GestureDetector(
      onTap: () {
        if (!topic.premium || widget.data.isSubscribed) {
          // Tìm subjectId và lessonId
          final subjectId = level.id.toString();
          final lessonId = topic.id.toString();

          // Điều hướng đến trang bài học
          context
              .push('${AppRoutePath.home}/subject/$subjectId/lesson/$lessonId');
        } else {
          // Nếu là bài học premium và người dùng chưa đăng ký
          context.push(AppRoutePath.subscription);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 2,
            color: Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Hình ảnh chủ đề
              _buildTopicImage(topic.imageUrl),

              const SizedBox(width: 16),

              // Nội dung chủ đề
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề và trạng thái
                    Row(
                      children: [
                        if (topic.totalUserXPPoints > 0) ...[
                          const Icon(
                            Icons.workspace_premium,
                            color: Color(0xFFFFA000),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('${topic.totalUserXPPoints} / 18',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Tiêu đề chủ đề
                    Text(topic.name,
                        style: Theme.of(context).textTheme.titleMedium),

                    // Hiển thị tên cấp độ
                    Text(
                      level.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    // Thanh tiến độ (nếu có)
                    if (topic.totalUserXPPoints > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: topic.totalUserXPPoints / 18,
                          backgroundColor: Colors.grey.shade200,
                          color: const Color(0xFF4FC3F7),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Icon khóa hoặc check
              if (topic.premium && !widget.data.isSubscribed)
                const Icon(Icons.lock, color: Colors.grey)
              else if (topic.totalUserXPPoints >= 18)
                const Icon(Icons.check_circle, color: Colors.green)
              else if (topic.totalUserXPPoints > 0)
                const Icon(Icons.play_circle_filled, color: Colors.blue)
              else
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị hình ảnh chủ đề
  Widget _buildTopicImage(String imageUrl) {
    return Image.network(
      width: 50,
      height: 50,
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage();
      },
    );
  }

  // Widget hiển thị hình ảnh dự phòng khi không tìm thấy hình ảnh
  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Icon(
        Icons.pets,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

// Lớp mô hình cho chủ đề bài học
class LessonTopic {
  final String title;
  final String progress;
  final double progressPercent;
  final bool isLocked;
  final bool hasProgress;
  final String leftImage;
  final String? rightImage;

  LessonTopic({
    required this.title,
    this.progress = '',
    this.progressPercent = 0.0,
    this.isLocked = true,
    this.hasProgress = false,
    required this.leftImage,
    this.rightImage,
  });
}
