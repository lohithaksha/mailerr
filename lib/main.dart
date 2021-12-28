import 'package:flutter/material.dart';
import 'package:mail/api/google_auth_api.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter signup with email verify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar: AppBar(
      title: Text("hello"),
      centerTitle: true,
    ),
    body: Center(child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        textStyle: TextStyle(fontSize: 20),
      ),
      child: Text('Send Email'),
      onPressed: sendEmail,
    ),
    ),
  );
  
  
  //mail
  Future sendEmail() async {
  
    final user =await GoogleAuthApi.signIn();
    if(user==null )return;


    final email = user.email;
    final auth= await user.authentication;
    final token= auth.accessToken;
    print( "Auth:$email");
  
    // Create our email message.
    final smtpServer = gmailSaslXoauth2(email,token);
    final message = Message()
      ..from = Address( email,'lohithaksha') //from
      ..recipients.add('sbtechnologies9@gmail.com') //recipent email //to
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      //..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject =
          'SignUp verification link  : ${DateTime.now()}' //subject of the email
      ..text ='hello';
      //'This is the plain text.\nThis is line 2 of the text part.'
      //..html =
          //"<h3>Thanks for registering with localhost. Please click this link to complete this registation</h3>\n<p> <a href='$verifylink'>Click me to Verify</a></p>"; //body of the email

    try {
      await send(message,smtpServer);
      showSnackBar('sent');
    } on MailerException catch (e) {
      print(e);
    }
  }

  void showSnackBar(String text) {
    final snackBar=SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
  }


}