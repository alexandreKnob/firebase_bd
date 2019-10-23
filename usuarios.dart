import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuarios extends StatefulWidget {
  @override
  _UsuariosState createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {

  TextEditingController nomeUsuario = TextEditingController();
  TextEditingController senhaUsuario = TextEditingController();

  String senha = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Busca Usuários"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nomeUsuario,
              decoration: InputDecoration(
                labelText: "Usuário"
              ),
            ),
            TextField(
              controller: senhaUsuario,
              decoration: InputDecoration(
                  labelText: "Senha"
              ),
            ),
            Text(senha),
            RaisedButton(
              child: Text("Logar"),
              onPressed: () async {
                QuerySnapshot dados = await Firestore.instance.collection("login").
                where("usuario",isEqualTo: nomeUsuario.text).
                where("senha",isEqualTo: senhaUsuario.text).
                getDocuments();
                if (dados.documents.isNotEmpty) {
                  setState(() {
                    senha = dados.documents[0].data["senha"];
                  });
                } else {
                  setState(() {
                    senha = "Não Deu !";
                  });

                }




              },
            )

          ],
        ),
      ),
    );
  }
}
