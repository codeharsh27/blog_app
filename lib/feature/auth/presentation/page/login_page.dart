import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_state.dart';
import 'package:blog_app/feature/auth/presentation/page/signup_page.dart';
import 'package:blog_app/feature/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/feature/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/utils/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is AuthFailure){
              showSnackBar(context, state.message);
            }
          },
        builder: (context, state) {
          if (state is AuthLoading) {
            const Loader();
          }
          return Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign in.",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 40),
                AuthField(hintText: "Email", controller: emailcontroller,),
                const SizedBox(height: 15),
                AuthField(hintText: "Password",
                  controller: passwordcontroller,
                  isObscureText: true,),
                const SizedBox(height: 20),
                AuthGradientButton(buttonName: "Sign in",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                          AuthSignin(email: emailcontroller.text.trim(),
                            password: passwordcontroller.text.trim(),
                          )
                      );
                    }
                  },
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => SignUpPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                        text: "Don't have an Account? ",
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium,
                        children: [
                          TextSpan(
                              text: "Sign up",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                  color: AppPallete.gradient2
                              )
                          )
                        ]

                    ),

                  ),
                )
              ],
            ),
          );
        }
        ),
      ),
    );
  }
}
