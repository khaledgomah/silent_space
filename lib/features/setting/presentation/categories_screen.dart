import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/setting/presentation/manager/settings_cubit/settings_cubit.dart';
import 'package:silent_space/features/setting/presentation/widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addCategoryOnPressed(context);
            },
          ),
        ],
        centerTitle: true,
        title: Text(AppStrings.categoriesTitle.tr()),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            final categories = state.categories;
            if (categories.isEmpty) {
              return const Center(child: Text('No categories found'));
            }
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryItem(
                  category: category,
                  onDismissed: (direction) {
                    context.read<SettingsCubit>().removeCategory(category);
                  },
                );
              },
            );
          } else if (state is SettingsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<dynamic> addCategoryOnPressed(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
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
              _addCategory(context, settingsCubit, textController);
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
                _addCategory(context, settingsCubit, textController);
              },
              child: Text(AppStrings.add.tr()),
            ),
          ],
        );
      },
    );
  }

  void _addCategory(BuildContext dialogContext, SettingsCubit settingsCubit, TextEditingController textController) {
    final category = textController.text.trim();
    if (category.isNotEmpty) {
      settingsCubit.addCategory(category);
      Navigator.pop(dialogContext);
    }
  }
}
