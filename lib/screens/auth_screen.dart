import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './home_screen.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends HookWidget {
  const AuthScreen({super.key});
  static const routeName = '/authscreen';

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final passwordFocusNode = useFocusNode();

    final deviceSize = MediaQuery.of(context).size;

    var isLogin = useState(true);
    var isAuthenticating = useState(false);
    var viewPassword = useState(false);

    var username = '';
    var password = '';

    void submit() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      formKey.currentState!.save();

      try {
        isAuthenticating.value = true;
        if (isLogin.value) {
          final userCred = await _firebase.signInWithEmailAndPassword(
              email: username, password: password);

          //Navigator.of(context).pushNamed(HomeScreen.routeName);
        } else {
          //   final userCred = await _firebase.createUserWithEmailAndPassword(
          //       email: username, password: password);
        }
      } on FirebaseAuthException catch (error) {
        if (error.code == "email-already-in-use") {
          //...
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? "Authentication failed.")));
        isAuthenticating.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      //appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(
                  top: deviceSize.height * 0.20,
                ),
                height: deviceSize.height * 0.15,
                child: Image.asset(
                  'assets/images/logowhite.png',
                )),
            SizedBox(
              height: deviceSize.height * 0.18,
            ),
            Container(
              height: deviceSize.height * 0.47,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              //child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 35.0, left: 35.0, right: 35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        "Hello, Welcome.",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  labelText: 'School E-mail Address',
                                  enabledBorder: const UnderlineInputBorder()
                                      .copyWith(
                                          borderSide:
                                              const BorderSide(width: 2)),
                                  focusedBorder: const UnderlineInputBorder()
                                      .copyWith(
                                          borderSide: const BorderSide(
                                              width: 2, color: Colors.black))),
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(passwordFocusNode),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return "Please enter a valid email address";
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                username = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () => viewPassword.value =
                                        !viewPassword.value,
                                    icon: viewPassword.value
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off)),
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                                labelText: 'Password',
                                enabledBorder: const UnderlineInputBorder()
                                    .copyWith(
                                        borderSide: const BorderSide(width: 2)),
                                focusedBorder: const UnderlineInputBorder()
                                    .copyWith(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.black)),
                              ),
                              focusNode: passwordFocusNode,
                              obscureText: viewPassword.value ? false : true,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                password = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            isAuthenticating.value
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : ElevatedButton(
                                    onPressed: submit,
                                    child: Text(
                                      isLogin.value ? 'Log In' : "Sign Up",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () => isLogin.value = !isLogin.value,
                              child: const Text(
                                // isLogin.value
                                //     ? 'Create an account.'
                                //     : "I already have an account",
                                "Be sure to use your school staff details!",
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              //),
            )
          ],
        ),
        //   ),
        // ]),
        // ),
      ),
    );
  }
}
