import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/already_have_account_text.dart';
import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../../core/widgets/progress_indicaror.dart';
import '../../../core/widgets/sign_in_with_google_text.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../helpers/extensions.dart';
import '../../../helpers/rive_controller.dart';
import '../../../logic/cubit/auth_cubit.dart';
import '../../../routing/routes.dart';
import '../../../theming/styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final RiveAnimationControllerHelper riveHelper =
      RiveAnimationControllerHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 600;

              return Row(
                children: [
                  if (isWideScreen)
                    Expanded(
                      flex: 2, 
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/signup_illustration.svg',
                                width: constraints.maxWidth * 0.4,
                              ),
                              Gap(20.h),
                              Text(
                                'Join Us at MintArt!',
                                style: TextStyles.font24Blue700Weight.copyWith(
                                  fontSize: 22.sp,
                                ),
                              ),
                              Gap(8.h),
                              Text(
                                'Sign up and start exploring unique art collections!',
                                style: TextStyles.font14Grey400Weight.copyWith(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                  Expanded(
                    flex: 2, 
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isWideScreen) ...[
                              Text(
                                'Create Account',
                                style: TextStyles.font24Blue700Weight.copyWith(
                                  fontSize: 28.sp,
                                ),
                              ),
                              Gap(8.h),
                              Text(
                                'Sign up and start exploring unique art collections!',
                                style: TextStyles.font14Grey400Weight.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                            Gap(8.h),
                            BlocConsumer<AuthCubit, AuthState>(
                              buildWhen: (previous, current) =>
                                  previous != current,
                              listenWhen: (previous, current) =>
                                  previous != current,
                              listener: (context, state) async {
                                if (state is AuthLoading) {
                                  ProgressIndicaror.showProgressIndicator(
                                      context);
                                } else if (state is AuthError) {
                                  riveHelper.addFailController();
                                  context.pop();
                                  context.pop();
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: state.message,
                                  ).show();
                                } else if (state is UserSignIn) {
                                  riveHelper.addSuccessController();
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  riveHelper.dispose();
                                  if (!context.mounted) return;
                                  context.pushNamedAndRemoveUntil(
                                    Routes.homeScreen,
                                    predicate: (route) => false,
                                  );
                                } else if (state is IsNewUser) {
                                  context.pushNamedAndRemoveUntil(
                                    Routes.createPassword,
                                    predicate: (route) => false,
                                    arguments: [
                                      state.googleUser,
                                      state.credential
                                    ],
                                  );
                                } else if (state is UserSingupButNotVerified) {
                                  context.pop();
                                  riveHelper.addSuccessController();
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Sign up Success',
                                    desc:
                                        'Don\'t forget to verify your email check inbox.',
                                  ).show();
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  riveHelper.removeAllControllers();
                                  if (!context.mounted) return;
                                  context.pushNamedAndRemoveUntil(
                                    Routes.loginScreen,
                                    predicate: (route) => false,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    EmailAndPassword(
                                      isSignUpPage: true,
                                    ),
                                    Gap(15.h),
                                    const SigninWithGoogleText(),
                                    Gap(10.h),
                                    InkWell(
                                      onTap: () {
                                        context
                                            .read<AuthCubit>()
                                            .signInWithGoogle();
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svgs/google_logo.svg',
                                        width: 50.w,
                                        height: 50.h,
                                      ),
                                    ),
                                    const TermsAndConditionsText(),
                                    Gap(15.h),
                                    const AlreadyHaveAccountText(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
