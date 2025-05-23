import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';
import '../bloc/dashboard_bloc.dart';
import '../widget/focus_list_item_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrainingFocusView extends StatelessWidget {
  const TrainingFocusView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    return BlocBuilder<DashboardBloc, DashboardWithInitialState>(
        bloc: dashboardBloc..add(FetchFocusList()),
        builder: (context, state) {
          return Container(
              decoration: Style.bottomSheetDecoration(),
              height: getScreenHeight(context: context) * 0.8,
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(screenHPadding, screenVPadding, screenHPadding, 10.h),
                  //   child: Text(AppLocalizations.of(context)!.newTraining_trainingFocus,
                  //       style: Style.headerStyle()),
                  // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenHPadding, screenVPadding, screenHPadding, 10.h),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!.training_focus_title_partOne,
                              style: Style.subHeaderStyle()),
                          TextSpan(
                            text: AppLocalizations.of(context)!.training_focus_title_partTwo,
                            style: Style.subHeaderStyle(colorBG: AppColor.colorPrimaryBG),
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!.training_focus_title_partThree,
                              style: Style.subHeaderStyle()),
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(screenHPadding, 10.h, screenHPadding, screenVPadding),
                      itemCount: state.focusList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, int index) {
                        var data = state.focusList[index];
                        return GestureDetector(
                          onTap: () {
                            dashboardBloc
                                .add(TriggerFocusSelection(item: data));
                          },
                          child: FocusListItemView(
                              isSelected: state.selectedFocusList.contains(data.serverTitle)
                                  ? true
                                  : false,
                              index: index,
                              length: state.focusList.length - 1,
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
              )
          );
        },
      );
  }
}
