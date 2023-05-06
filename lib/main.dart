import 'dart:math';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'web_view.dart';
import 'package:path_provider/path_provider.dart';
import 'quiz_data.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );




  final documentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentDirectory.path);

  var box = await Hive.openBox('linkStorage');
  var link = await box.get('link');
  if(link.toString()=='null') //проверяем есть ли ссылка на устройстве
    {

      //пытаемся загрузить ссылку и записать её в сторадж
      //runApp(WebView(link));
//здесь будет проверка условий
      runApp(MaterialApp(home: SportHome()));//если не принимаются условия открываем заглушку
    }
  else
    {
      //открываем вебвью
      runApp(WebView(link));
    }



  //await box.put('dave', person);




}

class WebView extends StatelessWidget {
  final String link;

  WebView(this.link);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InfoPong(bloc: '',));
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
  initState() {
    loadQuiz();
    super.initState();
  }

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
    print(reponce);
    print(reference);
    if(reponce == reference)
      {
        points  = points + 10;
      }
    if(checkQuiz>quizRandomF.length-2)
      {
        print(checkQuiz);
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
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.greenAccent, width: 5)),
            child: InkWell(
              child: Text(quizRandomF[checkQuiz]['question'], style: TextStyle(fontWeight: FontWeight.bold, ),),
            ),
          ),

          // Container(
          //   margin: const EdgeInsets.all(10.0),
          //   child: Text(quizRandomF[checkQuiz]['question'], style: TextStyle(fontWeight: FontWeight.bold, ),),
          // )
           Image(image: AssetImage("assets/"+quizRandomF[checkQuiz]['image'])),

          Container(
              margin: const EdgeInsets.all(10.0),
              child:SizedBox(
                width: double.infinity,
                height: 25.0,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
                  onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][0], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
                  child: Text(quizRandomF[checkQuiz]['responses'][0], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
                ),
              ),
          ),
          Container(
              margin: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 25.0,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
                  onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][1], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
                  child: Text(quizRandomF[checkQuiz]['responses'][1], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
                ),
              ),
          ),
        Container(
          margin: const EdgeInsets.all(10.0),
          child:SizedBox(
            width: double.infinity,
            height: 25.0,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
              onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][2], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
              child: Text(quizRandomF[checkQuiz]['responses'][2], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
            ),
          ),
        ),


        Container(
          margin: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 25.0,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
              onPressed: () {responseAccept(quizRandomF[checkQuiz]['responses'][3], quizRandomF[checkQuiz]['image'].substring(0, quizRandomF[checkQuiz]['image'].length-4));},
              child: Text(quizRandomF[checkQuiz]['responses'][3], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),),
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
            Icon(Icons.accessibility_new_sharp),
            Text(
            text,
          ),],) ,
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SportHome()));
              },
              child: Text("I'll take the quiz again!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black ),), ),


          ],
        );
      }
  );
}







}








