import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/resources/slider_theme.dart';
import '../../../common/resources/training_constants.dart';
import '../../../imports/common.dart';
import '../../../main.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../common/widgets/action_button.dart';
import '../widget/add_fav_dialog.dart';
import '../widget/dashboard_card_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/training_limit_dialog.dart';
import 'favourite_training_list_view.dart';
import 'focus_view.dart';
import 'type-level-range_list_view.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardWithInitialState>(
        listener: (context, state) async {
          if (state.canStartFavTraining) {
            BlocProvider.of<DashboardBloc>(context).add(FetchTrainingDetails());
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardWithInitialState>(
          bloc: BlocProvider.of<DashboardBloc>(context)
            ..add(FetchTrainingDetails()),
          builder: (context, state) {
            // debugPrint("state visibility is ${state.isRangeFocusVisible}");
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.dashboard_appBar_title,
                isLeading: false,
                actions: [
                  actionButtonIcon(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                            builder: (_) => const FavouriteTrainingListView());
                      },
                      svgPath: Assets.icSave,
                      color: AppColor.colorWhite),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(right: screenHPadding),
                    child: actionButtonIcon(
                        onPressed: () {
                          state.textEditingController.clear();
                          showDialog(

                            context: context,
                           barrierDismissible: true,
                            builder: (context) {
                              return AddFavouriteDialog();
                            },
                          );
                        },
                        svgPath: Assets.icPlus,
                        color: AppColor.colorPrimary),
                  ),
                ],
              ),
              body: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(screenHPadding,
                                screenVPadding, screenHPadding, 0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          "${AppLocalizations.of(context)!.dashboard_title_partOne} ",
                                      style: Style.headerStyle()),
                                  TextSpan(
                                    text:
                                        "${AppLocalizations.of(context)!.dashboard_title_partTwo}  ",
                                    style: Style.headerStyle(
                                        colorBG: AppColor.colorPrimaryBG),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(height: 4.h),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenHPadding,
                                vertical: widgetBottomPadding),
                            child: Column(
                              children: [
                                Container(
                                  decoration: Style.containerShadowDecoration(
                                      radius: containerRadius),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: cardHorizontalPadding),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: cardVerticalPadding),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .dashboard_slider_title,
                                            style: Style.descTextStyle(),
                                          ),
                                        ),
                                        SizedBox(height: widgetBottomPadding),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ImageView(
                                                  imagePath: Assets.icAlarm,
                                                  width: 17.w,
                                                  fit: BoxFit.contain,
                                                  height:  18.h),
                                              SizedBox(width: 8.w),
                                              Text(
                                                '${formatDuration(state.minute)} ${AppLocalizations.of(context)!.dashboard_slider_minute_txt}',
                                                style:
                                                    Style.descTextBoldStyle(),
                                              )
                                            ]),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: widgetBottomPadding),
                                          child: sliderTheme(
                                            context: context,
                                            isForDuration: true,
                                            slider: Slider(
                                              value: state.minute,
                                              min: TrainingConstants.minSeconds,
                                              max: TrainingConstants.maxSeconds,
                                              activeColor:
                                                  AppColor.colorPrimary,
                                              onChanged: (double value) {
                                                BlocProvider.of<DashboardBloc>(
                                                        context)
                                                    .add(TriggerSliderUpdate(
                                                        seconds: value));
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 28.h,
                                      bottom: menuCardVerticalPadding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                                              builder: (_) =>
                                                  const TrainingTypeLevelRangeView(
                                                      selectedMode: AppStrings
                                                          .training_trainingType));
                                        },
                                        child: DashboardItemCardView(
                                          iconData: Assets.icQuestionMark,
                                          title: AppLocalizations.of(context)!
                                              .newTraining_trainingType,
                                          subTitle: state.selectedTypeDisplay,
                                        ),
                                      )),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),

                                                builder: (_) =>
                                                    const TrainingTypeLevelRangeView(
                                                        selectedMode: AppStrings
                                                            .training_trainingLevel));
                                          },
                                          child: DashboardItemCardView(
                                            iconData: Assets.icStar,
                                            title: AppLocalizations.of(context)!
                                                .newTraining_trainingLevel,
                                            subTitle:
                                                state.selectedLevelDisplay,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: state.isRangeFocusVisible,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),

                                                builder: (_) =>
                                                    const TrainingTypeLevelRangeView(
                                                        selectedMode: AppStrings
                                                            .training_trainingRange));
                                          },
                                          child: DashboardItemCardView(
                                            iconData: Assets.icEar,
                                            title: AppLocalizations.of(context)!
                                                .newTraining_trainingRange,
                                            subTitle:
                                                state.selectedRangeDisplay,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),

                                                builder: (_) =>
                                                    const TrainingFocusView());
                                          },
                                          child: DashboardItemCardView(
                                            iconData: Assets.icCircleRing,
                                            title: AppLocalizations.of(context)!
                                                .newTraining_trainingFocus,
                                            subTitle:
                                                state.selectedFocusDisplay,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        state.isRefresh
                            ? const Center(child: CircularIndicator())
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenHPadding,
                                    vertical: widgetBottomPadding),
                                child: CustomButton(
                                  height:  32.h,
                                    // variant: state.leftFreeTraining <
                                    //         state.trainingCount
                                    //     ? ButtonVariant.btnPrimary
                                    //     : state.hasSubscription ? ButtonVariant.btnPrimary : ButtonVariant.btnDisable,
                                    variant: state.hasSubscription
                                        ? ButtonVariant.btnPrimary
                                        : state.leftFreeTraining <
                                                state.trainingCount
                                            ? ButtonVariant.btnPrimary
                                            : ButtonVariant.btnDisable,
                                    buttonSize: ButtonSize.large,
                                    text:
                                        '${AppLocalizations.of(context)!.newTraining_startBtn} ${state.hasSubscription ? '' : '(${state.leftFreeTraining}/${state.trainingCount})'}',
                                    onTap: () async {
                                      Object? flag;
                                      if (state.hasSubscription) {
                                        flag = await Navigator.pushNamed(
                                            context, RouteName.routeTraining);
                                        BlocProvider.of<DashboardBloc>(context)
                                            .add(TriggerResetGoalEvent());
                                      } else {
                                        if (state.leftFreeTraining <
                                            state.trainingCount) {
                                          flag = await Navigator.pushNamed(
                                              context, RouteName.routeTraining);
                                          BlocProvider.of<DashboardBloc>(
                                                  context)
                                              .add(TriggerResetGoalEvent());
                                        } else {
                                          // debugPrint("hekko");
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              return TrainingLimitDialog();
                                            },
                                          );
                                        }
                                      }
                                    }),
                              ),
                        GestureDetector(
                          onTap: () async {
                            if (state.hasSubscription) {
                              await Navigator.pushNamed(
                                  context, RouteName.routeSetWeeklyGoal);
                              BlocProvider.of<DashboardBloc>(context)
                                  .add(TriggerResetGoalEvent());
                            } else {
                              Toast.nullableIconToast(
                                  message: AppLocalizations.of(context)!
                                      .newTraining_changeWeeklyGoal_toast_msg,
                                  isErrorBooleanOrNull: null);
                            }
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: widgetBottomPadding),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .newTraining_change_training_goal,
                              style: Style.descTextStyle(
                                  textDecoration: TextDecoration.underline),
                            ),
                          ),
                        )
                      ],
                    ),
            );
          },
        ));
  }
}
