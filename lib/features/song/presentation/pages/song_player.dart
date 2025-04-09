import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/song/data/models/api_song_model.dart';
import 'package:just_audio/just_audio.dart';

// Struct để lưu kết quả tìm kiếm
class WordSearchResult {
  final int lineIndex;
  final int wordIndex;

  WordSearchResult(this.lineIndex, this.wordIndex);
}

// Struct để lưu trữ thông tin về một từ và vị trí của nó trong lyrics
class WordPosition {
  final int lineIndex;
  final int wordIndex;
  final double startTime;
  final double endTime;

  WordPosition(this.lineIndex, this.wordIndex, this.startTime, this.endTime);
}

class SongPlayer extends StatefulWidget {
  final SongResopnseModel songData;
  const SongPlayer({super.key, required this.songData});

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();

  bool _isPlaying = false;
  double _sliderValue = 0.0;
  double _viewportHeight = 0;

  // Danh sách các từ từ timestamp và từ hiện tại đang highlight
  List<Word> words = [];
  int _currentLineIndex = -1;
  int _currentWordIndexInLine = -1;
  int _currentWordPointer = -1; // Con trỏ để theo dõi từ hiện tại
  final int MAX_ERROR_MS = 30; // Sai số tối đa cho phép (30ms)
  // Flag to track if playback has started
  bool _playbackStarted = false;

  // Bản đồ ánh xạ từ wordTimestamp index sang vị trí từ trong lyrics
  List<WordPosition> _wordPositions = [];

  // Danh sách các global key để xác định vị trí từng dòng
  List<GlobalKey> _lineKeys = [];

  // Phân chia lyrics thành các dòng
  late List<String> englishLines;
  late List<String> vietnameseLines;

