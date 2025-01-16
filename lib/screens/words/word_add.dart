import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/repositories/word_repository.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:meaning_mate/utils/sizes.dart';
import 'package:meaning_mate/widgets/text_field.dart';

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

  List<String> sentences = [];
  List<String> synonyms = [];
  List<String> antonyms = [];

  final FirebaseAuth auth = FirebaseAuth.instance;
  final WordRepository wordRepo = WordRepository();

  String? userEmail;

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
  }

  Future<void> _getCurrentUserEmail() async {
    final user = auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  Future<void> _addWord() async {
    if (_wordController.text.isEmpty || _meaningController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word and meaning cannot be empty')),
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
      meaning: _meaningController.text,
      sentences: sentences,
      synonyms: synonyms,
      antonyms: antonyms,
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
    sentences.clear();
    synonyms.clear();
    antonyms.clear();
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

    double horizontalPadding;
    double buttonWidth;
    double spacing;
    double logoWidth;

    if (deviceCategory == DeviceCategory.smallPhone) {
      horizontalPadding = 8.0;
      spacing = 20;
      logoWidth = 150;

      buttonWidth = MediaQuery.of(context).size.width * 0.8;
    } else if (deviceCategory == DeviceCategory.largePhone) {
      horizontalPadding = 16.0;
      spacing = 30;
      logoWidth = 200;
      buttonWidth = MediaQuery.of(context).size.width * 0.7;
    } else {
      horizontalPadding = 32.0;
      spacing = 50;
      logoWidth = 300;
      buttonWidth = MediaQuery.of(context).size.width * 0.6;
    }

    return Scaffold(
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
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  SizedBox(height: spacing),
                  SvgPicture.asset(
                    AddWordImage.logo,
                    width: logoWidth,
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    hintText: 'Word',
                    icon: Icons.text_fields,
                    controller: _wordController,
                    isPassword: false,
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    hintText: 'Meaning',
                    icon: Icons.description,
                    controller: _meaningController,
                    isPassword: false,
                  ),
                  SizedBox(height: spacing),
                  _buildListWithInput(
                    label: 'Sentence',
                    items: sentences,
                    controller: _sentenceController,
                    icon: Icons.notes,
                  ),
                  SizedBox(height: spacing),
                  _buildListWithInput(
                    label: 'Synonym',
                    items: synonyms,
                    controller: _synonymController,
                    icon: Icons.synagogue,
                  ),
                  SizedBox(height: spacing),
                  _buildListWithInput(
                    label: 'Antonym',
                    items: antonyms,
                    controller: _antonymController,
                    icon: Icons.merge_type,
                  ),
                  SizedBox(height: spacing),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: _addWord,
                      child: Text(
                        'Save Word',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),
                ],
              ),
            ),
    );
  }
}
