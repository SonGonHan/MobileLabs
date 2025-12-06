import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../domain/entities/book.dart';

class OpenLibraryApiService {

  static const Map<String, String> _genreTranslations = {
    'fantasy': 'Фэнтези',
    'science fiction': 'Научная фантастика',
    'sci-fi': 'Научная фантастика',
    'mystery': 'Детектив',
    'thriller': 'Триллер',
    'romance': 'Романтика',
    'horror': 'Ужасы',
    'history': 'История',
    'biography': 'Биография',
    'poetry': 'Поэзия',
    'adventure': 'Приключения',
    'children': 'Детская литература',
    'juvenile fiction': 'Детская литература',
    'young adult': 'Молодёжная литература',
    'crime': 'Криминал',
    'philosophy': 'Философия',
    'psychology': 'Психология',
    'science': 'Наука',
    'magic': 'Магия',
    'wizards': 'Магия',
    'fiction': 'Художественная литература',
    'classic': 'Классика',
  };


  Future<List<Book>> searchBooks(String query) async {
    print(query);
    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      {'q': query},
    );
    
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('OpenLibrary error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (data['docs'] as List?) ?? [];

    return docs.take(20).map((doc) {
      final m = doc as Map<String, dynamic>;
      
      final isbnList = (m['isbn'] as List?);
      String effectiveIsbn;
      if (isbnList != null && isbnList.isNotEmpty) {
        effectiveIsbn = isbnList.first.toString();
      } else {
        final key = m['key']?.toString() ?? 'NO-KEY-${Random().nextInt(999999)}';
        effectiveIsbn = 'GEN-$key'; 
      }

      String genre = 'Не указан';
      final subjectList = m['subjects'] as List?;
      if (subjectList != null && subjectList.isNotEmpty) {
        for (final subject in subjectList) {
          final subjectStr = subject.toString().toLowerCase();
          for (final key in _genreTranslations.keys) {
            if (subjectStr.contains(key)) {
              genre = _genreTranslations[key]!;
              break;
            }
          }
          if (genre != 'Не указан') break;
        }
      }
      if (genre == 'Не указан') {
      final collections = m['ia_collection_s'] as String?;
      if (collections != null && collections.isNotEmpty) {
        final collectionList = collections.split(';');
        for (final collection in collectionList) {
          final collStr = collection.toLowerCase();
          for (final key in _genreTranslations.keys) {
            if (collStr.contains(key)) {
              genre = _genreTranslations[key]!;
              break;
            }
          }
          if (genre != 'Не указан') break;
        }
      }
    }

      
      final double randomPrice = 300.0 + Random().nextInt(1201); 

      return Book(
        title: m['title'] ?? 'Без названия',
        author: (m['author_name'] as List?)?.firstOrDefault() ?? 'Неизвестный автор',
        year: (m['first_publish_year']?.toString() ?? '—'),
        genre: genre,
        isbn: effectiveIsbn,
        price: randomPrice,
      );
    }).toList();
  }

}

extension _FirstOrNull on List {
  dynamic firstOrDefault() => isEmpty ? null : first;
}
