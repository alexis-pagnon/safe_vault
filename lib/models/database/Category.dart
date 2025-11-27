
class Category {
  final int id_category;
  final String title;

  Category({
    required this.id_category,
    required this.title,
  });


  Map<String, dynamic> toMap() {
    return {
      'id_category': id_category,
      'title': title,
    };
  }


  Category.fromMap(Map<String, dynamic> data)
      : id_category = data["id_category"],
        title = data["title"];


  @override
  String toString() {
    return 'Category{id_category: $id_category, title: $title}';
  }
}