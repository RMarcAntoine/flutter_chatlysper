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

  // ignore: use_key_in_widget_constructors
  RegisterScreen({Key? key, required this.onTap});

  void register(BuildContext context) async {
    final auth = AuthServ();

    if (_mdpController.text == _comfmdpController.text) {
      // Vérification de la complexité du mot de passe
      RegExp regex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&/])[A-Za-z\d@$!%*?&]{8,100}$');
      if (!regex.hasMatch(_mdpController.text)) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text(
                "Le mot de passe ne respecte pas les critères de complexité. Plus de 8 caractères, 1 majuscule, 1 minuscule, 1 chiffre et 1 caractère spéciale."),
          ),
        );
        return;
      }

      try {
        await auth.signUpWithEmailPassword(
          _emailController.text,
          _mdpController.text,
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
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
        child: SingleChildScrollView(
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
                hintText: "Confirmer mot de passe",
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
                    "Vous avez déjà un compte ? ",
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
      ),
    );
  }
}
