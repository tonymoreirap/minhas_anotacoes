import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/model/anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Controlador
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  //Atributos
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();



  //INCLUIR e EDITAR anotações

  _exibirTelacadastro({Anotacao anotacao}){

    String textoSalvarAtualizar = "";
    if ( anotacao == null){
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else{
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text('$textoSalvarAtualizar anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite Título..."
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a Descrição..."
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.pop(context) ,
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: (){

                  //Ações para SALVAR

                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);

                  Navigator.pop(context);
                } ,
                child: Text(textoSalvarAtualizar),
              )
            ],
          );
      }
    );
  }

  _recuperarAnotacoes() async {

    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = List<Anotacao>();
    for( var item in anotacoesRecuperadas){

      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = null;

    print(("Lista anotações: " + anotacoesRecuperadas.toString()));
  }

  _salvarAtualizarAnotacao({Anotacao anotacaoSelecionada}) async {

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if (anotacaoSelecionada == null){//SALVAR
      Anotacao anotacao = Anotacao (titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);
    } else {//ATUALIZAR
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int qtdAtualizado =
    }


    _tituloController.clear(); //Limpar os campos
    _descricaoController.clear();

    _recuperarAnotacoes();
  }

  _formatarData(String data){

    initializeDateFormatting("pt_BR");

    var formatador = DateFormat("d/M/y H:m:s");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;

  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemCount: _anotacoes.length,
                  itemBuilder: (context, index){

                    final anotacao = _anotacoes[index];

                    return Card(
                      child: ListTile(
                        title: Text(anotacao.titulo),
                        subtitle: Text ("${_formatarData(anotacao.data)} - ${anotacao.descricao} "),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                _exibirTelacadastro(anotacao: anotacao);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(Icons.edit,
                                color: Colors.green,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){},
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){

          _exibirTelacadastro();
        },
      ),
    );
  }
}
