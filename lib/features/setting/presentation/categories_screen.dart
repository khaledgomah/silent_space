import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/setting/helper/category_functions.dart';
import 'package:silent_space/features/setting/presentation/widgets/category_item.dart';

bool isCategoriesEmpty = false;

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String> categories = [];
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    categories = await getCategeories();
    if (categories.isEmpty && isCategoriesEmpty == false) {
      categories = ['Focus', 'Relax', 'Sleep', 'Meditation', 'Study', 'Workout', 'Yoga', 'Kids'];
      saveCategories(categories);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                addCategoryOnPressed(context);
              }),
        ],
        centerTitle: true,
        title: Text(AppStrings.categoriesTitle.tr()),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryItem(
              category: category,
              onDismissed: (direction) {
                setState(() {
                  categories.removeAt(index);
                  saveCategories(categories);
                });
              });
        },
      ),
    );
  }

  Future<dynamic> addCategoryOnPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: Text(AppStrings.addCategory.tr()),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Category Name',
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              _addCategory(textController);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppStrings.cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                _addCategory(textController);
              },
              child: Text(AppStrings.add.tr()),
            ),
          ],
        );
      },
    );
  }

  void _addCategory(TextEditingController textController) {
    final category = textController.text;
    if (category.isNotEmpty) {
      isCategoriesEmpty = false;
      categories.add(category);
      saveCategories(categories);
      Navigator.pop(context);
      setState(() {});
    }
  }
}
