import 'package:amsel_flutter/presentation/dashboard/widget/row_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/widgets/alert_dialog.dart';
import '../../../imports/common.dart';
import '../../../main.dart';
import '../bloc/dashboard_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouriteTrainingListView extends StatelessWidget {
  const FavouriteTrainingListView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    return BlocBuilder<DashboardBloc, DashboardWithInitialState>(
      bloc: dashboardBloc..add(FetchFavouriteTrainingList()),
      builder: (context, state) {
        return Container(
            decoration: Style.bottomSheetDecoration(),
            height: getScreenHeight(context: context) * 0.8,
            child: Column(
              children: [
                SizedBox(height: screenVPadding),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHPadding),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .training_favBottomSheet_partOne,
                            style: Style.headerStyle()),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .training_favBottomSheet_partTwo,
                          style: Style.headerStyle(
                              colorBG: AppColor.colorPrimaryBG),
                        ),
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .training_favBottomSheet_partThree,
                            style: Style.headerStyle()),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: state.isFavLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.favouriteTrainings.isEmpty
                          ? Center(
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .training_noDataFound_text,
                                  style: Style.descTextBoldStyle()),
                            )
                          : ListView.separated(
                              itemCount: state.favouriteTrainings.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenHPadding, vertical: 10.h),
                              itemBuilder: (context, int index) {
                                var data = state.favouriteTrainings[index];
                                // debugPrint("length ${state.favouriteTrainings.length}");
                                return GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    dashboardBloc.add(
                                        TriggerToSetFavouriteTrainingDataEvent(
                                            trainingId: data));
                                  },
                                  child: Container(
                                    decoration: Style.containerShadowDecoration(
                                        radius: containerRadius,
                                        color: AppColor.colorVeryLightGrey),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: containerVerticalPadding,
                                                  left:
                                                      containerHorizontalPadding,
                                                  bottom: 6.h),
                                              child: Text(data.title,
                                                  style: Style
                                                      .descTextBoldStyle()),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:(_) {
                                                      return CustomAlertDialog(
                                                        title: AppLocalizations.of(
                                                            context)!
                                                            .statistics_delete_training_dialogTitle,
                                                        subTitle: AppLocalizations.of(
                                                            context)!
                                                            .statistics_delete_training_dialogDesc,
                                                        btnText: AppLocalizations.of(
                                                            context)!
                                                            .statistics_delete_training_dialogDeleteBtn,
                                                        onTapButton:
                                                            () {
                                                          Navigator.pop(context);
                                                          dashboardBloc.add(
                                                              TriggerRemoveFromFavouriteEvent(
                                                                  trainingId: data.id));
                                                        },
                                                      );
                                                    });

                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                padding: EdgeInsets.fromLTRB(
                                                    containerHorizontalPadding,
                                                    containerVerticalPadding,
                                                    containerHorizontalPadding,
                                                    6.h),
                                                child:  ImageView(
                                                  svgPath: Assets.icBin,
                                                  height: isTablet?20.h:null,
                                                  width: isTablet?20.w:null,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenHPadding),
                                          child: const CustomDivider(),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              containerHorizontalPadding,
                                              8.h,
                                              containerHorizontalPadding,
                                              0),
                                          child: rowWithDoubleIconText(
                                            leftText:
                                                '${formatDuration(data.duration)} ${AppLocalizations.of(context)!.dashboard_slider_minute_txt}',
                                            rightText: data.type,
                                            leftImagePath: Assets.icAlarm,
                                            rightImagePath:
                                                Assets.icQuestionMark,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                                horizontal:
                                                    containerHorizontalPadding),
                                            child: rowWithIconText(
                                                text: data.focus.toString(),
                                                imagePath:
                                                    Assets.icCircleRing)),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              containerHorizontalPadding,
                                              0,
                                              containerHorizontalPadding,
                                              containerVerticalPadding),
                                          child: rowWithDoubleIconText(
                                            leftText: data.range.toString(),
                                            rightText: data.level,
                                            leftImagePath: Assets.icEar,
                                            rightImagePath: Assets.icStar,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
}
