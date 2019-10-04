import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filmes.dart';

class Menu extends StatefulWidget {

  FirebaseUser usuario;
  String oUsuario;
  Menu(this.usuario,this.oUsuario);

  @override
  _MenuState createState() => _MenuState();
}


class _MenuState extends State<Menu>  {

  String nomeUsuario;

  @override
  void initState() {
    super.initState();
    //buscaUsuario();
  }

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
              Text("Nome : " + widget.oUsuario.toString() ),
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

  Future<void> buscaUsuario() async {

    try {

      DocumentSnapshot dadosUsuario = await Firestore.instance.collection("usuarios").document(widget.usuario.uid).get();
      nomeUsuario = dadosUsuario.data["nomeUsuario"].toString();
      print(nomeUsuario);
      setState(() {

      });
    } catch (erro) {
      print("Errooo :"+erro.message);
    }
  }

}
