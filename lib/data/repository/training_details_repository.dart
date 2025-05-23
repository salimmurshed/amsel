import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import '../../common/functions/other.dart';
import '../../common/resources/app_strings.dart';
import '../../services/share_preferences_services/training_data.dart';
import '../model/local_models/training_details.dart';

class TrainingDetailsRepository{
  static Future<DashboardDetailLists> fetchTrainingDetails() async {
    TrainingData trainingData = RepositoryDependencies.trainingData;
    String type = await trainingData.geTrainingType();
    bool isRangeFocusVisible = false;
    // debugPrint("fetch dash data is");
    if(type.isEmpty){
      isRangeFocusVisible = true;
      await trainingData.seTrainingType(type: DashboardDetailsData.typeList[2].serverTitle);
      await trainingData.setTrainingLevel(level: DashboardDetailsData.levelList[1].serverTitle);
      await trainingData.setTrainingRange(
          range: DashboardDetailsData.rangeList[0].serverTitle);
      await trainingData.setTrainingFocus(
          focus: DashboardDetailsData.focusList[0].serverTitle);
    } else {
      if(type == AppStrings.training_type_serverId_three || type == AppStrings.training_type_serverId_four){
        isRangeFocusVisible = true;
      } else {
        isRangeFocusVisible = false;
      }
    }

    type =  await GetDashboardSelectedData.getTypeValue();
    String level =  await GetDashboardSelectedData.getLevelValue();
    String range = await GetDashboardSelectedData.getRangeValue();
    String focus = await GetDashboardSelectedData.getFocusValue();

    DashboardDetailLists dashboardDetailLists = DashboardDetailLists(
        typeList: DashboardDetailsData.typeList,
        levelList: DashboardDetailsData.levelList,
        rangeList: DashboardDetailsData.rangeList,
        focusList: DashboardDetailsData.focusList,
      isRangeFocusVisible: isRangeFocusVisible,
      selectedType: type,
      selectedLevel: level,
      selectedRange: range,
      selectedFocus: focus
    );
    return dashboardDetailLists;
  }
}