import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../common/widgets/alert_dialog.dart';
import '../../../data/model/local_models/local_trainings.dart';
import '../../../imports/common.dart';
import '../../../main.dart';
import '../../dashboard/widget/row_with_icon.dart';
import '../bloc/statistic_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/training_data.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    final statisticsBloc = BlocProvider.of<StatisticBloc>(context);
    return Scaffold(
      appBar: CustomAppBar(
          isLeading: false,
          title: AppLocalizations.of(context)!
              .btnNavigation_statistic_appbar_title),
      body: BlocListener<StatisticBloc, StatisticInitialState>(
        listener: (context, state) async {
          if (state.canStartTraining) {
            await Navigator.pushNamed(context, RouteName.routeTraining);
            statisticsBloc.add(FetchTrainingListEvent());
          }
        },
        child: BlocBuilder<StatisticBloc, StatisticInitialState>(
            bloc: statisticsBloc..add((FetchTrainingListEvent())),
            builder: (context, state) {
              // debugPrint("state ${state.selectedDate}");
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Flexible(
                        flex:state.trainingList.isEmpty? 2: 1,
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(screenHPadding,
                                  screenVPadding, screenHPadding, 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (state.userHasSubscription) {
                                          await Navigator.pushNamed(context,
                                              RouteName.routeSetWeeklyGoal);
                                          statisticsBloc
                                              .add((FetchTrainingListEvent()));
                                        } else {
                                          Toast.nullableIconToast(
                                              message: AppLocalizations.of(
                                                      context)!
                                                  .newTraining_changeWeeklyGoal_toast_msg,
                                              isErrorBooleanOrNull: null);
                                        }
                                      },
                                      child: headerData(
                                          title: getLocale() ==
                                                  const Locale("de")
                                              ? AppLocalizations.of(context)!
                                                  .statistics_weeklyGoal
                                              : "Weekly\nGoal",
                                          value:
                                              '${state.leftTrainingCount}/${state.trainingCount}',
                                          isFirst: true,
                                          desc: AppLocalizations.of(context)!
                                              .statistics_change_goal),
                                    ),
                                  ),
                                  SizedBox(width: 11.w),
                                  Expanded(
                                      child: headerData(
                                    title:
                                        "${AppLocalizations.of(context)!.statistics_totalTraining_partOne}\n${AppLocalizations.of(context)!.statistics_totalTraining_partTwo}",
                                    value: '${state.totalTraining}',
                                  )),
                                  SizedBox(width: 11.w),
                                  Expanded(
                                      child: headerData(
                                    title: AppLocalizations.of(context)!
                                        .statistics_monthly_training_time,
                                    value:
                                        "${state.monthlyTrainingTime} ${AppStrings.statistic_min}",
                                  ))
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: screenHPadding),
                              child: Container(
                                decoration: Style.containerShadowDecoration(
                                    radius: containerRadius),
                                child: TableCalendar(
                                  rowHeight: 32.h,
                                  daysOfWeekHeight: 50.h,
                                  firstDay: DateTime(1910),
                                  lastDay: DateTime(2090),
                                  focusedDay: state.selectedDate,
                                  onDaySelected: (selectedDay, focusedDay) {
                                    statisticsBloc.add(
                                        FetchSelectedDateTrainingList(
                                            date: selectedDay));
                                  },
                                  selectedDayPredicate: (day) {
                                    return isSameDay(state.selectedDate, day);
                                  },
                                  eventLoader: (DateTime day) {
                                    final eventsMap =
                                        <DateTime, List<LocalTrainings>>{};
                                    for (var training
                                        in state.totalTrainingList) {
                                      final dateKey = DateTime(
                                          training.date.year,
                                          training.date.month,
                                          training.date.day);
                                      if (eventsMap.containsKey(dateKey)) {
                                        eventsMap[dateKey]!.add(training);
                                      } else {
                                        eventsMap[dateKey] = [training];
                                      }
                                    }
                                    final dateKey =
                                        DateTime(day.year, day.month, day.day);
                                    return eventsMap[dateKey] ?? [];
                                  },
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekendStyle: Style.smallStyle(
                                        height: 0,
                                        color: AppColor.colorSecondaryText),
                                    weekdayStyle: Style.smallStyle(
                                        height: 0,
                                        color: AppColor.colorSecondaryText),
                                  ),
                                  availableGestures: AvailableGestures.none,
                                  calendarStyle: CalendarStyle(
                                    cellPadding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    cellMargin: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 5.h),
                                    tablePadding: EdgeInsets.only(bottom: 8.h),
                                    markerMargin: const EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 8),
                                    selectedDecoration: BoxDecoration(
                                        color: AppColor.colorPrimary,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    markerDecoration: BoxDecoration(
                                        color: AppColor.colorPrimary,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    defaultDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    disabledDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    outsideDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    withinRangeDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    holidayDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    todayDecoration: BoxDecoration(
                                        color: AppColor.colorPrimary
                                            .withOpacity(0.5),
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    weekendDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    defaultTextStyle: Style.smallStyle(
                                        color: AppColor.colorSecondary),
                                    todayTextStyle: Style.smallStyle(
                                        color: AppColor.colorWhite),
                                    disabledTextStyle: Style.smallStyle(
                                        color: AppColor.colorDisable),
                                    selectedTextStyle: Style.smallBoldStyle(
                                        color: AppColor.colorWhite),
                                    weekendTextStyle: Style.smallStyle(),
                                    weekNumberTextStyle: Style.smallStyle(),
                                    outsideTextStyle: Style.smallStyle(),
                                  ),
                                  headerStyle: HeaderStyle(
                                      leftChevronIcon: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColor.colorWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 15,
                                                offset: const Offset(0,
                                                    5), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          height: 32.h,
                                          width: 32.w,
                                          child: Icon(
                                              Icons.arrow_back_ios_new_rounded,
                                              size: 20,
                                              color:
                                                  AppColor.colorTextLightBG)),
                                      rightChevronIcon: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColor.colorWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 15,
                                                offset: const Offset(0,
                                                    5), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          height: 32.h,
                                          width: 32.w,
                                          child: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 20,
                                              color:
                                                  AppColor.colorTextLightBG)),
                                      titleTextStyle: Style.subHeaderStyle(),
                                      formatButtonShowsNext: false,
                                      formatButtonVisible: false,
                                      leftChevronPadding: EdgeInsets.zero,
                                      rightChevronPadding: EdgeInsets.zero,
                                      titleCentered: true),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: menuCardVerticalPadding, bottom: 6.h),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                  '${AppLocalizations.of(context)!.statistics_training_on} ',
                                  style: Style.subHeaderStyle()),
                              TextSpan(
                                text:
                                extractDateOnlyFromDateTimeInDotFormat(
                                    state.selectedDate),
                                style: Style.subHeaderStyle(
                                    colorBG: AppColor.colorPrimaryBG),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: state.isLoading
                            ? const Center(child: CircularIndicator())
                            : state.trainingList.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .training_noDataFound_text,
                                      style: Style.subHeaderStyle(),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h,
                                        horizontal: screenHPadding),
                                    itemCount: state.trainingList.length,
                                    itemBuilder: (context, index) {
                                      var data = state.trainingList[index];
                                      // String tTime = convertToMinutes(Duration(seconds: data.totalTrainingTime));
                                      return GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return CustomAlertDialog(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .statistics_training_repeat_title,
                                                  subTitle: AppLocalizations.of(
                                                          context)!
                                                      .statistics_training_repeat_desc,
                                                  btnText: AppLocalizations.of(
                                                          context)!
                                                      .training_repeat_challenge_btn,
                                                  onTapButton: () {
                                                    Navigator.pop(context);
                                                    statisticsBloc.add(
                                                        TriggerRepeatTrainingEvent(
                                                            localTrainings:
                                                                data));
                                                  },
                                                );
                                              });
                                        },
                                        child: Container(
                                          decoration:
                                              Style.containerShadowDecoration(
                                                  radius: containerRadius,
                                                  color: AppColor
                                                      .colorVeryLightGrey),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top:
                                                              containerVerticalPadding,
                                                          left:
                                                              containerHorizontalPadding,
                                                          bottom: 6.h),
                                                      child: Text(
                                                          '${AppLocalizations.of(context)!.statistics_training_time} ${extractTimeOnlyFromDateTime(data.date)}',
                                                          style: Style
                                                              .descTextBoldStyle(
                                                                  height: 1.5)),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ImageView(
                                                          imagePath:
                                                              Assets.icAlarm,
                                                          height: isTablet?20.h:15.h,
                                                          width: 15.w,
                                                          fit: BoxFit.cover,
                                                          color: AppColor
                                                              .colorPrimary),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                          '${convertToMinutes(Duration(seconds: data.totalAttendedTrainingTime))} ${AppStrings.statistic_min}',
                                                          style: Style
                                                              .descTextStyle()),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) {
                                                            return CustomAlertDialog(
                                                              title: AppLocalizations
                                                                      .of(context)!
                                                                  .statistics_delete_training_dialogTitle,
                                                              subTitle: AppLocalizations
                                                                      .of(context)!
                                                                  .statistics_delete_training_dialogDesc,
                                                              btnText: AppLocalizations
                                                                      .of(context)!
                                                                  .statistics_delete_training_dialogDeleteBtn,
                                                              onTapButton: () {
                                                                Navigator.pop(
                                                                    context);
                                                                statisticsBloc.add(
                                                                    TriggerRemoveTrainingEvent(
                                                                        trainingId:
                                                                            data.id));
                                                              },
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      // padding: EdgeInsets
                                                      //     .symmetric(
                                                      //         horizontal:
                                                      //         containerHorizontalPadding),
                                                      padding: EdgeInsets.fromLTRB(
                                                          containerHorizontalPadding,
                                                          5.h,
                                                          containerHorizontalPadding,
                                                          5.h),
                                                      child: ImageView(
                                                        svgPath: Assets.icBin,
                                                        height: isTablet?20.h:null,
                                                        width: isTablet
                                                            ? 15.w
                                                            : null,
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
                                                      '${formatDuration(double.parse(data.duration))} ${AppLocalizations.of(context)!.dashboard_slider_minute_txt}',
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
                                                      text:
                                                          data.focus.toString(),
                                                      imagePath:
                                                          Assets.icCircleRing)),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    containerHorizontalPadding,
                                                    0,
                                                    containerHorizontalPadding,
                                                    containerVerticalPadding),
                                                child: rowWithDoubleIconText(
                                                  leftText:
                                                      data.range.toString(),
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
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                          height: widgetBottomPadding);
                                    },
                                  ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
