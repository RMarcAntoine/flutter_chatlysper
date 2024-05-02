import 'package:chatlysper_app/services/auth/authserv.dart';
import 'package:chatlysper_app/composants/mybutton.dart';
import 'package:chatlysper_app/composants/mytext.dart';
import 'package:chatlysper_app/screens/homescreen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final TextEditingController _comfmdpController = TextEditingController();

  final void Function()? onTap;

  RegisterScreen({super.key, required this.onTap});

  void register(BuildContext context) async {
    final auth = AuthServ();

    if (_mdpController.text == _comfmdpController.text) {
      try {
        await auth.signUpWithEmailPassword(
          _emailController.text,
          _mdpController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Les mots de passe ne correspondent pas!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(
                'assets/transparentlogo.png',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              "Créer votre compte",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            MyText(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
              focusNode: null,
            ),
            const SizedBox(height: 10),
            MyText(
              hintText: "Mot de passe",
              obscureText: true,
              controller: _mdpController,
              focusNode: null,
            ),
            const SizedBox(height: 10),
            MyText(
              hintText: "Comfirmer mot de passe",
              obscureText: true,
              controller: _comfmdpController,
              focusNode: null,
            ),
            const SizedBox(height: 25),
            Mybutton(
              text: "Inscription",
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Vous avez déja un compte ? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Se connecter ici",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
