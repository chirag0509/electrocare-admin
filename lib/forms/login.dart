import 'package:flutter/material.dart';
import '../repository/authentication/auth.dart';
import '../repository/controller/colorController.dart';
import '../repository/controller/formController.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPsk = false;

  final fi = FormController.instance;
  final _formKey = GlobalKey<FormState>();

  final color = ColorController.instance;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      backgroundColor: color.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: color.black,
                size: w * 0.08,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: color.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: fi.email,
                    style: TextStyle(fontSize: w * 0.045),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.perm_identity),
                        labelText: "ID",
                        hintText: "Enter your ID",
                        labelStyle: TextStyle(fontSize: w * 0.045),
                        hintStyle: TextStyle(fontSize: w * 0.045),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: fi.password,
                    style: TextStyle(fontSize: w * 0.045),
                    obscureText: !showPsk,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_open_outlined),
                        suffixIcon: showPsk
                            ? IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    showPsk = !showPsk;
                                  });
                                },
                                icon: Icon(Icons.visibility_off_outlined))
                            : IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    showPsk = !showPsk;
                                  });
                                },
                                icon: Icon(Icons.visibility_outlined)),
                        labelText: "Password",
                        hintText: "Enter a strong password",
                        labelStyle: TextStyle(fontSize: w * 0.045),
                        hintStyle: TextStyle(fontSize: w * 0.045),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await Auth.instance.signInWithEmailAndPassword(
                            fi.email.text, fi.password.text, context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: color.black,
                        borderRadius: BorderRadius.circular(w * 1),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: color.white,
                              fontSize: w * 0.06,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
