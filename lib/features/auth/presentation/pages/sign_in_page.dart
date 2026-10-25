import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  static const String route = "sign_in";
  const SignInPage({super.key, bool? checkOutWhenDone})
    : checkOutWhenDone = checkOutWhenDone ?? false;
  final bool checkOutWhenDone;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String userNameText = "";
  String passwordText = "";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final defaultBorderRadius = BorderRadius.circular(10);
    print(MediaQuery.viewInsetsOf(context).bottom);

    return Form(
      child: BlocConsumer<AuthBloc, AuthStatus>(
        listener: (context, state) {
          switch (state) {
            case AuthStatusAuthenticated _:
              {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Login success")));
                Navigator.of(context).pop();
              }

            case AuthStatusFailed failed:
              {
                var colorScheme = Theme.of(context).colorScheme;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Login failed",
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
          bool loading = state is AuthStatusInProgress;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(),
            body: AnimatedPadding(
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        child: Icon(
                          Icons.lock_outline_rounded,
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
                              widget.checkOutWhenDone
                                  ? "Almost there!"
                                  : "Welcome back",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.checkOutWhenDone
                                  ? "Sign in to continue to checkout."
                                  : "Sign in to access your account.",
                            ),
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
                              border: OutlineInputBorder(
                                borderRadius: defaultBorderRadius,
                              ),
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                            onChanged: (value) {
                              userNameText = value.trim();
                            },
                            validator: (value) {
                              value = value?.trim() ?? "";
                              if (value.isEmpty) {
                                return "Username should not be empty";
                              } else if (!RegExp(r"\w+").hasMatch(value)) {
                                return "Invalid username";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            onFieldSubmitted: (_) => submit(context),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: defaultBorderRadius,
                              ),
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            onChanged: (value) {
                              passwordText = value.trim();
                            },
                            validator: (value) {
                              value = value?.trim() ?? "";
                              if (value.isEmpty) {
                                return "Password should not be empty";
                              } else if (!RegExp(r"\w+").hasMatch(value)) {
                                return "Invalid passowrd";
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
                            : Text("Sign In"),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
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
        AuthEventDoAuthenticate(userName: userNameText, password: passwordText),
      );
    }
  }
}
