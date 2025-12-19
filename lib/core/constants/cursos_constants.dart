/// Constantes para o módulo de Cursos e Treinamentos
class CursosConstants {
  /// Status possíveis para inscrições
  static const List<String> statusInscricao = [
    'Pendente',
    'Confirmada',
    'Em andamento',
    'Concluída',
    'Cancelada',
    'Reprovado',
  ];

  /// Categorias de cursos
  static const List<String> categoriasCursos = [
    'Doutrina Espírita',
    'Mediunidade',
    'Evangelização',
    'Passes',
    'Desobsessão',
    'Estudos Bíblicos',
    'Filosofia Espírita',
    'Ciência Espírita',
    'Moral Espírita',
    'Formação de Trabalhadores',
    'Umbanda',
    'Candomblé',
    'Culturas Africanas',
    'Outros',
  ];

  /// Critérios de aprovação
  static const double frequenciaMinima = 75.0; // Percentual
  static const double notaMinima = 7.0; // De 0 a 10
}
