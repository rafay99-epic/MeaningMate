import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/repositories/word_repository.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:meaning_mate/utils/layout_properties.dart';
import 'package:meaning_mate/utils/sizes.dart';
import 'package:meaning_mate/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _sentenceController = TextEditingController();
  final TextEditingController _synonymController = TextEditingController();
  final TextEditingController _antonymController = TextEditingController();
  final TextEditingController _tensesController = TextEditingController();

  List<String> meanings = [];
  List<String> sentences = [];
  List<String> synonyms = [];
  List<String> antonyms = [];
  List<String> tenses = [];

  final FirebaseAuth auth = FirebaseAuth.instance;
  final WordRepository wordRepo = WordRepository();
  String? userEmail;

  late SharedPreferences prefs;

  final StreamController<void> _controllerStream =
      StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    prefs = await SharedPreferences.getInstance();
    _getCurrentUserEmail();
    _loadSavedData();
    _listenToControllerChanges();
  }

  Future<void> _getCurrentUserEmail() async {
    final user = auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  Future<void> _saveDataToPreferences() async {
    final data = {
      'word': _wordController.text,
      'meanings': meanings,
      'sentences': sentences,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'tenses': tenses,
    };
    final jsonString = jsonEncode(data);
    await prefs.setString('word_data', jsonString);
  }

  void _loadSavedData() {
    final savedData = prefs.getString('word_data');
    if (savedData != null) {
      final Map<String, dynamic> data = jsonDecode(savedData);
      _wordController.text = data['word'] ?? '';
      meanings = List<String>.from(data['meanings'] ?? []);
      sentences = List<String>.from(data['sentences'] ?? []);
      synonyms = List<String>.from(data['synonyms'] ?? []);
      antonyms = List<String>.from(data['antonyms'] ?? []);
      tenses = List<String>.from(data['tenses'] ?? []);
      setState(() {});
    }
  }

  void _listenToControllerChanges() {
    _controllerStream.stream.listen((_) {
      _saveDataToPreferences();
    });

    _wordController.addListener(() => _controllerStream.add(null));
    _meaningController.addListener(() => _controllerStream.add(null));
    _sentenceController.addListener(() => _controllerStream.add(null));
    _synonymController.addListener(() => _controllerStream.add(null));
    _antonymController.addListener(() => _controllerStream.add(null));
    _tensesController.addListener(() => _controllerStream.add(null));
  }

  Future<void> _addWord() async {
    if (_wordController.text.isEmpty || meanings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Word and at least one meaning are required')),
      );
      return;
    }

    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    final word = Word(
      word: _wordController.text,
      meaning: meanings,
      sentences: sentences,
      synonyms: synonyms,
      antonyms: antonyms,
      tenses: tenses,
    );

    try {
      await wordRepo.addWord(word);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word added successfully!')),
      );
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _clearFields() {
    _wordController.clear();
    _meaningController.clear();
    _sentenceController.clear();
    _synonymController.clear();
    _antonymController.clear();
    _tensesController.clear();
    meanings.clear();
    sentences.clear();
    synonyms.clear();
    antonyms.clear();
    tenses.clear();
    setState(() {});
  }

  Widget _buildListWithInput({
    required String label,
    required List<String> items,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'Add $label',
                icon: icon,
                controller: controller,
                isPassword: false,
              ),
            ),
            IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    items.add(controller.text);
                    controller.clear();
                  });
                }
              },
              icon: Icon(Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        Wrap(
          spacing: 8.0,
          children: items
              .map((item) => Chip(
                    label: Text(item),
                    onDeleted: () {
                      setState(() {
                        items.remove(item);
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceCategory = DeviceType.getDeviceCategory(context);
    final layout = LayoutProperties.getProperties(deviceCategory, context);

    return PopScope<Object?>(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          await _saveDataToPreferences();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Word',
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
          leading: BackButton(
            color: Theme.of(context).colorScheme.surface,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: userEmail == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: layout.horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: layout.spacing),
                    SvgPicture.asset(
                      AddWordImage.logo,
                      width: layout.logoWidth,
                    ),
                    SizedBox(height: layout.spacing),
                    CustomTextField(
                      hintText: 'Word',
                      icon: Icons.text_fields,
                      controller: _wordController,
                      isPassword: false,
                    ),
                    SizedBox(height: layout.spacing),
                    _buildListWithInput(
                      label: 'Meaning',
                      items: meanings,
                      controller: _meaningController,
                      icon: Icons.description,
                    ),
                    SizedBox(height: layout.spacing),
                    _buildListWithInput(
                      label: 'Sentence',
                      items: sentences,
                      controller: _sentenceController,
                      icon: Icons.notes,
                    ),
                    SizedBox(height: layout.spacing),
                    _buildListWithInput(
                      label: 'Synonym',
                      items: synonyms,
                      controller: _synonymController,
                      icon: Icons.synagogue,
                    ),
                    SizedBox(height: layout.spacing),
                    _buildListWithInput(
                      label: 'Antonym',
                      items: antonyms,
                      controller: _antonymController,
                      icon: Icons.merge_type,
                    ),
                    SizedBox(height: layout.spacing),
                    _buildListWithInput(
                      label: 'Tenses',
                      items: tenses,
                      controller: _tensesController,
                      icon: Icons.settings_input_component_sharp,
                    ),
                    SizedBox(height: layout.spacing),
                    SizedBox(
                      width: layout.buttonWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: _addWord,
                        child: Text(
                          'Save Word',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface),
                        ),
                      ),
                    ),
                    SizedBox(height: layout.spacing),
                  ],
                ),
              ),
      ),
    );
  }
}
