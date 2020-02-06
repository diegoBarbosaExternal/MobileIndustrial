import 'dart:async';

class SupEmbRecebStateValidator {
  final validateDropDownProduto =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (produto, sink) {
    if (produto != null) {
      sink.add(produto);
    } else {
      sink.addError("Selecione um Produto");
    }
  });


  final validateVazio = StreamTransformer<String, String>.fromHandlers(
      handleData: (origem, sink) {
        if (origem != null && origem.isNotEmpty && origem.length > 0) {
          sink.add(origem);
        } else {
          sink.addError("Campo Obrigatorio");
        }
      });





  final validateDateTime = StreamTransformer<DateTime, String>.fromHandlers(
      handleData: (date, sink) {
        if (date != null) {
          sink.add(date.toString());
        }
        else {
          sink.addError("Campo Obrigatorio");
        }
      });
}
