import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/dialog_list/data/models/api_conversation_model.dart';
import 'package:go_linguage/features/dialog_list/domain/repositories/conversation_repository.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/domain/repositories/subject_repository.dart';

class ConversationViewUsecase implements UseCase<void, void> {
  final ConversationRepository conversationRepository;

  ConversationViewUsecase(this.conversationRepository);
  @override
  Future<Either<Failure, List<ConversationListResopnseModel>>> call(
      void params) async {
    final res = await conversationRepository.getConversationData();
    return res;
  }
}
