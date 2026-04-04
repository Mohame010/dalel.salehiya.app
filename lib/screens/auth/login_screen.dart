import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  /// 🔐 LOGIN FUNCTION
  void login() async {
    if (!formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    bool success = await auth.login(
      phoneController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      Helpers.showSnackBar(context, "تم تسجيل الدخول ✅");

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Helpers.showSnackBar(context, "فشل تسجيل الدخول ❌");
    }
  }

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔥 HEADER
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF03819B),
                    Color(0xFFDC0C49),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(Icons.location_city,
                      size: 50, color: Colors.white),

                  SizedBox(height: 10),

                  Text(
                    "دليل الصالحية",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "سجل دخولك واستكشف",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// 🔐 FORM
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [

                    /// 📱 PHONE
                    TextFormField(
                      controller: phoneController,
                      validator: (v) => Validators.phone(v!),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "رقم الهاتف",
                        prefixIcon: Icon(Icons.phone),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    /// 🔒 PASSWORD
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (v) => Validators.password(v!),
                      decoration: InputDecoration(
                        hintText: "كلمة المرور",
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    /// 🔥 LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: auth.loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF03819B),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: auth.loading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "تسجيل الدخول",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    SizedBox(height: 15),

                    /// 🔗 REGISTER
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.register);
                      },
                      child: Text("إنشاء حساب جديد"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}