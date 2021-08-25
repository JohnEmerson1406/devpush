import 'package:devpush/components/simple_button.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/add_question_screen/add_questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({
    Key key,
  }) : super(key: key);

  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();

  String quizId;
  String quizImgUrl = '';
  String quizTitle = '';
  String quizDesc = '';
  String quizSubject = '';
  int numberOfQuestions = 0;

  List<String> subjects = [
    'Desenvolvimento Web',
    'Desenvolvimento Mobile',
    'Iniciante',
    'Linguagem de Programação',
    'Produtividade',
    'DevOps',
    'Git',
    'Linux',
    'Banco de Dados',
    'Ciência de Dados',
    'Aprendizado de Máquina',
    'Inteligência Artificial',
    'Algoritmos',
    'Blockchain',
    'UX',
    'Desenvolvimento de Jogos',
    'Motivação',
    'Clean Code',
    'API',
    'Design',
    'Backend',
    'Frontend',
    'Engenharia de Software',
  ];

  @override
  void initState() {
    subjects.sort();
    super.initState();
  }

  void createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> quizData = {
        "userId": Provider.of<DatabaseProvider>(context, listen: false).userId,
        "quizImgUrl": quizImgUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc,
        "quizSubject": quizSubject,
        "numberOfQuestions": numberOfQuestions,
        "totalRatings": 1,
        "ratingSum": 3,
        "createdAt": "${DateTime.now()}"
      };

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddQuestionScreen(
            quizId: quizId,
            quizData: quizData,
          ),
        ),
      );
    }
  }

  onChangeDropDownItem(String selectedItem) {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      quizSubject = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Criar Quiz',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: ListView(
              children: [
                TextFormField(
                  // validator: (val) => val.isEmpty ? "Enter Quiz Image Url" : null,
                  decoration: InputDecoration(
                    hintText: 'Link da Imagem (opcional)',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    quizImgUrl = val;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  textCapitalization: TextCapitalization.sentences,
                  validator: (val) => val.isEmpty ? 'Escreva um título' : null,
                  decoration: InputDecoration(
                    hintText: 'Título',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    quizTitle = val;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (val) =>
                      val.isEmpty ? 'Escreva uma descrição' : null,
                  decoration: InputDecoration(
                    hintText: 'Descrição',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    quizDesc = val;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                DropdownButtonFormField<String>(
                  validator: (_) =>
                      quizSubject.isEmpty ? 'Selecione um assunto' : null,
                  hint: Text('Assunto'),
                  items: subjects.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: onChangeDropDownItem,
                ),
                SizedBox(
                  height: 24,
                ),
                SimpleButton(
                  color: AppColors.blue,
                  title: 'Adicionar Questões',
                  onTap: createQuiz,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
