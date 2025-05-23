import 'package:amsel_flutter/common/widgets/build_intro_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/functions/text_field_validations.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/row_with_two_text_fields.dart';
import '../../../imports/common.dart';
import '../../../di/di.dart';
import '../../../main.dart';
import '../bloc/contact_us_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final ContactUsBloc _contactUsBloc = instance<ContactUsBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactUsBloc, ContactUsWithInitialState>(
      bloc: _contactUsBloc,
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          Navigator.pop(context);
          Toast.nullableIconToast(
              message: state.isFailure
                  ? AppLocalizations.of(context)!
                      .settings_contactUsView_toast_failureMsg
                  : AppLocalizations.of(context)!
                      .settings_contactUsView_toast_successMsg,
              isErrorBooleanOrNull: state.isFailure ? true : false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
              centerTitle: false,
              title: AppLocalizations.of(context)!
                  .settings_contactUsView_screen_appBar_title,
              onTap: () {
                _contactUsBloc.add(TriggerContactUsPageRefresh());
                Navigator.pop(context);
              }),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Container(),
                const Positioned(
                    bottom: -50,
                    right: 0,
                    child: ImageView(
                      imagePath: Assets.icBottomBG,
                    )),
                Column(
                  children: [

                    Expanded(
                      child: SingleChildScrollView(

                        child: Form(
                          key: _contactUsBloc.formKey,
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildIntroImage(),
                              Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: screenHPadding),
                                child: Column(
                                  children: [
                                    SizedBox(height: widgetBottomPadding),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .settings_contactUsView_screen_title_partOne,
                                        textAlign: TextAlign.center,
                                        style: Style.subHeaderStyle()),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .settings_contactUsView_screen_title_partTwo,
                                        textAlign: TextAlign.center,
                                        style: Style.subHeaderStyle(colorBG: AppColor.colorPrimaryBG)),
                                    // Center(
                                    //   child: RichText(
                                    //     textAlign: TextAlign.center,
                                    //     text: TextSpan(
                                    //       children: [
                                    //         TextSpan(
                                    //             text: AppLocalizations.of(context)!
                                    //                 .settings_contactUsView_screen_title_partOne,
                                    //             style: Style.subHeaderStyle()),
                                    //         TextSpan(
                                    //           text: AppLocalizations.of(context)!
                                    //               .settings_contactUsView_screen_title_partTwo,
                                    //           style: Style.subHeaderStyle(
                                    //               colorBG: AppColor.colorPrimaryBG),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: widgetBottomPadding),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .settings_contactUsView_screen_desc,
                                        style: Style.descTextStyle()),
                                    SizedBox(height: screenVPadding),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: widgetBottomPadding),
                                      child: RowWithTwoTextFields(
                                        isLeftFieldHasError: state.isFirstNameInvalid,
                                        leftFieldFocusNode: state.firsNameFocusNode,
                                        leftLabel: AppLocalizations.of(context)!
                                            .textfield_addFirstName_label_text,
                                        leftTextFieldEditController:
                                            state.firstNameController,
                                        leftTextFieldHintText:
                                            AppLocalizations.of(context)!
                                                .textfield_addFirstName_hint_text,
                                        leftTextFieldVariant: TextFieldVariant.name,
                                        leftTextFieldValidator: (value) {
                                          _contactUsBloc.add(
                                              TriggerContactUsFirstNameCheck(
                                                  firstName: state
                                                      .firstNameController.text));
                                          return validateFirstName(value!);
                                        },
                                        isRightTextFieldHasError:
                                            state.isLastNameInvalid,
                                        rightTextFieldFocusNode:
                                            state.lastNameFocusNode,
                                        rightTextFieldEditController:
                                            state.lastNameController,
                                        rightLabel: AppLocalizations.of(context)!
                                            .textfield_addLastName_label_text,
                                        rightTextFieldHintText:
                                            AppLocalizations.of(context)!
                                                .textfield_addLastName_hint_text,
                                        rightTextFieldVariant: TextFieldVariant.name,
                                        rightTextFieldValidator: (value) {
                                          _contactUsBloc.add(
                                              TriggerContactUsLastNameCheck(
                                                  lastName:
                                                      state.lastNameController.text));
                                          return validateLastName(value!);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: widgetBottomPadding),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: CustomTextField(
                                              focusNode: state.emailFocusNode,
                                              controller: state.emailController,
                                              label: AppLocalizations.of(context)!
                                                  .textfield_addEmail_label_text,
                                              hintText: AppLocalizations.of(context)!
                                                  .textfield_addEmail_hint_text,
                                              variant: TextFieldVariant.email,
                                              validator: (value) {
                                                _contactUsBloc.add(
                                                    TriggerContactUsEmailCheck(
                                                        email: state
                                                            .emailController.text));
                                                return validateEmail(value!);
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            flex: 1,
                                            child: CustomTextField(
                                              label: AppLocalizations.of(context)!
                                                  .textfield_addCompany_label_text,
                                              focusNode: state.companyFocusNode,
                                              controller: state.companyController,
                                              hintText: AppLocalizations.of(context)!
                                                  .textfield_addCompany_hint_text,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //       bottom: widgetBottomPadding),
                                    //   child: CustomTextField(
                                    //     focusNode: state.emailFocusNode,
                                    //     controller: state.emailController,
                                    //     label: AppLocalizations.of(context)!
                                    //         .textfield_addEmail_label_text,
                                    //     hintText: AppLocalizations.of(context)!
                                    //         .textfield_addEmail_hint_text,
                                    //     variant: TextFieldVariant.email,
                                    //     validator: (value) {
                                    //       _contactUsBloc.add(
                                    //           TriggerContactUsEmailCheck(
                                    //               email: state.emailController.text));
                                    //       return validateEmail(value!);
                                    //     },
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //       bottom: widgetBottomPadding),
                                    //   child: CustomTextField(
                                    //     focusNode: state.companyFocusNode,
                                    //     label: AppLocalizations.of(context)!
                                    //         .textfield_addCompany_label_text,
                                    //     controller: state.companyController,
                                    //     hintText: AppLocalizations.of(context)!
                                    //         .textfield_addCompany_hint_text,
                                    //   ),
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .textfield_addNews_label_text,
                                            style: Style.infoTextBoldStyle()),
                                        Text(
                                            "${state.newsController.text.length}/500",
                                            style: Style.infoTextBoldStyle(
                                                color: AppColor.colorSecondaryText)),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: widgetBottomPadding),
                                      child: CustomTextField(
                                        focusNode: state.newsFocusNode,
                                        controller: state.newsController,
                                        hintText: AppLocalizations.of(context)!
                                            .textfield_addNews_hint_text,
                                        maxLine: 5,
                                        onChanged: (value) {
                                          _contactUsBloc.add(
                                              TriggerCharLengthCheck(news: value));
                                        },
                                        validator: (value) {
                                          _contactUsBloc.add(
                                              TriggerContactUsMessageCheck(
                                                  message:
                                                      state.newsController.text));
                                          return validateNews(value!);
                                        },
                                      ),
                                    ),
                                    CustomButton(
                                      height: 32.h,
                                      onTap: () {
                                        _contactUsBloc.add(
                                          TriggerContactUsFormValidationCheck(
                                            firstName: state.firstNameController.text,
                                            lastName: state.lastNameController.text,
                                            email: state.emailController.text,
                                            news: state.newsController.text,
                                            company: state.companyController.text,
                                            isFirstNameValid:
                                                state.isFirstNameInvalid,
                                            isLastNameValid: state.isLastNameInvalid,
                                            isEmailValid: state.isEmailInvalid,
                                            isNewsValid: state.isNewsInvalid,
                                          ),
                                        );
                                      },
                                      text: AppLocalizations.of(context)!
                                          .settings_contactUsView_sendMsgBtn,
                                      variant: ButtonVariant.btnPrimary,
                                      buttonSize: ButtonSize.large,
                                    ),
                                    SizedBox(height: screenVPadding),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
