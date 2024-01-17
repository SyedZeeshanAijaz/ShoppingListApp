import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item_model.dart';
import 'package:shopping_list_app/screens/new_item_screen.dart';
import 'package:shopping_list_app/services/api_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<GroceryItem> groceryList = [];
  bool isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getAllItems();
  }

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

  void _getAllItems() async {
    try {
      final fetchedList = await ApiService().getAllItems();
      setState(() {
        groceryList = fetchedList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to to fetch data. Please try again later!";
      });
    }
  }

  void _onDeleteItem(GroceryItem deleteItem) async {
    final index = groceryList.indexOf(deleteItem);
    setState(() {
      groceryList.remove(deleteItem);
    });

    final status = await ApiService().deleteItem(deleteItem.id);
    if (status >= 400) {
      setState(() {
        groceryList.insert(index, deleteItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet.'),
    );
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (groceryList.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryList.length,
        itemBuilder: (context, index) => Dismissible(
          background:
              Container(color: Theme.of(context).colorScheme.background),
          key: ValueKey(groceryList[index].id),
          onDismissed: (direction) => _onDeleteItem(groceryList[index]),
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
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
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
      body: content,
    );
  }
}
