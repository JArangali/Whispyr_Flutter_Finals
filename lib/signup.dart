import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'login.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp();
//
//   // Hide the system UI (status bar and navigation bar)
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//
//   runApp(const mainPage());
// }
//
//
// class mainPage extends StatelessWidget {
//   const mainPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: insertForm()
//     );
//   }
// }

class insertForm extends StatefulWidget {
  const insertForm({super.key});

  @override
  State<insertForm> createState() => _insertFormState();
}

class _insertFormState extends State<insertForm> {
  @override
  final _formKey = GlobalKey<FormState>();


  var FirstnameController = TextEditingController();
  var LastnameController = TextEditingController();
  var EmailController = TextEditingController();
  var PennameController = TextEditingController();
  var PasswordController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
              fit: BoxFit.fill,
                image: AssetImage("assets/images/WhispyrBG.png"),
              ),
            ),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [

                    Row(
                      children: [
                        Expanded(child:
                          Container(
                            height:160,
                            child: Image.asset("assets/images/WhispyrLogo.png",
                                fit: BoxFit.contain),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 15),

                    Material(
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffF8F4E1),
                      child:
                      TextFormField(
                        controller: FirstnameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Firstname",
                          labelStyle: TextStyle(
                              color: Color(0xbf614124)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          prefixIconColor: Color(0xbf614124),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Material(
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffF8F4E1),
                      child:
                      TextFormField(
                        controller: LastnameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Lastname",
                          labelStyle: TextStyle(
                              color: Color(0xbf614124)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          prefixIconColor: Color(0xbf614124),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Material(
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffF8F4E1),
                      child:
                      TextFormField(
                        controller: EmailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Color(0xa6614124)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0x1a000000), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0x1a000000), width: 1),
                          ),
                          prefixIcon: Icon(Icons.email_outlined),
                          prefixIconColor: Color(0xbf614124),
                        ),
                      ),
                    ),

                    SizedBox(height: 35),

                    Material(
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffF8F4E1),
                      child:
                      TextFormField(
                        controller: PennameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pen name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Pen Name",
                          labelStyle: TextStyle(
                              color: Color(0xa6614124)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),
                          prefixIcon: Icon(Icons.history_edu),
                          prefixIconColor: Color(0xbf614124),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Material(
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffF8F4E1),
                      child:
                      TextFormField(
                        controller: PasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Color(0xa6614124)
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0x1a000000),
                                width: 1,
                              )
                          ),
                          prefixIcon: Icon(Icons.lock_outline),
                          prefixIconColor: Color(0xbf614124),
                        ),
                      ),
                    ),

                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var firstname = FirstnameController.text;
                              var lastname = LastnameController.text;
                              var email = EmailController.text;
                              var penname = PennameController.text;
                              var password = PasswordController.text;

                              try {
                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                    .collection('whispyr_users')
                                    .where('penname', isEqualTo: penname)
                                    .limit(1)
                                    .get();

                                if (querySnapshot.docs.isNotEmpty) {
                                  var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
                                  print('User found: ${userData['firstname']} ${userData['lastname']}');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Penname already exists, sorry.')),
                                  );
                                } else {
                                  await FirebaseFirestore.instance.collection("whispyr_users").add({
                                    "firstname": firstname,
                                    "lastname": lastname,
                                    "email": email,
                                    "penname": penname,
                                    "password": password,
                                  });

                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Welcome!'),
                                        content: Text('You have registered successfully!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => Login()),
                                              );
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                print('Error fetching user: $e');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xffF8F4E1),
                            backgroundColor: Color(0xff6D8D57),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 15.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15,),

                    Text("Already have an account?",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Color(0xff3F2021),
                      ),
                    ),

                    SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Login(
                                )));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xffF8F4E1),//change background color of button
                            backgroundColor: Color(0xff6D8D57),//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 15.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                            child: Text(
                              'Sign In',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          )
      ),
    );
  }
}