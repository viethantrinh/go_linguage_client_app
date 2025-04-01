import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/dialog_list/data/models/api_conversation_model.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

abstract interface class ConversationRepository {
  Future<Either<Failure, List<ConversationListResopnseModel>>>
      getConversationData();
}
