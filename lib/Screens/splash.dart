import 'dart:async';

import 'package:movie/Screens/signup.dart';
import 'package:movie/utils/import.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Splash_Sc extends StatefulWidget {
  const Splash_Sc({Key? key}) : super(key: key);

  @override
  State<Splash_Sc> createState() => Splash_ScState();
}

// ignore: camel_case_types
class Splash_ScState extends State<Splash_Sc> {
  static const String keyLog = 'login';
  bool animate = false;
  @override
  void initState() {
    super.initState();
    startAnimation();
    // goTo();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: splashBg,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            top: 100,
            left: animate ? 70 : -80,
            right: 10,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: animate ? 1 : 0,
              child: const Text(
                "Welcome to our app! \nWe hope it brings you joy",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: kSecondaryColor),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            bottom: animate ? 350 : 0,
            left: 90,
            //top: 30,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: animate ? 1 : 0,

              child: Container(
                height: getDeviceHeight(200),
                width: getDeviceWidth(200),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    //color: Colors.amber,
                    image: DecorationImage(
                        image: AssetImage("assets/welcome.jpg"),
                        fit: BoxFit.fill),
                    boxShadow: [
                      BoxShadow(
                        color: kprimarydeep,
                        offset: Offset(4, 4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: kprimarylightColor, // color of the shadow
                        offset: Offset(-4, -4),
                        blurRadius: 15,
                        spreadRadius: 1, // how far the color effect spreads.
                      ),
                    ]),
              ),
              //),
            ),
          ),
        ],
      ),
    );
  }

  // void goTo() async {
  //   var sharedSc = await SharedPreferences.getInstance();
  //   var isLoggedIn = sharedSc.getBool(keyLog);

   
  // }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => animate = true);
    await Future.delayed(const Duration(milliseconds: 5000));
     var sharedSc = await SharedPreferences.getInstance();
      var isLoggedIn = sharedSc.getBool(keyLog);
     if (isLoggedIn != null) {
      if (isLoggedIn) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  MovieListScreen(),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const login(),
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUp(),
        ),
      );
    }
  }
}
