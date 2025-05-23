import 'package:dartz/dartz.dart';
import '../../../common/functions/exception_handler.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}
