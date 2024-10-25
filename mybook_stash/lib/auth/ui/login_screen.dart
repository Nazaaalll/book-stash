import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/utlis/toast.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Padding(padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Login' , style: TextStyle(fontWeight: FontWeight.w800,fontSize: 30),),
          const SizedBox(height: 10,),
          TextFormField(controller: emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Email"),
            hintText: "Enter your email ",

          ),
          ),
          const SizedBox(height: 10,),
           TextFormField(controller: passwordController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Password"),
            hintText: "Enter your password ",),
            ),
            const SizedBox(height: 10,),
            SizedBox(width: double.infinity,height: 40,
            child:  OutlinedButton(onPressed: ()async{
              await AuthServiceHelper.loginWithEmail(emailController.text, passwordController.text).then((value){
                if(value == "Login succesful"){
                  Message.show(message:"Logged...in..." );
                  Navigator.pushReplacementNamed(context, "/home"); 
                }else{
                  Message.show(message: "Error: $value");
                }

              });

            }, child: const Text('Login')),),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Need an account?'),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, "/SignUp");

                }, child: const Text('Register '))
              ],
            )


        ],
      ),
      ),),
    );
  }
}