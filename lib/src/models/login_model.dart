import 'dart:convert';

List<LoginModel> loginModelFromJson(String str) => List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromJson(x)));

String loginModelToJson(List<LoginModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginModel {
  int idUsuario;
  String login;
  String senha;
  String nome;

  LoginModel({
    this.idUsuario,
    this.login,
    this.senha,
    this.nome,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    idUsuario: json["idUsuario"],
    login: json["login"],
    senha: json["senha"],
    nome: json["nome"],
  );

  Map<String, dynamic> toJson() => {
    "idUsuario": idUsuario,
    "login": login,
    "senha": senha,
    "nome": nome,
  };
}