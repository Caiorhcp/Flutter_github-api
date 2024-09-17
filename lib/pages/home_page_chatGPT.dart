import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_ext/models/api_service.dart'; // Importa a função para buscar projetos
import 'package:my_ext/models/project_model.dart'; // Importa o modelo de projeto

// Página principal do aplicativo
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Construtor da página principal
  @override
  _HomePageState createState() => _HomePageState(); // Cria o estado da página
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller =
      TextEditingController(); // Controlador do campo de texto
  List<Project> _projetos = []; // Lista para armazenar os projetos retornados
  bool _carregando = false; // Flag para indicar se a busca está em andamento
  String _mensagemErro = ''; // Mensagem de erro a ser exibida

  // Método para buscar projetos com base no nome de usuário fornecido
  Future<void> _buscarProjetos() async {
    setState(() {
      _carregando = true; // Inicia o carregamento
      _mensagemErro = ''; // Limpa a mensagem de erro
    });

    final usuario =
        _controller.text.trim(); // Obtém o nome de usuário do campo de texto
    if (usuario.isNotEmpty) {
      // Verifica se o nome de usuário não está vazio
      try {
        final projetos = await getProjects(usuario); // Busca os projetos
        setState(() {
          _projetos = projetos; // Atualiza a lista de projetos
          _carregando = false; // Finaliza o carregamento
        });
      } catch (e) {
        setState(() {
          _mensagemErro =
              'User não encontrado, tente novamente'; // Define a mensagem de erro
          _carregando = false; // Finaliza o carregamento
        });
      }
    } else {
      setState(() {
        _mensagemErro =
            'Digite um nome de usuário'; // Mensagem de erro se o campo estiver vazio
        _carregando = false; // Finaliza o carregamento
      });
    }
  }

  // Método para abrir a URL no navegador
  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url); // Converte a URL em um objeto Uri
    if (await canLaunchUrl(uri)) {
      // Verifica se a URL pode ser aberta
      await launchUrl(uri); // Abre a URL
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Não foi possível abrir o link')), // Exibe mensagem de erro
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositórios GitHub'), // Título da AppBar
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Adiciona padding ao corpo da página
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para entrada do nome de usuário GitHub
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome de usuário GitHub',
              ),
            ),
            const SizedBox(
                height: 16.0), // Espaçamento entre o campo de texto e o botão

            // Botão para buscar repositórios
            ElevatedButton(
              onPressed:
                  _buscarProjetos, // Chama o método de busca quando pressionado
              child: const Text('Buscar Repositórios'),
            ),
            const SizedBox(
                height:
                    16.0), // Espaçamento entre o botão e o conteúdo da lista

            // Indicador de carregamento e mensagem de erro
            if (_carregando)
              const CircularProgressIndicator(), // Exibe indicador de carregamento
            if (_mensagemErro.isNotEmpty)
              Text(_mensagemErro,
                  style: const TextStyle(
                      color: Colors.red)), // Exibe mensagem de erro

            // Lista de repositórios
            Expanded(
              child: ListView.builder(
                itemCount: _projetos.length, // Número de itens na lista
                itemBuilder: (context, index) {
                  final projeto =
                      _projetos[index]; // Obtém o projeto na posição atual
                  return ListTile(
                    leading: Image.network(
                        projeto.userImage), // Exibe a imagem do usuário
                    title: Text(projeto.name), // Nome do projeto
                    subtitle:
                        Text(projeto.fullName), // Nome completo do projeto
                    onTap: () {
                      final url =
                          'https://github.com/${_controller.text.trim()}/${projeto.name}'; // Gera a URL do projeto
                      _abrirUrl(url); // Abre a URL do projeto
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
