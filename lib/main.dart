import 'package:flutter/material.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> notes = [];

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController contentController =
      TextEditingController();

  // Hiển thị form thêm hoặc sửa ghi chú
  void showNoteDialog({int? index}) {
    titleController.text =
        index == null ? '' : notes[index]['title']!;

    contentController.text =
        index == null ? '' : notes[index]['content']!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            index == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                ),
              ),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                String title = titleController.text.trim();
                String content = contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  return;
                }

                setState(() {
                  if (index == null) {
                    notes.add({
                      'title': title,
                      'content': content,
                    });
                  } else {
                    notes[index] = {
                      'title': title,
                      'content': content,
                    };
                  }
                });

                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Xóa ghi chú
  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: notes.isEmpty
          ? const Center(
              child: Text(
                'Chưa có ghi chú nào!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      notes[index]['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notes[index]['content']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => showNoteDialog(index: index),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => deleteNote(index),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
