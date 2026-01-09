class UserData {
  final int id;
  final String codice_fiscale;
  final String nome;
  final String cognome;

  UserData(this.id, this.codice_fiscale, this.nome, this.cognome);

  UserData.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      codice_fiscale = json['codice_fiscale'] as String,
      nome = json['nome'] as String,
      cognome = json['cognome'] as String;

  Map<String, dynamic> toJson() => {
    'id': id,
    'codice_fiscale': codice_fiscale,
    'nome': nome,
    'cognome': cognome,
  };
}
