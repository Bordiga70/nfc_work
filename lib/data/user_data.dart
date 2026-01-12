class UserData {
  final int id;
  final String codiceFiscale;
  final String nome;
  final String cognome;

  UserData(this.id, this.codiceFiscale, this.nome, this.cognome);

  UserData.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      codiceFiscale = json['codice_fiscale'] as String,
      nome = json['nome'] as String,
      cognome = json['cognome'] as String;

  Map<String, dynamic> toJson() => {
    'id': id,
    'codice_fiscale': codiceFiscale,
    'nome': nome,
    'cognome': cognome,
  };
}
