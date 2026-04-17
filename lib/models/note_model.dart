import 'package:pocketbase/pocketbase.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;

  NoteModel({required this.id, required this.title, required this.content});

  factory NoteModel.fromRecord(RecordModel record) {
    return NoteModel(
      id: record.id,
      title: record.getStringValue('title'),
      content: record.getStringValue('content'),
    );
  }
}
