import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/exam/presentation/bloc/exam_bloc.dart';
import 'package:go_linguage/features/exam/presentation/pages/vocabulary_learned.dart';
import 'package:go_router/go_router.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ExamBloc>().add(ViewData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamBloc, ExamState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingData) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedData) {
          final examData = state.props[0] as ExamResopnseModel;
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
                      "Kiểm tra tổng hợp",
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Test your skills card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F0FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Test your\nskills',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Take a review exam to see how\nmuch you remember.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: AppColor.primary500,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary500,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Take the exam',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Flashcards section
                    Text(
                      'Flashcards',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutePath.flashCard,
                            extra: examData.flashCards);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.line, width: 2),
                        ),
                        child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8E0FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.card_giftcard,
                                color: Color(0xFF7C4DFF),
                              ),
                            ),
                            title: Text(
                              'Flashcards',
                              style: Theme.of(context).textTheme.titleMedium,
                            )),
                      ),
                    ),

                    const SizedBox(height: 32),
                    // Previously learned section
                    Text(
                      'Previously learned',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutePath.myVocabulary,
                            extra: examData.previousLearned.vocabularies);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.line, width: 2),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE3F2FD),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.list_alt,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            'My vocabulary',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutePath.myDialog,
                            extra: examData.previousLearned.dialogues);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.line, width: 2),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE3F2FD),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            'Hội thoại',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Error'));
        }
      },
    );
  }
}
