import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FilmesEditar extends StatefulWidget {

  final String tipoEdicao;
  final DocumentSnapshot dadosProduto;

  FilmesEditar(this.tipoEdicao,this.dadosProduto);

  @override
  _FilmesEditarState createState() => _FilmesEditarState();
}

class _FilmesEditarState extends State<FilmesEditar> {
  //var selectedCurrency = "y3sP1DLtWjbifYpY4lPK";
  //var selectedCurrency = "DA114yb1S5LHkA9uFliu";
  String generoSelecionado;

  File _image;
  String caminhoImagem="";


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nomeFilme = TextEditingController();
  TextEditingController precoFilme = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.tipoEdicao=="alt"){
      nomeFilme.text =   widget.dadosProduto.data["nomeFilme"].toString();
      precoFilme.text =   widget.dadosProduto.data["precoFilme"].toString();
      generoSelecionado =   widget.dadosProduto.data["idGenero"].toString();
      caminhoImagem =   widget.dadosProduto.data["urlImagem"].toString();

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.tipoEdicao=="inc" ? "Inclusão de Filmes" : "Alteração de Filmes" ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left:10,right: 10),

        child:
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30),
                child:Icon(Icons.movie,color: Colors.blueAccent,size: 70,) ,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 18)),
                textAlign: TextAlign.left,
                controller: nomeFilme,
                validator: (value){
                  if (value.isEmpty){
                    return "Informe o Nome do Filme!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Preço do Filme",
                    labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 18)),
                textAlign: TextAlign.left,
                controller: precoFilme,
                validator: (value){
                  if (value.isEmpty){
                    return "Informe o Preço!";
                  }
                },
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("generos").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container();
                    else {
                      List<DropdownMenuItem> generoItens = [];
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        DocumentSnapshot snap = snapshot.data.documents[i];
                        generoItens.add(
                          DropdownMenuItem(
                            child: Text(
                              //snap.documentID,
                              snap.data["nomeGenero"],
                            ),
                            value: snap.documentID, //snap.documentID}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Gênero"),
                          SizedBox(width: 30.0),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              items: generoItens,
                              value: generoSelecionado,
                              onChanged: (currencyValue) {
                                setState(() {
                                  generoSelecionado = currencyValue;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  }),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child: new SizedBox(width: 180.0,height: 180.0,
                            child: (caminhoImagem.isNotEmpty)?Image.network(caminhoImagem,fit: BoxFit.fill,): Image.asset("imagens/semImagem.jpg")
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(icon: Icon(Icons.camera,size: 30.0,),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()){
                            if (generoSelecionado == null) {

                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Selecione um gênero !'),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackBar);

                            } else {
                              if (widget.tipoEdicao == "inc") {
                                Firestore.instance.collection("filmes").add(
                                    {
                                      "nomeFilme": nomeFilme.text.toUpperCase(),
                                      "precoFilme": precoFilme.text,
                                      "idGenero": generoSelecionado,
                                      "urlImagem": caminhoImagem
                                    }
                                );
                              } else {
                                Firestore.instance.collection("filmes")
                                    .document(widget.dadosProduto.documentID)
                                    .updateData({
                                  "nomeFilme": nomeFilme.text.toUpperCase(),
                                  "precoFilme": precoFilme.text,
                                  "idGenero": generoSelecionado,
                                  "urlImagem": caminhoImagem
                                });
                              }
                              Navigator.pop(context);
                            }
                          }

                        },
                        color: Colors.blue,
                        child: Text("Gravar",textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                        onPressed: () {Navigator.pop(context); },
                        color: Colors.blue,
                        child: Text("Cancelar",textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future getImage() async {

      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      _image = image;

      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
      caminhoImagem = (await taskSnapshot.ref.getDownloadURL());

      setState(() {
      });

  }




}

