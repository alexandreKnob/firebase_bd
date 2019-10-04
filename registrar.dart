import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registrar extends StatefulWidget {
  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController userNome = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Locadora - Registrar"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10,),
                Icon(Icons.lock_open,size: 60, color: Colors.blue,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_outline,color: Colors.blue,),
                    labelText: "Nome",),
                  textAlign: TextAlign.left,
                  controller: userNome,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Informe o Nome !";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email,color: Colors.blue,),
                    labelText: "E-Mail",),
                  textAlign: TextAlign.left,
                  controller: userEmail,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Informe o E-MAil !";
                    } else if (    !userEmail.text.contains("@")){
                      return "Insira um E-Mail válido !";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline,color: Colors.blue,),
                    labelText: "Senha",),
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
                  child: Text("Registrar"),
                  onPressed: () {
                    if (_formKey.currentState.validate()){
                      registrar();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> registrar() async {
    try {
      FirebaseUser usuario = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: userEmail.text, password: userSenha.text);
      usuario.sendEmailVerification();

      Firestore.instance.collection("usuarios").document(usuario.uid).setData(
          {
            "nomeUsuario": userNome.text,
          }
      );
      Navigator.pop(context);

    } catch (erro) {
      //print(erro.message);
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Erro! Informe um E-Mail válido !'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

    }

  }

}
