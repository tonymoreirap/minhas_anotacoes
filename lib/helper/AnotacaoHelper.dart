import 'package:minhas_anotacoes/model/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper{

  static final String nomeTabela = "anotacao";
  //Padrão SingleToon
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal(); //Internal é construtor

  Database _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){
  }

  get db async {
    if (_db != null){
      return _db;
    } else {
      _db = await _inicializarDB();
      return _db;
    }

  }

  _onCreate(Database db, int version) async {

    String sql = "CREATE TABLE $nomeTabela ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        "data DATETIME)";
    await db.execute(sql);
  }

  _inicializarDB() async {

    final caminhoBancoDeDados = await getDatabasesPath();
    final localBancoDeDados = join (caminhoBancoDeDados, "banco minhas anotações.db");

    var db = await openDatabase(localBancoDeDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarAnotacao (Anotacao anotacao) async {

    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap() ); //Pegou anotação e transformou em um MAP
    return resultado;
  }

  recuperarAnotacoes() async {

    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;

  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    await bancoDados.update(
      nomeTabela,
      anotacao.toMap(),


    );
  }

}