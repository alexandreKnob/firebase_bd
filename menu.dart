import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'filmes.dart';

class Menu extends StatefulWidget {

  FirebaseUser usuario;
  Menu(this.usuario);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Menu"),
        ),

        body:  SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("E-Mail : " + widget.usuario.email ),
              RaisedButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("Filmes"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Filmes()),
                  );
                },
              ),
              RaisedButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("Gêneros"),
                onPressed: (){
                  //Navigator.push(
                  //  context,
                  // MaterialPageRoute(builder: (context) => Filmes()),
                  //);
                },
              ),
            ],
          ),
        )

    );
  }


}
