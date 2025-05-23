import 'package:dartz/dartz.dart';
import '../../../common/functions/exception_handler.dart';
import '../../../data/model/api_request_models/contact_us_request_model.dart';
import '../../../data/model/api_response_models/common_response_model.dart';
import '../../../data/repository/training_respository.dart';
import '../../training/usecase/base_usecase.dart';

class ContactUsUseCase extends BaseUseCase<ContactUsRequestModel, CommonResponseModel> {
  @override
  Future<Either<Failure, CommonResponseModel>> execute(ContactUsRequestModel input) {
    return TrainingRepository.contactUs( contactUsRequestModel: input);
  }
}