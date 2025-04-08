import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/song/presentation/bloc/song_bloc.dart';
import 'package:go_router/go_router.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  void initState() {
    super.initState();
    context.read<SongBloc>().add(ViewData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        if (state is LoadedFailure) {
          // Hiển thị thông báo lỗi nếu cần
        }
      },
      builder: (context, state) {
        if (state is LoadingData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LoadedData) {
          final songList = state.songListResopnseModel;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100), // Chiều cao AppBar
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bài hát",
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: songList.length,
              itemBuilder: (context, index) {
                final item = songList[index];
                return GestureDetector(
                  onTap: () {
                    context.push(AppRoutePath.songPlayer, extra: item);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 2,
                        color: AppColor.line,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.music_note),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Icon(Icons.play_arrow),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
