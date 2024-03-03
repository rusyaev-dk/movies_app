import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/search/presentation/search_bloc/search_bloc.dart';

class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        margin: const EdgeInsets.only(top: 50, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16, vertical: 16), // добавляем вертикальный отступ
          ),
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchMultiEvent(value));
          },
        ),
      ),
      backgroundColor: Colors.black, // прозрачный фон AppBar
      elevation: 0, // убираем тень
    );
  }

  @override
  Size get preferredSize {
    return const Size(double.infinity, 70);
  }
}
