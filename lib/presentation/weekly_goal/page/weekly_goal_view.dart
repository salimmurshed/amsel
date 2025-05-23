import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:amsel_flutter/presentation/weekly_goal/bloc/weekly_goal_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';

class WeeklyGoalView extends StatefulWidget {
  const WeeklyGoalView({super.key});

  @override
  State<WeeklyGoalView> createState() => _WeeklyGoalViewState();
}

class _WeeklyGoalViewState extends State<WeeklyGoalView> {
  final WeeklyGoalBloc weeklyGoalBloc = instance<WeeklyGoalBloc>();
  int selectedNumber = 13;
  late FixedExtentScrollController scrollController = FixedExtentScrollController();

  @override
  void initState() {
    scrollController = FixedExtentScrollController(initialItem: selectedNumber - 3);

    super.initState();
    // getData();
  }

  getData() async {
      selectedNumber = await RepositoryDependencies.appSettingsData.getTrainingCount();
      scrollController = FixedExtentScrollController(initialItem: selectedNumber - 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!
            .training_goal_appBar_title,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenHPadding, vertical: screenVPadding),
        child: BlocProvider(
          create: (context) => weeklyGoalBloc..add(FetchSubscriptionDetails()),
          child: BlocBuilder<WeeklyGoalBloc, WeeklyGoalWithInitialState>(
            builder: (context, state) {
              // debugPrint("selected goal is ${state.scrollController.initialItem}");
              return state.isLoading ? const Center(child: CircularProgressIndicator()) : Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '${AppLocalizations.of(context)!.training_goal_title_partOne} ',
                            style: Style.subHeaderStyle()),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .training_goal_title_partTwo,
                          style: Style.subHeaderStyle(
                              colorBG: AppColor.colorPrimaryBG),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: widgetBottomPadding),
                  Text(AppLocalizations.of(context)!.training_goal_desc, style: Style.descTextStyle()),
                  SizedBox(height: screenVPadding),
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Text(AppLocalizations.of(context)!.training_goal_label, style: Style.infoTextBoldStyle())),
                  Padding(
                    padding: EdgeInsets.only(top: 14.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width/2.5,
                        decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(iconContainerRadius),
                            border: Border.all(color: AppColor.colorSecondaryText)
                        ),
                        child: CupertinoPicker(
                          backgroundColor: Colors.transparent,
                          itemExtent: 50.0,
                          scrollController: state.scrollController,
                          selectionOverlay: Container(
                            width: double.minPositive,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(iconContainerRadius),
                              // color: Colors.purple.shade50,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                          ),
                          onSelectedItemChanged: (int index) {
                            weeklyGoalBloc.add(TriggerGoalSelection(goal: index + 3));
                          },
                          children: List<Widget>.generate(97, (int index) {
                            return Container(
                              // color: Colors.purple.shade50,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.w),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text((index + 3).toString(),
                                          style: Style.descTextStyle()
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: GestureDetector(
                                            onTap: (){
                                              weeklyGoalBloc.add(TriggerScrollController());
                                            },
                                            child: const ImageView(svgPath: Assets.icUpDown)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    variant: ButtonVariant.btnPrimary,
                    buttonSize: ButtonSize.large,
                    text: AppLocalizations.of(context)!.training_goal_setGoalBtn,
                    onTap: () {
                        weeklyGoalBloc.add(TriggerGoalSelection(
                            goal: state.selectedGoal, isFinal: true));
                    }
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

