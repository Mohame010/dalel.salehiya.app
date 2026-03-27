import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void register() async {
    if (!formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    bool success = await auth.register({
      "name": nameController.text,
      "phone": phoneController.text,
      "password": passwordController.text,
    });

    if (success) {
      Helpers.showSnackBar(context, "تم إنشاء الحساب بنجاح");
      Navigator.pop(context);
    } else {
      Helpers.showSnackBar(context, "فشل التسجيل");
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
                    Color(0xFF0D9488),
                    Color(0xFF14B8A6),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(Icons.person_add,
                      size: 50, color: Colors.white),

                  SizedBox(height: 10),

                  Text(
                    "إنشاء حساب",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "ابدأ رحلتك مع التطبيق",
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

                    /// 👤 NAME
                    TextFormField(
                      controller: nameController,
                      validator: (v) => Validators.name(v!),
                      decoration: InputDecoration(
                        hintText: "الاسم",
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

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

                    /// 🔥 BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: auth.loading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0D9488),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: auth.loading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "إنشاء الحساب",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    SizedBox(height: 15),

                    /// 🔙 BACK TO LOGIN
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("لديك حساب؟ تسجيل الدخول"),
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