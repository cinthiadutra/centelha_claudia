/// Normaliza uma string para busca (remove acentos e converte para lowercase)
String normalizarParaBusca(String str) {
  return removerAcentos(str.toLowerCase().trim());
}

/// Utilitários para manipulação de strings

/// Remove acentos e caracteres especiais de uma string
String removerAcentos(String str) {
  const comAcento =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  const semAcento =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  String resultado = str;
  for (int i = 0; i < comAcento.length; i++) {
    resultado = resultado.replaceAll(comAcento[i], semAcento[i]);
  }
  return resultado;
}

/// Converte string para uppercase com tratamento de null
String? toUpperCaseOrNull(String? str) {
  if (str == null || str.trim().isEmpty) return null;
  return str.trim().toUpperCase();
}
