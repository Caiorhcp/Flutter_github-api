// Importa o pacote Flutter para criação de interfaces de usuário e widgets.
import 'package:flutter/material.dart';

// Importa o pacote url_launcher para abrir URLs externas no navegador ou em aplicativos apropriados.
import 'package:url_launcher/url_launcher.dart';

// Define uma nova classe `HomePage` que estende `StatefulWidget`, indicando que este widget tem estado mutável.
class HomePage extends StatefulWidget {
  // O construtor `const` permite que o widget seja imutável e otimizado pelo Flutter.
  const HomePage({super.key});

  // Cria o estado associado ao `HomePage` e retorna uma instância da classe `_HomePageState`.
  @override
  _HomePageState createState() => _HomePageState();
}

// Define a classe de estado `_HomePageState` para o widget `HomePage`.
// Esta classe mantém o estado do widget `HomePage`.
class _HomePageState extends State<HomePage> {
  // Cria um controlador de texto para gerenciar o texto do campo de entrada.
  final TextEditingController _controller = TextEditingController();

  // Método assíncrono que será chamado quando o botão for pressionado.
  Future<void> _abrirPerfilGitHub() async {
    // Obtém o texto do controlador e remove espaços em branco nas extremidades.
    final username = _controller.text.trim();
    
    // Verifica se o nome de usuário não está vazio.
    if (username.isNotEmpty) {
      // Constrói a URL para acessar a API do GitHub que lista os repositórios do usuário.
      final url = 'https://api.github.com/users/$username/repos';
      
      // Converte a URL em um objeto `Uri`.
      final uri = Uri.parse(url);
      
      // Verifica se a URL pode ser lançada (se é um URL válido e pode ser tratado pelo sistema).
      if (await canLaunchUrl(uri)) {
        // Abre a URL no navegador ou no aplicativo apropriado.
        await launchUrl(uri);
      }
    }
  }

  // O método `build` descreve a interface do usuário usando widgets.
  @override
  Widget build(BuildContext context) {
    // Retorna um widget Scaffold que fornece uma estrutura básica para a página.
    return Scaffold(
      // Adiciona uma barra de aplicativos na parte superior da página.
      appBar: AppBar(
        // Define o título da barra de aplicativos.
        title: const Text('API Github link'),
      ),
      // Define o corpo da página com um `Padding` para adicionar espaçamento ao redor dos widgets internos.
      body: Padding(
        // Adiciona um preenchimento de 16 pixels ao redor do corpo da página.
        padding: const EdgeInsets.all(16.0),
        // Organiza os widgets verticalmente em uma coluna.
        child: Column(
          // Alinha os widgets no centro da coluna.
          mainAxisAlignment: MainAxisAlignment.center,
          // Lista de widgets na coluna.
          children: [
            // Widget de campo de texto para entrada de dados do usuário.
            TextField(
              // Associa o controlador de texto ao campo de entrada.
              controller: _controller,
              // Define a decoração do campo de texto.
              decoration: const InputDecoration(
                // Define a borda do campo de texto.
                border: OutlineInputBorder(),
                // Define o texto do rótulo exibido no campo de texto.
                labelText: 'Nome de usuário GitHub',
              ),
            ),
            // Adiciona um espaço de 16 pixels entre o campo de texto e o botão.
            const SizedBox(height: 16.0),
            // Botão elevado que chama o método `_abrirPerfilGitHub` quando pressionado.
            ElevatedButton(
              // Define a função a ser chamada quando o botão é pressionado.
              onPressed: _abrirPerfilGitHub,
              // Define o texto exibido no botão.
              child: const Text('Abrir Repositórios'),
            ),
          ],
        ),
      ),
    );
  }
}
