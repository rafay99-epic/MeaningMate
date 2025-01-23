import 'package:flutter/material.dart';
import 'package:meaning_mate/providers/search_provider.dart';
import 'package:meaning_mate/screens/search/search_input_field.dart';
import 'package:meaning_mate/widgets/search/result_search_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isFocused = true;
        });
      } else {
        setState(() {
          _isFocused = false;
        });
      }
    });

    Future.microtask(() {
      Provider.of<SearchProvider>(context, listen: false).fetchAllWords();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          SearchInputField(
            controller: _searchController,
            focusNode: _focusNode,
            isFocused: _isFocused,
            onSearch: (query) {
              Provider.of<SearchProvider>(context, listen: false)
                  .searchWords(query);
            },
            onClear: () {
              _searchController.clear();
              Provider.of<SearchProvider>(context, listen: false)
                  .searchWords('');
            },
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                final results = searchProvider.filteredWords;

                if (results.isEmpty) {
                  return const Center(
                    child: Text('No matching words found.'),
                  );
                }
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final word = results[index];
                    return SearchResultCard(word: word);
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
