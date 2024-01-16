import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item_model.dart';
import 'package:shopping_list_app/screens/new_item_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final List<GroceryItem> groceryList = [];
  void _addItem() async {
    final result = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        groceryList.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: groceryList.isEmpty
          ? const Center(
              child: Text('No items added yet.'),
            )
          : ListView.builder(
              itemCount: groceryList.length,
              itemBuilder: (context, index) => Dismissible(
                background:
                    Container(color: Theme.of(context).colorScheme.background),
                key: ValueKey(groceryList[index].id),
                onDismissed: (direction) => setState(() {
                  groceryList.removeAt(index);
                }),
                child: ListTile(
                  leading: Container(
                    height: 24,
                    width: 24,
                    color: groceryList[index].category.tagColor,
                  ),
                  title: Text(
                    groceryList[index].name,
                  ),
                  trailing: Text(
                    groceryList[index].quantity.toString(),
                  ),
                ),
              ),
            ),
    );
  }
}
