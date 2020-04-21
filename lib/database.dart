import 'dart:io';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
part 'database.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
        p.join(dbFolder.parent.path, 'databases/transistor_location_manager'));
    print(file.path);
    return FlutterQueryExecutor(
      path: file.path,
    );
  });
}

@UseMoor(
  include: {'tables.moor'},
)
class MoorDb extends _$MoorDb {
  MoorDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
