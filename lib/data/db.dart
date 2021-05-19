import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

final kFavoriteRestaurantsTable = 'favorite_restaurants';

Future<Database> openDatabaseConnection() async {
  final path = await getDatabasesPath();

  print(path);

  return openDatabase(
    p.join(path, 'restaurant.db'),
    onCreate: (db, version) async {
      await db.execute(
        '''CREATE TABLE $kFavoriteRestaurantsTable (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating double
           )''',
      );
    },
    version: 1,
  );
}
