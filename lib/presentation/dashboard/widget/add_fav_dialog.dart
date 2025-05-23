import 'package:amsel_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../imports/common.dart';
import '../bloc/dashboard_bloc.dart';

class AddFavouriteDialog extends StatelessWidget {
  AddFavouriteDialog({super.key});

 // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardWithInitialState>(
        builder: (context, state) {
          return Dialog(
            backgroundColor: AppColor.colorLightGrey,
            child: Padding(

              padding: EdgeInsets.symmetric(
                  horizontal: screenHPadding, vertical: screenVPadding),
              child: SingleChildScrollView(
                child: Form(
                  key: state.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          AppLocalizations.of(context)!
                              .training_addToFav_dialog_title,
                          textAlign: TextAlign.center,
                          style: Style.headerStyle()),
                      SizedBox(height: 12.h),
                      Text(
                          AppLocalizations.of(context)!
                              .training_addToFav_dialog_desc,
                          style: Style.descTextStyle(height: 1.h)),
                      SizedBox(height: widgetBottomPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .training_addToFav_dialog_textField_label,
                              style: Style.infoTextBoldStyle()),
                          SizedBox(height: 12.h),
                          Text("${state.textLength}/50",
                              style: Style.infoTextBoldStyle(
                                  color: AppColor.colorSecondaryText)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        controller: state.textEditingController,
                        variant: TextFieldVariant.fav,

                        hintText: AppLocalizations.of(context)!
                            .training_addToFav_dialog_textField_hint,

                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .training_addToFav_dialog_textField_error;
                          }
                          else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          BlocProvider.of<DashboardBloc>(context).add(
                              TriggerControllerOnChangedEvent(
                                  textEditingController:
                                  TextEditingController(text: value)));
                        },
                      ),
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
                                      AppLocalizations.of(context)!
                                          .training_addToFav_dialog_cancelBtn,
                                      textAlign: TextAlign.center,
                                      style: Style.buttonLabel(
                                          color: AppColor.colorTextLightBG)),
                                ),
                              )),
                          Expanded(
                            child: CustomButton(
                                variant: ButtonVariant.btnPrimary,
                                height: 32.h,
                                text: AppLocalizations.of(context)!
                                    .training_addToFav_dialog_saveBtn,
                                onTap: () {
                                  if (state.formKey.currentState!.validate()) {
                                    BlocProvider.of<DashboardBloc>(context)
                                        .add(
                                        TriggerAddToFavouriteTrainingEvent());
                                    Navigator.pop(context);
                                  }
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
