import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/cache_image.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/dialog_list/presentation/bloc/conversation_bloc.dart';
import 'package:go_router/go_router.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(ViewData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state is LoadingData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LoadedData) {
          final conversationModel = state.conversationModel;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100), // Chiều cao AppBar
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hội thoại",
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: conversationModel.length,
              itemBuilder: (context, index) {
                final item = conversationModel[index];
                return GestureDetector(
                  onTap: () {
                    if (item.premium) {
                      context.go(AppRoutePath.subscription);
                    } else {
                      context.push('/conversation/${item.id}');
                    }
                  },
                  child: Opacity(
                    opacity: item.premium ? 0.5 : 1,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CacheImage(
                              imageUrl: item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (item.premium)
                            Icon(
                              Icons.lock,
                              size: 20,
                            ),
                        ],
                      ),
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
