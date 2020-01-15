class Anotacao{

  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data);

  Anotacao.fromMap(Map map){
    this.id = map['id'];
    this.titulo = map['titulo'];
    this.descricao = map['descricao'];
    this.data = map['data'];
  }

  Map toMap(){

    Map<String, dynamic> map = {
      "titulo" : this.titulo,
      "descricao" : this.descricao,
      "data" : this.data,
    };

    //SE o id for diferente de NULO é pq existe um ID
    if (this.id != null){
      map ['id'] = this.id;
    }

    return map;
  }
}