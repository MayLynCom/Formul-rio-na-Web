import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //rotas
        '/': (context) => const SignUpScreen(),
        '/welcome': (context) => WelcomeScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          //caixa transparente
          width: 400, //largura
          child: Card(
            //Cria um cartão de design de material
            child: SignUpForm(), //chama outra Widhet página
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome!', style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  //final = variável que é nulla até o app ser executado, ela pode ser alterada para outras variáveis
  // TextEditingController = Cria um controlador para um campo de texto editável.

  double _formProgress = 0;

  void _updateFormProgress() {
    //Este método atualiza o _formProgresscampo com base no número de campos de texto não vazios.
    var progress = 0.0;
    //var sem definir variavel, o primeiro tipo que entrar vai continuar
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController
    ];
    //controllers = lista de controladores

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    //controller dentro de controllers, ou seja vai pegar cada controlador e verificar um de cada vez
    //.value = O valor atual armazenado neste notificador.
    //.text = O texto atual sendo editado.
    //.isNotEmpty = Se essa string não está vazia.
    //se isso tudo acima for verdade ele vai adicionar +1 ao progress
    //depois dividir pelo numero de controllers que é 3
    //se tiver 1 preenchido vai ser = 0.3
    //se tiver 2 preenchidos vai ser = 0.6
    //se tiver 3 preenchidos vai ser = 1

    setState(() {
      _formProgress = progress;
    });
  }

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
    //função que navega para a página Welcome
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      //formulário
      onChanged:
          _updateFormProgress, //foi adicionada uma função que pode mudar o formulário
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //mainAxisSize = controla o tamanho vertical
        //MainAxisSize.min = tamanho minimo necessário para os filhos aparecerem
        children: [
          //Cria um animador de progresso linear.
          AnimatedProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: _formProgress == 1 ? _showWelcomeScreen : null,
            //se _formProgress == 1 for true vai mostrar a página _showWelcomeScreen se for false mostra null
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

//Late = significa que a variavel não tem valor, porem vai ter depois
//sempre utilizar quando uma variavel no começo nao tem valor mas é obrigadar a ter ex: CPF

  @override
  void initState() {
    //Chamado quando este objeto é inserido na árvore.
    //A estrutura chamará esse método exatamente uma vez para cada objeto [Estado] que ele cria.
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
        //ocê pode usar um AnimationController para executar qualquer animação, 
        //aqui você define a duração

    final colorTween = TweenSequence([
      //Usando a Tween, você pode interpolar entre quase qualquer valor, neste caso, Color.
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);
    //colorTween é uma animação que vai de uma cor para outra 

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
    //.easeIn = Uma curva de animação cúbica que começa lentamente e termina rapidamente.
    //aqui esta atribuindo o controlador de colorTween e curveTween para seus controladores 
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    //oldWidget = Chamado sempre que a configuração do widget muda.
    _controller.animateTo(widget.value);
    //.animateTo = Conduz a animação do seu valor atual para o destino.
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      //AnimatedBuilderreconstrói a árvore de widgets quando o valor de um Animationmuda.
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        //value = progresso linear, pega do _curveAnimation.value
        valueColor: _colorAnimation,
        
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),//coloca a opacidade da cor no fundo 
      ),
    );
  }
}
