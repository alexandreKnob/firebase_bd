import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filmes.dart';
import 'imagem.dart';
import 'menu.dart';
import 'registrar.dart';
import 'esqueci.dart';

void main() {
  //
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController userEmail = TextEditingController();
  TextEditingController userSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Locadora - Login"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.lock_open,
                  size: 60,
                  color: Colors.blue,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    labelText: "E-Mail",
                  ),
                  textAlign: TextAlign.left,
                  controller: userEmail,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Informe o E-MAil !";
                    } else if (!userEmail.text.contains("@")) {
                      return "Insira um E-Mail válido !";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock_outline,
                      color: Colors.blue,
                    ),
                    labelText: "Senha",
                  ),
                  textAlign: TextAlign.left,
                  controller: userSenha,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Informe a Senha !";
                    }
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Logar"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      logar();
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Esqueci()),
                        );
                      },
                    ),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        "Registrar",
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Registrar()),
                        );
                      },
                    ),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text( "Imagem",textAlign: TextAlign.right,),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Imagem()),
                        );
                      },
                    ),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text( "Filmes",textAlign: TextAlign.right,),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Filmes()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> logar() async {
    String nomeUsuario;

    loading();

    try {
      FirebaseUser usuario = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: userEmail.text, password: userSenha.text);

      DocumentSnapshot dadosUsuario = await Firestore.instance
          .collection("usuarios")
          .document(usuario.uid)
          .get();
      nomeUsuario = dadosUsuario.data["nomeUsuario"].toString();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Menu(usuario, nomeUsuario)),
      );
    } catch (erro) {
      Navigator.pop(context);
      //print(erro.message);
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Erro ao fazer Login !'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0),
          child: new Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            padding: EdgeInsets.all(10),
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 30,
                ),
                new Text(" Verificando ..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
