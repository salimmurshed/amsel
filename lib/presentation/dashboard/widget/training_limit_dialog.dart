import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../imports/common.dart';
import '../bloc/dashboard_bloc.dart';

class TrainingLimitDialog extends StatelessWidget {
  TrainingLimitDialog({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc,
        DashboardWithInitialState>(
        builder: (context, state) {
          return Dialog(
            backgroundColor: AppColor.colorLightGrey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenHPadding,
                  vertical: screenVPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.training_limit_dialog_title,
                        textAlign: TextAlign.center,
                        style: Style.headerStyle()),
                    SizedBox(height: 12.h),
                    Text(
                        AppLocalizations.of(context)!
                            .training_limit_dialog_desc,
                        style: Style.descTextStyle(height: 1.h)),
                    SizedBox(height: widgetBottomPadding),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              // color: Colors.purple,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                    AppLocalizations.of(
                                        context)!
                                        .training_addToFav_dialog_cancelBtn,
                                    textAlign: TextAlign.center,
                                    style: Style.buttonLabel(
                                        color: AppColor
                                            .colorTextLightBG)),
                              ),
                            )),
                        Expanded(
                          child: CustomButton(
                              variant: ButtonVariant
                                  .btnPrimary,
                              buttonSize:
                              ButtonSize.medium,
                              text: AppLocalizations.of(
                                  context)!
                                  .training_limit_btn,
                              onTap: () {
                                  Navigator.popAndPushNamed(context, RouteName.routeSubscription);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
