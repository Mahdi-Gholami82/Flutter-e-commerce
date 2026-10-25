import 'package:digi_meh/core/presentation/widgets/custom_animated_borrom_insets.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:digi_meh/features/auth/presentation/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static const String route = "sign_up";
  const SignUpPage({super.key, bool? checkOutWhenDone})
    : checkOutWhenDone = checkOutWhenDone ?? false;
  final bool checkOutWhenDone;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String userNameText = "";
  String passwordText = "";
  String emailText = "";
  String phoneText = "";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final defaultBorderRadius = BorderRadius.circular(10);
    return Form(
      child: BlocConsumer<AuthBloc, AuthStatus>(
        listener: (context, state) {
          switch (state) {
            case AuthStatusSignUpSuccess _:
              {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Sign up success")));
                Navigator.of(context).pop();
              }

            case AuthStatusFailedSignUp failed:
              {
                var colorScheme = Theme.of(context).colorScheme;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Sign up failed",
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                    backgroundColor: colorScheme.errorContainer,
                  ),
                );
                debugPrint(failed.message.toString());
              }
            default:
          }
        },
        builder: (context, state) {
          bool loading = state is AuthStatusInProgressSignUp;
          return Theme(
            data: theme.copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(borderRadius: defaultBorderRadius),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(),
              body: CustomAnimatedBottomInsets(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          child: Icon(
                            Icons.account_circle_sharp,
                            size: 150,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Flexible(child: FittedBox(child: SizedBox(height: 24))),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text("Create an account to start shopping."),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          spacing: 20,
                          children: [
                            TextFormField(
                              onFieldSubmitted: (_) => submit(context),
                              decoration: InputDecoration(
                                hintText: "username",
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              onChanged: (value) {
                                userNameText = value.trim();
                              },
                              validator: (value) => basicNoSpaceValidator(
                                value,
                                fieldName: "username",
                              ),
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) => submit(context),
                              decoration: InputDecoration(
                                hintText: "password",
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              onChanged: (value) {
                                passwordText = value.trim();
                              },
                              validator: (value) => basicNoSpaceValidator(
                                value,
                                fieldName: "password",
                              ),
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) => submit(context),
                              decoration: InputDecoration(
                                hintText: "email",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              onChanged: (value) {
                                emailText = value.trim();
                              },
                              validator: (value) {
                                value = value?.trim() ?? "";
                                if (value.isEmpty) {
                                  return "Email cannot be empty";
                                } else if (!RegExp(
                                  r"^[\w\+\-]+@\w{2,20}\.\w{2,5}$",
                                ).hasMatch(value)) {
                                  return "Invalid email format";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) => submit(context),
                              decoration: InputDecoration(
                                hintText: "phone",
                                prefixIcon: Icon(Icons.phone),
                              ),
                              onChanged: (value) {
                                phoneText = value.trim();
                              },
                              validator: (value) {
                                value = value?.trim() ?? "";
                                if (value.isEmpty) {
                                  return "Email cannot be empty";
                                } else if (!RegExp(
                                  r"^(\+\d{1,2})?\d{10}",
                                ).hasMatch(
                                  value.replaceAll(RegExp(r"\s"), ""),
                                )) {
                                  return "Invalid email format";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 43,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: defaultBorderRadius,
                            ),
                            elevation: 3,
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            textStyle: TextStyle(fontWeight: .w700),
                          ),
                          onPressed: loading
                              ? null
                              : () {
                                  submit(context);
                                },
                          child: loading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(),
                                )
                              : Text("Sign Up"),
                        ),
                      ),
                      Flexible(child: FittedBox(child: SizedBox(height: 150))),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void submit(BuildContext context) {
    if (Form.of(context).validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        AuthEventDoSignUp(
          userName: userNameText,
          password: passwordText,
          email: emailText,
          phone: phoneText,
        ),
      );
    }
  }
}
