import 'package:flutter/material.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  final FoodController foodController = Get.find<FoodController>();
  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Mau makan apa..',
              suffixIcon: Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = 5;
                  return ListTile(title: Text('item'));
                },
                childCount: 4,
              ),
             ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHistoryList({required int index}) {
  //   return ListTile(title: Text("History pencarian ke-$index"));
  // }
}
