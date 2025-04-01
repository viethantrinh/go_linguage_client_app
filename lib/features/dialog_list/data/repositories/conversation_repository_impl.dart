import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/dialog_list/data/datasources/conversation_data_source.dart';
import 'package:go_linguage/features/dialog_list/data/models/api_conversation_model.dart';
import 'package:go_linguage/features/dialog_list/domain/repositories/conversation_repository.dart';
import 'package:go_linguage/features/subject/data/datasources/subject_data_source.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/domain/repositories/subject_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSourceImpl conversationRemoteDataSourceImpl;

  ConversationRepositoryImpl({
    required this.conversationRemoteDataSourceImpl,
  });

  @override
  Future<Either<Failure, List<ConversationListResopnseModel>>>
      getConversationData() async {
    try {
      final response =
          await conversationRemoteDataSourceImpl.getConversationData();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
