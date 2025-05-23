import 'package:dartz/dartz.dart';
import '../../../common/functions/exception_handler.dart';
import '../../../data/model/api_request_models/training_request_model.dart';
import '../../../data/model/api_response_models/training_response.dart';
import '../../../data/repository/training_respository.dart';
import 'base_usecase.dart';

class TrainingUseCase extends BaseUseCase<TrainingRequestModel, TrainingResponse> {
  @override
  Future<Either<Failure, TrainingResponse>> execute(TrainingRequestModel input) {
    return TrainingRepository.trainingList(trainingRequestModel: input);
  }
}