import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:go_linguage/features/home/domain/repositories/home_repository.dart';

class HomeViewUsecase implements UseCase<void, void> {
  final HomeRepository homeRepository;

  HomeViewUsecase(this.homeRepository);
  @override
  Future<Either<Failure, HomeResponseModel>> call(void params) async {
    final res = await homeRepository.getHomeData();
    return res;
  }
}
