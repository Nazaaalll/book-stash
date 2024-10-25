import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/utlis/toast.dart';
import 'package:flutter/material.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {

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
          const Text('SignUp' , style: TextStyle(fontWeight: FontWeight.w800,fontSize: 30),),
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
              AuthServiceHelper.createAccountWithEmail(emailController.text, passwordController.text).then((value){
                if (value == "Account Created"){
                  Message.show(message: "Account Created");
                  Navigator.pushNamedAndRemoveUntil(context, "/home", (root)=>false);
                }
                else{
                  Message.show(message: "Error : $value");
                }

              });

            }, child: const Text('Sign Up')),),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('already have an account?'),
                TextButton(onPressed: (){
                  Navigator.pop(context);

                }, child: const Text('Login'))
              ],
            )


        ],
      ),
      ),),
    );
  }
  
}