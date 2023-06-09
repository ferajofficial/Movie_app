import 'package:movie/utils/import.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ValueNotifier<bool> obsecureTxt = ValueNotifier<bool>(true);

  FocusNode emailFocusnode = FocusNode();
  FocusNode passwordFocusnode = FocusNode();
  FocusNode loginFocusnode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool animate = false;
  bool isAgree = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: scBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/login.png",
                  height: getDeviceHeight(350),
                ),
              ),
              SizedBox(
                height: getDeviceHeight(10),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "LogIn",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: kSecondaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: getDeviceHeight(10),
              ),
              TextFormField(
                focusNode: emailFocusnode,
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
              SizedBox(
                height: getDeviceHeight(20),
              ),
              TextFormField(
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
                  labelText: 'Password',
                  hintText: 'Password',
                  border: const OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(loginFocusnode);
                },
                //** password validation */
                validator: (val) {
                  if (val!.length < 7) {
                    return "Enter a valid password";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: getDeviceHeight(20),
              ),
              SizedBox(
                height: getDeviceHeight(50),
                width: double.infinity,
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
                    FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
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
                  focusNode: loginFocusnode,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text("Login",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
