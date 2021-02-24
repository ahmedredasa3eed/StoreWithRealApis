
class CategoryList {

  List<dynamic> categories;

  CategoryList({this.categories});

  factory CategoryList.fromJson(Map<String,dynamic> jsonData){
    return CategoryList(
      categories : jsonData['categories'],
    );
  }

}