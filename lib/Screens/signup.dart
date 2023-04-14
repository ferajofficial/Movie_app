import 'package:movie/utils/import.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ValueNotifier<bool> obsecureTxt = ValueNotifier<bool>(true);

  FocusNode emailFocusnode = FocusNode();
  FocusNode passwordFocusnode = FocusNode();
  FocusNode signupFocusnode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  bool isLoadingGoogle = false;
  bool isLoading = false;
  bool animate = false;
  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  bool isAgree = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // SizeConfig.defaultSize;
    return Scaffold(
      backgroundColor: scBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: animate ? 1 : 0,
            child: Form(
              key: _formKey,
              child: Column(children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: animate ? 1 : 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/signup.png",
                      height: getDeviceHeight(300),
                    ),
                  ),
                ),
                SizedBox(
                  height: getDeviceHeight(10),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: animate ? 1 : 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SignUp",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: kSecondaryColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getDeviceHeight(10),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: animate ? 1 : 0,
                  child: TextFormField(
                    focusNode: emailFocusnode,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.alternate_email,
                      ),
                      labelText: 'Email',
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordFocusnode);
                    },

                    //** EMail validation */

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Email";
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please Enter a Valid Email";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: getDeviceHeight(20),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: animate ? 1 : 0,
                  child: ValueListenableBuilder(
                    valueListenable: obsecureTxt,
                    builder: (context, value, child) {
                      return TextFormField(
                        focusNode: passwordFocusnode,
                        controller: passwordController,
                        obscureText: obsecureTxt.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_person,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              obsecureTxt.value = !obsecureTxt.value;
                            },
                            child: Icon(obsecureTxt.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),

                          // prefix: Text(""),
                          labelText: 'Password',
                          hintText: 'Password',

                          border: const OutlineInputBorder(),
                        ),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(signupFocusnode);
                        },
                        //** password validation */
                        validator: (val) {
                          if (val!.length < 7) {
                            return "Enter a valid password";
                          } else {
                            return null;
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: getDeviceHeight(50),
                ),
                SizedBox(
                  height: getDeviceHeight(50),
                  width: double.infinity,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 2000),
                    opacity: animate ? 1 : 0,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isLoading) return;
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          isLoading = false;
                        });

                        var sharedSc = await SharedPreferences.getInstance();
                        sharedSc.setBool(Splash_ScState.keyLog, true);

                        // ignore: use_build_context_synchronously
                        FirebaseAuthMethods(FirebaseAuth.instance)
                            .signUpWithEmail(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context);

                        if (_formKey.currentState!.validate()) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MovieListScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor),
                      focusNode: signupFocusnode,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Signup",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              )),
                    ),
                  ),
                ),
                SizedBox(
                  height: getDeviceHeight(10),
                ),
                GestureDetector(
                  onTap: () async {
                    if (isLoading) return;
                    setState(() {
                      isLoading = true;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() {
                      isLoading = false;
                    });
                    // ignore: use_build_context_synchronously
                    FirebaseAuthMethods(FirebaseAuth.instance)
                        .signInWithGoogle(context);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MovieListScreen()));
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 2000),
                    opacity: animate ? 1 : 0,
                    child: Container(
                      height: getDeviceHeight(50),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: isLoadingGoogle
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: kSecondaryColor),
                            )
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Image.asset(
                                    "assets/Gicon.png",
                                    height: getDeviceHeight(35),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    " Signin with Google",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getDeviceHeight(15),
                ),
                GestureDetector(
                  onTap: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 2000),
                    opacity: animate ? 1 : 0,
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Already have an account ? ",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: kSecondaryColor),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: kSecondaryColor)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => animate = true);
    await Future.delayed(const Duration(milliseconds: 5000));
  }
}
