import 'package:flutter/material.dart';
import '../../models/note_model.dart';
import '../../repositories/note_repository.dart';
import '../widgets/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _repository = NoteRepository();
  late Future<List<NoteModel>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() {
    setState(() {
      _notesFuture = _repository.getNotes();
    });
  }

  Future<void> _handleSave(String? id, String title, String content) async {
    try {
      if (id == null) {
        await _repository.createNote(title, content);
      } else {
        await _repository.updateNote(id, title, content);
      }

      if (!mounted) return;
      _refreshNotes();
    } catch (_) {}
  }

  Future<void> _handleDelete(String id) async {
    try {
      await _repository.deleteNote(id);

      if (!mounted) return;
      _refreshNotes();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<NoteModel>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan koneksi.'));
          }

          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(child: Text('Kosong.'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(note.content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => NoteDialog(
                          note: note,
                          onSave: (t, c) => _handleSave(note.id, t, c),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _handleDelete(note.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => NoteDialog(onSave: (t, c) => _handleSave(null, t, c)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
