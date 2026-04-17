import '../core/pb_client.dart';
import '../models/note_model.dart';

class NoteRepository {
  final String _collectionName = 'notes';

  Future<List<NoteModel>> getNotes() async {
    final records = await pb
        .collection(_collectionName)
        .getFullList(sort: '-created');
    return records.map((record) => NoteModel.fromRecord(record)).toList();
  }

  Future<void> createNote(String title, String content) async {
    await pb
        .collection(_collectionName)
        .create(body: {'title': title, 'content': content});
  }

  Future<void> updateNote(String id, String title, String content) async {
    await pb
        .collection(_collectionName)
        .update(id, body: {'title': title, 'content': content});
  }

  Future<void> deleteNote(String id) async {
    await pb.collection(_collectionName).delete(id);
  }
}
