import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filmes_editar.dart';

class Filmes extends StatefulWidget {
  @override
  _FilmesState createState() => _FilmesState();
}

class _FilmesState extends State<Filmes> {
  var selectedCurrency = "DA114yb1S5LHkA9uFliu";

  DocumentSnapshot dadosBranco;
  TextEditingController nomeFilme = TextEditingController();
  TextEditingController precoFilme = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Filmes"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilmesEditar("inc",dadosBranco)),
            );
          }
      ),
      body:  Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              //stream: Firestore.instance.collection("produtos").orderBy("nome").startAt([textoBusca]).endAt([textoBusca + '\uf8ff']).snapshots(),
              //stream: Firestore.instance.collection("produtos").orderBy("nome").startAt([busca.text]).endAt([busca.text + '\uf8ff']).snapshots(),


                stream: Firestore.instance.collection("filmes").orderBy("nomeFilme").snapshots(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.done:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:

                      if (snapshot.data.documents.length==0){ //
                        return Center(
                          child: Text("Não há dados!",style: TextStyle(color: Colors.redAccent,fontSize: 20),),
                        );
                      }

                      return ListView.builder(

                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return Card( // Lista os produtos
                                child: ListTile(
                                  //snapshot.data.documents[index].documentID.toString() - pega o ID
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data.documents[index].data["urlImagem"]

                                    ),
                                  ),
                                  title: Text(snapshot.data.documents[index].data["nomeFilme"], style: TextStyle(fontSize: 25)),
                                  subtitle: Text("R\$ "  + snapshot.data.documents[index].data["precoFilme"].toString(),style: TextStyle(fontSize: 20)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.black,
                                        onPressed: () {
                                          //editaDados(context, index, snapshot);
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => ProdutosEditar(snapshot.data.documents[index].documentID.toString())));
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => FilmesEditar("alt",snapshot.data.documents[index])));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.black,
                                        onPressed: () {
                                          _confirmaExclusao(context, index, snapshot);
                                        },
                                      ),
                                    ],
                                  ),
                                ));
                          }
                      );
                  }
                }
            ),
          ),




        ],
      ),

    );
  }

  _confirmaExclusao(BuildContext context, index, snapshot) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Atenção !"),
          content: Text("Confirma a exclusão de : \n" + snapshot.data.documents[index].data["nomeFilme"].toString().toUpperCase()),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Firestore.instance.collection('filmes')
                    .document(snapshot.data.documents[index].documentID.toString())
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  editaDados(BuildContext context, index, [snapshot]) {

    setState(() {
      if (index == -1){
        nomeFilme.text = "";
        precoFilme.text = "";

      } else {
        nomeFilme.text = snapshot.data.documents[index].data["nomeFilme"].toString();
        precoFilme.text = snapshot.data.documents[index].data["precoFilme"].toString();
      }
    });


    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index < 0 ? "Inclusão de Filmes" : "Alteração de Filmes"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 1200,),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: nomeFilme,
                  decoration: InputDecoration(labelText: "Nome") ,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: precoFilme,
                  decoration: InputDecoration(labelText: "Preço") ,
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
                                style: TextStyle(color: Color(0xff11b719)),
                              ),
                              value: "${snap.documentID}",
                            ),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.access_alarms),
                            SizedBox(width: 50.0),
                            DropdownButton(
                              items: generoItens,
                              onChanged: (currencyValue) {

                                setState(() {
                                  selectedCurrency = currencyValue;
                                });
                              },
                              value: selectedCurrency,
                              isExpanded: false,
                              // hint: new Text(
                              // "Choose Currency Type",
                              // style: TextStyle(color: Color(0xff11b719)),
                              //),
                            ),
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Gravar'),
              onPressed: () {

                if (index==-1) {
                  //Firestore.instance.collection("filmes").document().setData({"nomeFilme":nomeFilme.text,"precoFilme":precoFilme.text});
                  Firestore.instance.collection("filmes").add(
                      {
                        "nomeFilme" : nomeFilme.text.toUpperCase(),
                        "precoFilme" : precoFilme.text
                      }
                  );
                } else {
                  Firestore.instance.collection("filmes").document(snapshot.data.documents[index].documentID.toString()).updateData({
                    "nomeFilme" : nomeFilme.text.toUpperCase(),
                    "precoFilme" : precoFilme.text
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
