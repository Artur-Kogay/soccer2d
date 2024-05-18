import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:soccer2d/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setPortrait();

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFe1e6ee),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildImage(context, 'assets/images/logo.png'),
                      SizedBox(width: 8),
                      _buildImage(context, 'assets/images/logo2.png'),
                      SizedBox(width: 8),
                      _buildImage(context, 'assets/images/logo3.png'),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color(0xFF00C42A), Color(0xFF008312)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'GAMES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                PlayField("Pegula, Jessica vs", "Swiatek I."),
                PlayField("Los Angeles Lakers vs", "Utah Jazz"),
                PlayField("CR Vasco da Gama RJ vs", "Botafogo FR RJ"),
                PlayField("Florida Panthers vs", "Columbus Blue Jackets"),
                PlayField("Toronto Maple Leafs vs", "Tampa Bay Lightning"),
                PlayField("Detroit Pistons vs", "Golden State Warriors"),
                PlayField("Philadelphia 76ers vs", "Washington Wizards"),
                PlayField("Indiana Pacers vs", "San Antonio Spurs"),
                PlayField("Orlando Magic vs", "Dallas Mavericks"),
                PlayField("CA Belgrano vs", "Tigre"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        _showModal(context);
      },
      child: Container(
        height: 120,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Color.fromRGBO(225, 230, 238, 1.0),
                content: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(225, 230, 238, 1.0),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                          ),
                          Container(
                            height: 210,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    'Make 15,000 goals and double your points!',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    'Your points are saved within the game, even if you haven`t logged in for a while',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(225, 230, 238, 1.0),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  height: 40,
                                  width: 160,
                                  child: TextButton(
                                    onPressed: () {
                                      //Navigator.of(context).pop();

                                      Flame.device.setLandscape();
                                      Flame.device.fullScreen();

                                      Future.delayed(
                                          Duration(seconds: 1),
                                              () => {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => MainGame(),
                                            ))
                                          });

                                    },
                                    child: Text(
                                      'OKAY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF4AA241),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: -20,
                        top: -30,
                        child: Image.asset('assets/images/byn.png',
                            width: 100, height: 100),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 35,
                        child: Image.asset('assets/images/byn.png',
                            width: 50, height: 50),
                      ),
                      Positioned(
                        right: -20,
                        bottom: 0,
                        child: Image.asset('assets/images/byn.png',
                            width: 50, height: 50),
                      ),
                      Positioned(
                        left: -20,
                        bottom: 0,
                        child: Image.asset('assets/images/byn.png',
                            width: 50, height: 50),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logotipe.png',
                height: 150,
                width: 150,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PlayField extends StatelessWidget {
  PlayField(this.country1, this.country2);

  final String country1;
  final String country2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                country1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                country2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/ball.png',
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'TRY TO PLAY!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              WidgetsFlutterBinding.ensureInitialized();

              Flame.device.setLandscape();
              Flame.device.fullScreen();

              Future.delayed(
                  Duration(seconds: 1),
                  () => {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MainGame(),
                        ))
                      });
            },
            child: Text(
              'PLAY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFf0f2f5)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
