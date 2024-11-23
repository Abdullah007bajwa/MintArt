import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../core/widgets/progress_indicaror.dart';
import '../../../core/widgets/sign_in_with_google_text.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../helpers/extensions.dart';
import '../../../helpers/rive_controller.dart';
import '../../../logic/cubit/auth_cubit.dart';
import '../../../routing/routes.dart';
import '../../../theming/colors.dart';
import '../../../theming/styles.dart';
import 'widgets/do_not_have_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RiveAnimationControllerHelper riveHelper =
      RiveAnimationControllerHelper();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected ? _loginPage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.mainBlue,
          ),
        ),
      ),
    );
  }

  SafeArea _loginPage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            return SingleChildScrollView(
              child: Column(
                children: [
                  if (!isWideScreen)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to MintArt!',
                          style: TextStyles.font24Blue700Weight.copyWith(
                            fontSize: 39.sp,
                          ),
                        ),
                        Gap(10.h),
                        Text(
                          'Login to continue exploring amazing art!',
                          style: TextStyles.font14Grey400Weight.copyWith(
                            fontSize: 29.sp,
                          ),
                        ),
                        Gap(1.h),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isWideScreen) 
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome to MintArt!',
                                  style:
                                      TextStyles.font24Blue700Weight.copyWith(
                                    fontSize: 23.sp,
                                  ),
                                ),
                                Gap(10.h),
                                Text(
                                  'Login to continue exploring amazing art!',
                                  style:
                                      TextStyles.font14Grey400Weight.copyWith(
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Flexible(
                        child: Padding(
                          padding: isWideScreen
                              ? EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 15.h)
                              : EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(isWideScreen)
                                Text(
                                  'Login',
                                  style: TextStyles.font24Blue700Weight.copyWith(
                                    fontSize: isWideScreen ? 20.sp : 26.sp,
                                  ),
                              ),
                              Gap(1.h),
                              EmailAndPassword(),
                              Gap(10.h),
                              const SigninWithGoogleText(),
                              Gap(10.h),
                              InkWell(
                                radius: 45.r,
                                onTap: () {
                                  context.read<AuthCubit>().signInWithGoogle();
                                },
                                child: SvgPicture.asset(
                                  'assets/svgs/google_logo.svg',
                                  width: 35.w,
                                  height: 35.h,
                                ),
                              ),
                              const TermsAndConditionsText(),
                              Gap(10.h),
                              const DoNotHaveAccountText(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
