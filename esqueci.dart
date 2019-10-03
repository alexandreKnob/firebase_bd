import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Esqueci extends StatefulWidget {
  @override
  _EsqueciState createState() => _EsqueciState();
}

class _EsqueciState extends State<Esqueci> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController userEmail = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Locadora - Esqueci a Senha"),
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_outline,color: Colors.blue,),
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

                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Requisitar Senha Nova"),
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
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail.text);
      Navigator.pop(context);

    } catch (erro) {
      //print(erro.message);
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Erro ao verificar o e-mail !'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

    }

  }

}
