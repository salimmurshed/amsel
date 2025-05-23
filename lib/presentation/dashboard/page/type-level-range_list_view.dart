import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model/local_models/training_details.dart';
import '../../../imports/common.dart';
import '../bloc/dashboard_bloc.dart';
import '../widget/list_item_card_view.dart';

class TrainingTypeLevelRangeView extends StatelessWidget {
  const TrainingTypeLevelRangeView({super.key, required this.selectedMode});

  final String selectedMode;

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    return BlocBuilder<DashboardBloc, DashboardWithInitialState>(
      bloc: dashboardBloc..add(FetchTrainingTypeLevelRangeList(selectedMode: selectedMode)),
      builder: (context, state) {
        List<DashboardMenuModel> list = getList(selectedMode: selectedMode, context: context, state: state);
        return Container(
            decoration: Style.bottomSheetDecoration(),
            height: getScreenHeight(context: context) * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(screenHPadding, screenVPadding, screenHPadding, 10.h),
                  child: getTitle(selectedMode: selectedMode, context: context),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    padding: EdgeInsets.fromLTRB(screenHPadding, 10.h, screenHPadding, screenVPadding),
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      var data = list[index];
                      bool isSelected = getSelectedValue(
                          selectedMode: selectedMode, state: state, serverTitle: data.serverTitle);
                      return GestureDetector(
                        onTap: () {
                          dashboardBloc.add(TriggerTypeLevelRangeSelection(
                              item: data, selectedMode: selectedMode));
                        },
                        child: ListItemCardView(
                            isSelected: isSelected,
                            title: data.title,
                            subTitle: data.info,
                            iconData: data.icon),
                      );
                    },
                    separatorBuilder: (context, int index) {
                      return SizedBox(height: widgetBottomPadding);
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }

  List<DashboardMenuModel> getList(
      {required String selectedMode,
      required BuildContext context,
      required DashboardWithInitialState state}) {
    {
      List<DashboardMenuModel> list = [];
      if (selectedMode == AppStrings.training_trainingType) {
        list = state.typeList;
      } else if (selectedMode == AppStrings.training_trainingLevel) {
        list = state.levelList;
      } else if (selectedMode == AppStrings.training_trainingRange) {
        list = state.rangeList;
      } else {
        list = state.focusList;
      }
      return list;
    }
  }

  Widget getTitle(
      {required String selectedMode, required BuildContext context}) {
    String firstPart =
        getFirstPart(selectedMode: selectedMode, context: context);
    String secondPart =
        getSecondPart(selectedMode: selectedMode, context: context);
    String thirdPart =
        getThirdPart(selectedMode: selectedMode, context: context);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: getFirstPart(selectedMode: selectedMode, context: context),
              style: Style.subHeaderStyle()),
          TextSpan(
            text: getSecondPart(selectedMode: selectedMode, context: context),
            style: Style.subHeaderStyle(colorBG: AppColor.colorPrimaryBG),
          ),
          TextSpan(
              text: getThirdPart(selectedMode: selectedMode, context: context),
              style: Style.subHeaderStyle()),
        ],
      ),
    );
  }

  String getFirstPart(
      {required String selectedMode, required BuildContext context}) {
    switch (selectedMode) {
      case AppStrings.training_trainingType:
        return AppLocalizations.of(context)!.training_type_title_partOne;
      case AppStrings.training_trainingLevel:
        return AppLocalizations.of(context)!.training_level_title_partOne;
      case AppStrings.training_trainingRange:
        return AppLocalizations.of(context)!.training_range_title_partOne;
      default:
        return "";
    }
  }

  String getSecondPart(
      {required String selectedMode, required BuildContext context}) {
    switch (selectedMode) {
      case AppStrings.training_trainingType:
        return AppLocalizations.of(context)!.training_type_title_partTwo;
      case AppStrings.training_trainingLevel:
        return AppLocalizations.of(context)!.training_level_title_partTwo;
      case AppStrings.training_trainingRange:
        return AppLocalizations.of(context)!.training_range_title_partTwo;
      default:
        return "";
    }
  }

  String getThirdPart({required String selectedMode, required BuildContext context}) {
    switch (selectedMode) {
      case AppStrings.training_trainingType:
        return AppLocalizations.of(context)!.training_type_title_partThree;
      case AppStrings.training_trainingLevel:
        return AppLocalizations.of(context)!.training_level_title_partThree;
      case AppStrings.training_trainingRange:
        return AppLocalizations.of(context)!.training_range_title_partThree;
      default:
        return "";
    }
  }

  bool getSelectedValue({required String selectedMode, required DashboardWithInitialState state, required String serverTitle}) {
    switch (selectedMode) {
      case AppStrings.training_trainingType:
        return state.selectedType == serverTitle ? true : false;
      case AppStrings.training_trainingLevel:
        return state.selectedLevel == serverTitle ? true : false;
      case AppStrings.training_trainingRange:
        return state.selectedRange == serverTitle ? true : false;
      default:
        return state.selectedFocus == serverTitle ? true : false;
    }
  }
}