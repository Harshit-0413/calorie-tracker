import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

import '../../widgets/food/food_result_tile.dart';
import '../../widgets/food/food_search_bar.dart';

class FoodDatabaseScreen extends StatefulWidget {
  const FoodDatabaseScreen({super.key});

  @override
  State<FoodDatabaseScreen> createState() => _FoodDatabaseScreenState();
}

class _FoodDatabaseScreenState extends State<FoodDatabaseScreen> {
  final _controller = TextEditingController();

  final _db = DatabaseService();

  List<FoodItem> foods = [];

  @override
  void initState() {
    super.initState();
    _search("");
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      foods = await _db.searchFoods("");
    } else {
      foods = await _db.searchFoods(query);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text("Food Database")),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(
          children: [
            FoodSearchBar(controller: _controller, onChanged: _search),

            const SizedBox(height: AppTheme.lg),

            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (_, index) {
                  return FoodResultTile(
                    food: foods[index],
                    onTap: () {
                      Navigator.pop(context, foods[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
