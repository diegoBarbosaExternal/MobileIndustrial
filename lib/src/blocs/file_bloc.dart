import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

/*
  LOGIN = Irá guardar todos os usuarios que logar no app.
  SUGAR = Irá gravar os dados de entrada, EX: TipoUsina, Usina, Produto.
  FORMULARIO = Irá gravar arquivos do tipo formulario. O nome do arquivo sempre
  será o ID do usuario logado.
  SINCRONIZADO = Irá conter todos os arquivos que foram sincronizados.
  PENDENTE = Situação apos criar um formulario.
 */
enum file { LOGIN, SUGAR, FORMULARIO }
enum situacao { NOVO, SINCRONIZADO }

class FileBloc {
  static Future<File> getFile({@required tipo, @required nomeFile}) async {
    try {
      final diretorio = await getApplicationDocumentsDirectory();

      if (tipo == file.FORMULARIO) {
        return File('${diretorio.path}/$nomeFile.json');
      } else if (tipo == file.LOGIN) {
        return File('${diretorio.path}/login.json');
      } else if (tipo == file.SUGAR) {
        return File('${diretorio.path}/$nomeFile'+'_sugar.json');
      } else if (tipo == situacao.SINCRONIZADO) {
        return File('${diretorio.path}/$nomeFile'+'_sincronizado.json');
      }
      return null;
    } catch (e) {
      print('Erro ao buscar arquivo JSON \n\n $e');
    }
  }

  static Future<File> saveData(
      {@required tipo, @required values, @required nomeFile}) async {
    try {
      final file = await getFile(tipo: tipo, nomeFile: nomeFile);
      return file.writeAsString(json.encode(values));
    } catch (e) {
      print('Erro ao salvar JSON \n\n $e');
    }
  }

  static Future<String> readData({@required tipo,@required nomeFile}) async {
    try {
      final file = await getFile(tipo: tipo, nomeFile: nomeFile);
      return file.readAsString();
    } catch (e) {
      print('Erro ao ler o JSON \n\n $e');
      return null;
    }
  }

//  static void writeFile(String d) async {
//    File f = await _getFile();
//    RandomAccessFile raf = f.openSync(mode: FileMode.write);
//    raf.writeStringSync(d);
//    raf.flushSync();
//    raf.closeSync();
//  }
}
