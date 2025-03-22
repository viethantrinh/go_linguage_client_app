import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class CacheAudioPlayer extends StatefulWidget {
  final String? url;
  final bool autoPlay;
  final Widget child;
  final VoidCallback? onPlayComplete;

  const CacheAudioPlayer({
    super.key,
    this.url,
    this.autoPlay = false,
    required this.child,
    this.onPlayComplete,
  });

  @override
  State<CacheAudioPlayer> createState() => _CacheAudioPlayerState();
}

class _CacheAudioPlayerState extends State<CacheAudioPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;

  // Use the singleton instance
  final _audioCacheManager = AudioCacheManager();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    //_audioPlayer.setSpeed(0.5);

    // Listen for playback completion
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });

          if (widget.onPlayComplete != null) {
            widget.onPlayComplete!();
          }
        }
      }
    });

    // Auto play if enabled
    if (widget.autoPlay && widget.url != null) {
      _playAudio();
    }
  }

  @override
  void didUpdateWidget(CacheAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If URL changes, stop current audio and reset state
    if (oldWidget.url != widget.url) {
      _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });

      // Auto play with new URL if enabled
      if (widget.autoPlay && widget.url != null) {
        _playAudio();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Play or stop audio
  Future<void> _playAudio() async {
    if (widget.url == null || widget.url!.isEmpty) return;

    // If already playing, stop and return
    if (_isPlaying) {
      _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Get cached file
      final audioFile = await _audioCacheManager.getAudioFile(widget.url!);

      // Set up and play
      await _audioPlayer.setFilePath(audioFile.path);
      await _audioPlayer.play();

      if (mounted) {
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Audio player error: $e');
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _playAudio,
      child: widget.child,
    );
  }
}

class AudioCacheManager {
  static final AudioCacheManager _instance = AudioCacheManager._internal();
  factory AudioCacheManager() => _instance;
  AudioCacheManager._internal();

  final Map<String, File> _cachedFiles = {};
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  // Local directory for more permanent storage
  Directory? _appCacheDir;

  // Initialize the cache directory
  Future<void> _initCacheDir() async {
    if (_appCacheDir != null) return;
    _appCacheDir = await getApplicationCacheDirectory();
  }

  // Generate a filename from URL using MD5 hash
  String _getFileNameFromUrl(String url) {
    var bytes = utf8.encode(url);
    var digest = md5.convert(bytes);
    return digest.toString() + '.mp3';
  }

  // Get file from cache or download if needed
  Future<File> getAudioFile(String url) async {
    // Return from memory cache if available
    if (_cachedFiles.containsKey(url)) {
      return _cachedFiles[url]!;
    }

    // Initialize cache directory if needed
    await _initCacheDir();

    // Check persistent cache first
    final fileName = _getFileNameFromUrl(url);
    final persistentFile = File('${_appCacheDir!.path}/$fileName');
    if (await persistentFile.exists()) {
      _cachedFiles[url] = persistentFile;
      return persistentFile;
    }

    // Check Flutter cache manager
    final fileInfo = await _cacheManager.getFileFromCache(url);
    if (fileInfo != null) {
      // Copy to our persistent cache
      await fileInfo.file.copy(persistentFile.path);
      _cachedFiles[url] = persistentFile;
      return persistentFile;
    }

    // Download and cache
    final fileInfo2 = await _cacheManager.downloadFile(url);

    // Save to persistent cache
    await fileInfo2.file.copy(persistentFile.path);
    _cachedFiles[url] = persistentFile;
    return persistentFile;
  }

  // Clear all caches
  Future<void> clearCache() async {
    _cachedFiles.clear();
    await _cacheManager.emptyCache();

    // Clear persistent cache
    if (_appCacheDir != null && await _appCacheDir!.exists()) {
      final audioFiles = await _appCacheDir!
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.mp3'))
          .toList();

      for (var entity in audioFiles) {
        if (entity is File) {
          await entity.delete();
        }
      }
    }
  }
}
