import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Map<String, dynamic>> _tarefas = [
    {'texto': 'Estudar para a prova', 'concluida': true},
    {'texto': 'Fazer a feira', 'concluida': true},
  ];
  
  final TextEditingController _controller = TextEditingController();

  void _adicionarTarefa() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _tarefas.add({
          'texto': _controller.text.trim(),
          'concluida': false,
        });
        _controller.clear();
      });
    }
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  void _toggleTarefa(int index) {
    setState(() {
      _tarefas[index]['concluida'] = !_tarefas[index]['concluida'];
    });
  }

  void _limparTodas() {
    setState(() {
      _tarefas.clear();
    });
    Navigator.pop(context);
  }

  void _mostrarSobre() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre'),
        content: const Text('Lista de Tarefas\nVersão 1.0.0\n\nApp desenvolvido em Flutter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'limpar') {
                _limparTodas();
              } else if (value == 'sobre') {
                _mostrarSobre();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'limpar',
                child: Row(
                  children: [
                    Icon(Icons.close, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Limpar Todas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sobre',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Sobre'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Nova Tarefa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Digite sua tarefa...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                  ),
                  onSubmitted: (_) => _adicionarTarefa(),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _adicionarTarefa,
                  child: const Text(
                    'Adicionar Tarefa',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suas Tarefas:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarefa['concluida'],
                      onChanged: (_) => _toggleTarefa(index),
                      activeColor: Colors.blue,
                    ),
                    title: Text(
                      tarefa['texto'],
                      style: TextStyle(
                        decoration: tarefa['concluida']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerTarefa(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
