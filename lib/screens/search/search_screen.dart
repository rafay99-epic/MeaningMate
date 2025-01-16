// import 'package:flutter/material.dart';
// import 'package:meaning_mate/models/word_model.dart';
// import 'package:meaning_mate/repositories/word_repository.dart';
// import 'package:meaning_mate/screens/search/search_input_field.dart';
// import 'package:meaning_mate/screens/search/search_result_card.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final WordRepository _wordRepository = WordRepository();
//   final FocusNode _focusNode = FocusNode();

//   List<Word> _searchResults = [];
//   bool _isLoading = false;
//   bool _isFocused = false;
//   bool _hasSearched = false;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus || _hasSearched) {
//         setState(() {
//           _isFocused = true;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _performSearch(String query) async {
//     if (query.trim().isEmpty) return;

//     setState(() {
//       _isLoading = true;
//       _error = null;
//       _hasSearched = true;
//     });

//     try {
//       final results = await _wordRepository.searchWords(query.trim());
//       setState(() {
//         _searchResults = results;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search'),
//         backgroundColor: theme.colorScheme.primary,
//         foregroundColor: theme.colorScheme.onPrimary,
//       ),
//       body: Column(
//         children: [
//           SearchInputField(
//             controller: _searchController,
//             focusNode: _focusNode,
//             isFocused: _isFocused,
//             onSearch: _performSearch,
//             onClear: () {
//               _searchController.clear();
//               setState(() {
//                 _searchResults.clear();
//                 _hasSearched = false;
//               });
//             },
//           ),
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator())
//           else if (_error != null)
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Error: $_error',
//                 style: TextStyle(color: theme.colorScheme.error),
//               ),
//             )
//           else
//             Expanded(
//               child: SearchResultsList(results: _searchResults),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/repositories/word_repository.dart';
import 'package:meaning_mate/screens/search/search_input_field.dart';
import 'package:meaning_mate/screens/search/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WordRepository _wordRepository = WordRepository();
  final FocusNode _focusNode = FocusNode();

  String _query = '';
  bool _isFocused = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus || _hasSearched) {
        setState(() {
          _isFocused = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _query = query.trim();
      _hasSearched = true;
    });
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
            onSearch: _performSearch,
            onClear: () {
              _searchController.clear();
              setState(() {
                _query = '';
                _hasSearched = false;
              });
            },
          ),
          if (_hasSearched)
            Expanded(
              child: StreamBuilder<List<Word>>(
                stream: _query.isNotEmpty
                    ? _wordRepository.searchWords(_query)
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No matching words found.'),
                    );
                  }

                  final results = snapshot.data!;
                  return SearchResultsList(results: results);
                },
              ),
            ),
        ],
      ),
    );
  }
}
