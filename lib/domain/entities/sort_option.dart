enum SortOption {
  nameAsc('Имя (А-Я)'),
  nameDesc('Имя (Я-А)'),
  status('Статус'),
  species('Вид');

  final String label;
  const SortOption(this.label);
}