import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../imports/common.dart';
import '../../../main.dart';

class DashboardDetailsData {
  static List<DashboardMenuModel> typeList = [
    DashboardMenuModel(
        id: 0,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_title_one,
        serverTitle: AppStrings.training_type_serverId_one,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_detail_one,
        icon: Assets.icAtmen
    ),
    DashboardMenuModel(
        id: 1,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_title_two,
        serverTitle: AppStrings.training_type_serverId_two,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_detail_two,
        icon: Assets.icMic
    ),
    DashboardMenuModel(
        id: 2,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_title_three,
        serverTitle: AppStrings.training_type_serverId_three,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_detail_three,
        icon: Assets.icEins
    ),
    DashboardMenuModel(
        id: 3,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_title_four,
        serverTitle: AppStrings.training_type_serverId_four,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_type_detail_four,
        icon: Assets.icStar
    )
  ];

  static List<DashboardMenuModel> levelList = [
    DashboardMenuModel(
        id: 0,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_level_title_one,
        serverTitle: AppStrings.training_level_serverId_one,
        info: '',
        icon: Assets.icStarHalf
    ),
    DashboardMenuModel(
        id: 1,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_level_title_two,
        serverTitle: AppStrings.training_level_serverId_two,
        info: '',
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 2,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_level_title_three,
        serverTitle: AppStrings.training_level_serverId_three,
        info: '',
        icon: Assets.icStarHalfBorder
    ),
    DashboardMenuModel(
        id: 3,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_level_title_four,
        serverTitle: AppStrings.training_level_serverId_four,
        info: '',
        icon: Assets.icStarFill
    )
  ];

  static List<DashboardMenuModel> rangeList = [
    DashboardMenuModel(
        id: 0,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_range_title_one,
        serverTitle: AppStrings.training_range_serverId_one,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_range_detail_one,
        icon: Assets.icDownArrow
    ),
    DashboardMenuModel(
        id: 1,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_range_title_two,
        serverTitle: AppStrings.training_range_serverId_two,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_range_detail_two,
        icon: Assets.icUpArrow
    )
  ];

  static List<DashboardMenuModel> focusList = [
    DashboardMenuModel(
        id: 0,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_zero,
        serverTitle: AppStrings.training_focus_serverId_zero,
        info: "",
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 1,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_one,
        serverTitle: AppStrings.training_focus_serverId_one,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_one,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 2,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_two,
        serverTitle: AppStrings.training_focus_serverId_two,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_two,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 3,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_three,
        serverTitle: AppStrings.training_focus_serverId_three,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_three,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 4,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_four,
        serverTitle: AppStrings.training_focus_serverId_four,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_four,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 5,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_five,
        serverTitle: AppStrings.training_focus_serverId_five,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_five,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 6,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_six,
        serverTitle: AppStrings.training_focus_serverId_six,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_six,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 7,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_seven,
        serverTitle: AppStrings.training_focus_serverId_seven,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_seven,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 8,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_eight,
        serverTitle: AppStrings.training_focus_serverId_eight,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_eight,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 9,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_nine,
        serverTitle: AppStrings.training_focus_serverId_nine,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_nine,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 10,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_ten,
        serverTitle: AppStrings.training_focus_serverId_ten,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_ten,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 11,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_eleven,
        serverTitle: AppStrings.training_focus_serverId_eleven,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_eleven,
        icon: Assets.icStar
    ),
    DashboardMenuModel(
        id: 12,
        title: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_title_twelve,
        serverTitle: AppStrings.training_focus_serverId_twelve,
        info: AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_detail_twelve,
        icon: Assets.icStar
    ),
  ];
}

class DashboardDetailLists{
  final List<DashboardMenuModel> typeList;
  final List<DashboardMenuModel> levelList;
  final List<DashboardMenuModel> rangeList;
  final List<DashboardMenuModel> focusList;
  final bool isRangeFocusVisible;
  final String selectedType;
  final String selectedLevel;
  final String selectedRange;
  final String selectedFocus;

  DashboardDetailLists({required this.typeList, required this.levelList,
    required this.rangeList, required this.focusList,
    required this.isRangeFocusVisible, required this.selectedType,
    required this.selectedLevel, required this.selectedRange,
    required this.selectedFocus
  });
}

class DashboardMenuModel {
  int id;
  String title;
  String serverTitle;
  String info;
  String icon;

  DashboardMenuModel({
    required this.id,
    required this.title,
    required this.serverTitle,
    required this.info,
    required this.icon,
  });
}
