import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, HomeResponseModel>> getHomeData();
}
