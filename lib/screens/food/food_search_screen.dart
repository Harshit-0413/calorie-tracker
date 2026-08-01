import 'dart:async';

import 'package:calorie_tracker/core/enums/meal_type.dart';
import 'package:flutter/material.dart';

import '../../../models/food_item.dart';
import '../../../services/database_service.dart';
import '../../../theme/app_theme.dart';
import 'food_detail_screen.dart';
import '../../models/meal_log.dart';

class FoodSearchScreen extends StatefulWidget {
  final MealType? mealType;
  const FoodSearchScreen({super.key, this.mealType});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final DatabaseService _database = DatabaseService();

  final TextEditingController _controller = TextEditingController();

  List<FoodItem> _results = [];

  bool _isSearching = false;

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int _searchId = 0;

  Future<void> _search(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    final currentSearchId = ++_searchId;
    setState(() => _isSearching = true);

    final foods = await _database.searchFoods(value);

    if (!mounted || currentSearchId != _searchId) {
      return; // stale result, discard
    }
    setState(() {
      _results = foods;
      _isSearching = false;
    });
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(title: const Text("Add Food")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.md),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search foods...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),

                        onPressed: () {
                          _debounce?.cancel();
                          _controller.clear();
                          setState(() {
                            _results = [];
                            _isSearching = false;
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          if (_isSearching)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_results.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Search for foods to begin",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final food = _results[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.md,
                      vertical: AppTheme.sm,
                    ),

                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.restaurant,
                        color: AppTheme.primary,
                      ),
                    ),

                    title: Text(
                      food.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${food.servingSize.toStringAsFixed(food.servingSize % 1 == 0 ? 0 : 1)} ${food.servingUnit}",
                        ),

                        const SizedBox(height: 2),

                        Text(
                          "${food.calories.toInt()} kcal • P ${food.protein}g • C ${food.carbs}g • F ${food.fat}g",
                        ),
                      ],
                    ),

                    trailing: const Icon(Icons.chevron_right),

                    onTap: () async {
                      if (widget.mealType == null) return;

                      final navigator = Navigator.of(context);
                      final MealFoodEntry? entry =
                          await Navigator.push<MealFoodEntry>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(
                                food: food,
                                mealType: widget.mealType!,
                              ),
                            ),
                          );

                      if (!mounted) return;

                      if (entry != null) {
                        navigator.pop(entry);
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