  @override
  void initState() {
    super.initState();
    englishLines = widget.songData.englishLyric.split('\n');
    vietnameseLines = widget.songData.vietnameseLyric.split('\n');

    // Khởi tạo danh sách key cho từng dòng tiếng Anh
    _lineKeys = List.generate(englishLines.length, (_) => GlobalKey());

    // Tạo bản đồ ánh xạ từ timestamp sang vị trí trong lyrics
    _buildWordPositionMap();

    _initializePlayer();

    // Thêm listener để lấy chiều cao viewport
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _viewportHeight = MediaQuery.of(context).size.height;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Xây dựng bản đồ ánh xạ từ timestamp sang vị trí trong lyrics
  void _buildWordPositionMap() {
    _wordPositions = [];
    words = widget.songData.wordTimestamp.words;

    // Tách toàn bộ lyrics thành các từ và theo dõi vị trí dòng/từ
    int currentWordIndex = 0;

    for (int lineIndex = 0; lineIndex < englishLines.length; lineIndex++) {
      final lineWords = englishLines[lineIndex].split(' ');

      for (int wordIndex = 0; wordIndex < lineWords.length; wordIndex++) {
        if (currentWordIndex < words.length) {
          // Chuẩn hóa từ để so sánh
          final String normalizedLineWord =
              _normalizeWord(lineWords[wordIndex]);
          final String normalizedTimestampWord =
              _normalizeWord(words[currentWordIndex].word);

          // Nếu từ khớp, thêm vào bản đồ ánh xạ
          if (normalizedLineWord == normalizedTimestampWord) {
            _wordPositions.add(WordPosition(lineIndex, wordIndex,
                words[currentWordIndex].start, words[currentWordIndex].end));
            currentWordIndex++;
          }
          // Trường hợp từ không khớp có thể do lỗi timestamp hoặc lyrics
          // Chúng ta có thể thêm xử lý đặc biệt ở đây nếu cần
        }
      }
    }

    // Nếu không đủ từ được ánh xạ, thử một phương pháp khác
    if (_wordPositions.length < words.length / 2) {
      // Phương pháp đơn giản hơn: gán từng từ trong timestamp vào vị trí tương ứng
      _wordPositions = [];
      int totalWords = 0;
      List<int> wordsPerLine = [];

      // Đếm tổng số từ và số từ trên mỗi dòng
      for (int i = 0; i < englishLines.length; i++) {
        final lineWords =
            englishLines[i].split(' ').where((w) => w.trim().isNotEmpty).length;
        totalWords += lineWords;
        wordsPerLine.add(lineWords);
      }

      // Phân bổ các timestamp vào các từ theo tỷ lệ
      if (totalWords > 0 && words.length > 0) {
        int currentLineIndex = 0;
        int currentWordInLine = 0;

        for (int i = 0; i < words.length; i++) {
          _wordPositions.add(WordPosition(currentLineIndex, currentWordInLine,
              words[i].start, words[i].end));

          // Cập nhật vị trí từ tiếp theo
          currentWordInLine++;
          if (currentWordInLine >= wordsPerLine[currentLineIndex]) {
            currentLineIndex++;
            currentWordInLine = 0;
            if (currentLineIndex >= wordsPerLine.length) {
              break;
            }
          }
        }
      }
    }
  }

  Future<void> _initializePlayer() async {
    // Thiết lập audio player
    try {
      await _audioPlayer.setUrl(widget.songData.audioUrl);

      // Lắng nghe tiến độ phát nhạc để cập nhật vị trí từ hiện tại
      _audioPlayer.positionStream.listen((position) {
        final currentMilliseconds = position.inMilliseconds;
        final currentSeconds = currentMilliseconds / 1000;

        // Tìm từ hiện tại dựa trên con trỏ và sai số cho phép
        int wordIndex = _findCurrentWordWithPointer(currentSeconds);

        // Nếu tìm thấy từ hợp lệ và có ánh xạ vị trí từ
        if (wordIndex != -1 && wordIndex < _wordPositions.length) {
          // Lấy vị trí chính xác từ bản đồ ánh xạ
          int lineIndex = _wordPositions[wordIndex].lineIndex;
          int wordIndexInLine = _wordPositions[wordIndex].wordIndex;

          // Cập nhật UI nếu có thay đổi
          if (lineIndex != _currentLineIndex ||
              wordIndex != _currentWordPointer) {
            setState(() {
              _currentLineIndex = lineIndex;
              _currentWordIndexInLine = wordIndexInLine;
              _currentWordPointer = wordIndex;
              if (_audioPlayer.duration != null) {
                _sliderValue = currentSeconds /
                    _audioPlayer.duration!.inMilliseconds *
                    1000;
              }
            });

            // Tự động cuộn đến từ hiện tại
            if (lineIndex != -1) {
              _scrollToCurrentLine(lineIndex);
            }
          }
        }
      });

      // Lắng nghe trạng thái phát nhạc
      _audioPlayer.playerStateStream.listen((state) {
        if (state.playing != _isPlaying) {
          setState(() {
            _isPlaying = state.playing;
          });
        }
      });
    } catch (e) {
      print('Lỗi khi khởi tạo player: $e');
    }
  }

  // Tìm từ hiện tại sử dụng con trỏ và sai số cho phép
  int _findCurrentWordWithPointer(double currentSeconds) {
    if (_wordPositions.isEmpty) return -1;

    // Don't highlight any word if playback hasn't actually started
    if (currentSeconds < 0.1) {
      return -1;
    }

    // Set flag that playback has started
    if (!_playbackStarted) {
      _playbackStarted = true;
    }

    final currentMs = (currentSeconds * 1000).toInt();
    int candidateIndex = _currentWordPointer;

    // If currentWordPointer is -1 (initial state), start from the first word
    if (candidateIndex == -1) {
      candidateIndex = 0;
    }

    // Kiểm tra xem từ hiện tại có còn phù hợp không
    if (_isWithinWord(currentMs, candidateIndex)) {
      return candidateIndex;
    }

    // Kiểm tra xem có đang trong khoảng nghỉ giữa từ hiện tại và từ tiếp theo không
    if (candidateIndex < _wordPositions.length - 1) {
      final currentWordEndTime = _wordPositions[candidateIndex].endTime;
      final nextWordStartTime = _wordPositions[candidateIndex + 1].startTime;

      // Nếu thời gian hiện tại nằm trong khoảng nghỉ giữa hai từ
      // và khoảng nghỉ không quá dài (ví dụ: dưới 1.5 giây)
      if (currentSeconds > currentWordEndTime &&
          currentSeconds < nextWordStartTime &&
          nextWordStartTime - currentWordEndTime < 1.5) {
        // Giữ nguyên từ hiện tại cho đến khi thời gian gần tới từ tiếp theo
        // Chỉ chuyển khi thời gian đã qua 80% khoảng nghỉ
        double gapProgress = (currentSeconds - currentWordEndTime) /
            (nextWordStartTime - currentWordEndTime);
        if (gapProgress < 0.8) {
          return candidateIndex;
        }
      }
    }

    // Kiểm tra từ tiếp theo
    if (candidateIndex < _wordPositions.length - 1 &&
        _isWithinWord(currentMs, candidateIndex + 1)) {
      return candidateIndex + 1;
    }

    // Nếu khoảng cách từ từ hiện tại đến từ tiếp theo lớn (>1.5 giây), có thể là khoảng nghỉ dài giữa các câu
    // Chỉ chuyển đến từ tiếp theo khi thời gian hiện tại rất gần với từ tiếp theo
    if (candidateIndex < _wordPositions.length - 1) {
      final nextWordStartTime = _wordPositions[candidateIndex + 1].startTime;
      if (currentSeconds > _wordPositions[candidateIndex].endTime &&
          nextWordStartTime - currentSeconds < 0.2) {
        // Chỉ chuyển khi còn 200ms
        return candidateIndex + 1;
      }
    }

    // Tìm kiếm tuyến tính
    for (int i = 0; i < _wordPositions.length; i++) {
      if (_isWithinWord(currentMs, i)) {
        return i;
      }
    }

    // Nếu không tìm thấy từ nào chính xác, tìm từ gần nhất
    if (_wordPositions.isNotEmpty) {
      if (currentSeconds < _wordPositions.first.startTime) {
        return 0; // Trước từ đầu tiên
      } else if (currentSeconds > _wordPositions.last.endTime) {
        return _wordPositions.length - 1; // Sau từ cuối cùng
      } else {
        // Tìm từ gần nhất
        for (int i = 0; i < _wordPositions.length - 1; i++) {
          if (currentSeconds > _wordPositions[i].endTime &&
              currentSeconds < _wordPositions[i + 1].startTime) {
            // Khoảng cách giữa các từ
            double gapDuration =
                _wordPositions[i + 1].startTime - _wordPositions[i].endTime;

            // Nếu khoảng cách lớn (> 1.5 giây), có thể là khoảng nghỉ giữa các câu
            if (gapDuration > 1.5) {
              // Ở gần từ đầu tiên -> giữ từ trước đó
              if (_wordPositions[i + 1].startTime - currentSeconds > 0.3) {
                return i;
              }
              // Ở gần từ thứ hai -> chuyển sang từ tiếp theo
              else {
                return i + 1;
              }
            }

            // Chọn từ gần nhất nếu khoảng cách ngắn
            double diff1 = currentSeconds - _wordPositions[i].endTime;
            double diff2 = _wordPositions[i + 1].startTime - currentSeconds;
            return diff1 < diff2 ? i : i + 1;
          }
        }
      }
    }

    return -1;
  }

  // Kiểm tra xem thời gian hiện tại có nằm trong phạm vi của từ với sai số cho phép
  bool _isWithinWord(int currentMs, int wordIndex) {
    if (wordIndex < 0 || wordIndex >= _wordPositions.length) return false;

    final WordPosition wordPos = _wordPositions[wordIndex];
    final int startMs = (wordPos.startTime * 1000).toInt();
    final int endMs = (wordPos.endTime * 1000).toInt();

    // Thời gian nằm trong khoảng với sai số cho phép
    return (currentMs + MAX_ERROR_MS >= startMs &&
        currentMs - MAX_ERROR_MS <= endMs);
  }

  // Chuẩn hóa từ để so sánh chính xác
  String _normalizeWord(String word) {
    // Bỏ dấu câu và chuyển về chữ thường
    return word.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
  }

  // Cuộn đến dòng hiện tại, đảm bảo từ hiện tại nằm ở giữa màn hình
  void _scrollToCurrentLine(int lineIndex) {
    if (_scrollController.hasClients &&
        lineIndex >= 0 &&
        lineIndex < _lineKeys.length) {
      // Lấy context của dòng hiện tại
      final RenderBox? box =
          _lineKeys[lineIndex].currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;

      // Tính vị trí của dòng trên màn hình
      final position = box.localToGlobal(Offset.zero);

      // Tính toán offset để đảm bảo dòng nằm chính giữa màn hình
      // Trừ đi khoảng 70px cho phần UI phía dưới (slider và play button)
      final double screenCenter = (_viewportHeight - 70) / 2;
      final double lineCenter = box.size.height / 2;
      final double offsetToCenter = position.dy - screenCenter + lineCenter;

      // Tính toán vị trí cuộn mới
      double scrollOffset = _scrollController.offset + offsetToCenter;

      // Đảm bảo offset nằm trong phạm vi hợp lệ
      if (scrollOffset < 0) {
        scrollOffset = 0;
      } else if (scrollOffset > _scrollController.position.maxScrollExtent) {
        scrollOffset = _scrollController.position.maxScrollExtent;
      }

      // Luôn cuộn để từ nằm giữa màn hình, không phân biệt từ đã hiển thị hay chưa
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // Điều khiển phát/dừng nhạc
  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách song ngữ tiếng Anh và tiếng Việt
    List<Widget> lyricsLineWidgets = [];

    for (int i = 0; i < englishLines.length; i++) {
      // Thêm dòng tiếng Anh, với highlight từ hiện tại nếu thuộc dòng này
      lyricsLineWidgets.add(
        Container(
          key: _lineKeys[i],
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: i == _currentLineIndex
              ? Center(child: _buildHighlightedLine(englishLines[i], _currentWordIndexInLine))
              : Text(
                  englishLines[i],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      );

      // Thêm dòng tiếng Việt tương ứng nếu có
      if (i < vietnameseLines.length) {
        lyricsLineWidgets.add(
          Padding(
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
            child: Text(
              vietnameseLines[i],
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: AppColor.line, width: 2),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                Text(widget.songData.name,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 40), // Để cân đối với nút back
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Lyrics area
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: lyricsLineWidgets,
            ),
          ),

          Slider(
            value: _sliderValue.clamp(0.0, 1.0),
            onChanged: (value) {
              // Người dùng thay đổi vị trí
              if (_audioPlayer.duration != null) {
                final position = _audioPlayer.duration!.inMilliseconds * value;
                _audioPlayer.seek(Duration(milliseconds: position.toInt()));
              }
            },
          ),

          GestureDetector(
            onTap: _togglePlayPause,
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 50,
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  // Hàm xây dựng dòng với từ được highlight
  Widget _buildHighlightedLine(String line, int highlightWordIndex) {
    // Tách dòng thành các từ
    final words = line.split(' ');

    // Kiểm tra tính hợp lệ của chỉ số từ
    if (highlightWordIndex < 0 || highlightWordIndex >= words.length) {
      return Text(
        line,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      );
    }

    // Tạo list TextSpan cho RichText
    List<TextSpan> textSpans = [];

    for (int i = 0; i < words.length; i++) {
      // Thêm TextSpan tương ứng
      textSpans.add(
        TextSpan(
          text: i < words.length - 1 ? '${words[i]} ' : words[i],
          style: TextStyle(
            fontSize: 18, // Đảm bảo kích thước font giống nhau
            color: Colors.black,
            fontWeight: 
                i == highlightWordIndex ? FontWeight.bold : FontWeight.normal,
            backgroundColor:
                i == highlightWordIndex ? AppColor.primary100 : null,
          ),
        ),
      );
    }

    // Trả về RichText với các từ đã được highlight, với căn giữa
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
