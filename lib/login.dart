import 'package:flutter/material.dart';

void main() {
}


class dis extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
                    child: ListView(
                      children: [
                        SizedBox(height: 150),
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

                        SizedBox(height: 30),

                        Material(
                          elevation: 5.0,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffF8F4E1),
                          child:
                          TextFormField(
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
                              onPressed: () { },
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
                                  'Sign Up',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 15,),

                        Text("Don't have an account?",
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
                                    builder: (context) => dis(
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
              ),
          ),
        )
    );
  }
}