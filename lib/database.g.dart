// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Location extends DataClass implements Insertable<Location> {
  final int id;
  final String uuid;
  final String timestamp;
  final String json;
  final Uint8List data;
  final bool encrypted;
  final bool locked;
  Location(
      {this.id,
      @required this.uuid,
      this.timestamp,
      this.json,
      this.data,
      @required this.encrypted,
      @required this.locked});
  factory Location.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Location(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      uuid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}uuid']),
      timestamp: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}timestamp']),
      json: stringType.mapFromDatabaseResponse(data['${effectivePrefix}json']),
      data:
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}data']),
      encrypted:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}encrypted']),
      locked:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}locked']),
    );
  }
  factory Location.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      json: serializer.fromJson<String>(json['json']),
      data: serializer.fromJson<Uint8List>(json['data']),
      encrypted: serializer.fromJson<bool>(json['encrypted']),
      locked: serializer.fromJson<bool>(json['locked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'timestamp': serializer.toJson<String>(timestamp),
      'json': serializer.toJson<String>(json),
      'data': serializer.toJson<Uint8List>(data),
      'encrypted': serializer.toJson<bool>(encrypted),
      'locked': serializer.toJson<bool>(locked),
    };
  }

  @override
  LocationsCompanion createCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      uuid: uuid == null && nullToAbsent ? const Value.absent() : Value(uuid),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
      json: json == null && nullToAbsent ? const Value.absent() : Value(json),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      encrypted: encrypted == null && nullToAbsent
          ? const Value.absent()
          : Value(encrypted),
      locked:
          locked == null && nullToAbsent ? const Value.absent() : Value(locked),
    );
  }

  Location copyWith(
          {int id,
          String uuid,
          String timestamp,
          String json,
          Uint8List data,
          bool encrypted,
          bool locked}) =>
      Location(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        timestamp: timestamp ?? this.timestamp,
        json: json ?? this.json,
        data: data ?? this.data,
        encrypted: encrypted ?? this.encrypted,
        locked: locked ?? this.locked,
      );
  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('timestamp: $timestamp, ')
          ..write('json: $json, ')
          ..write('data: $data, ')
          ..write('encrypted: $encrypted, ')
          ..write('locked: $locked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          uuid.hashCode,
          $mrjc(
              timestamp.hashCode,
              $mrjc(
                  json.hashCode,
                  $mrjc(data.hashCode,
                      $mrjc(encrypted.hashCode, locked.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.timestamp == this.timestamp &&
          other.json == this.json &&
          other.data == this.data &&
          other.encrypted == this.encrypted &&
          other.locked == this.locked);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> timestamp;
  final Value<String> json;
  final Value<Uint8List> data;
  final Value<bool> encrypted;
  final Value<bool> locked;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.json = const Value.absent(),
    this.data = const Value.absent(),
    this.encrypted = const Value.absent(),
    this.locked = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.json = const Value.absent(),
    this.data = const Value.absent(),
    this.encrypted = const Value.absent(),
    this.locked = const Value.absent(),
  });
  LocationsCompanion copyWith(
      {Value<int> id,
      Value<String> uuid,
      Value<String> timestamp,
      Value<String> json,
      Value<Uint8List> data,
      Value<bool> encrypted,
      Value<bool> locked}) {
    return LocationsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      timestamp: timestamp ?? this.timestamp,
      json: json ?? this.json,
      data: data ?? this.data,
      encrypted: encrypted ?? this.encrypted,
      locked: locked ?? this.locked,
    );
  }
}

class Locations extends Table with TableInfo<Locations, Location> {
  final GeneratedDatabase _db;
  final String _alias;
  Locations(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, true,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  GeneratedTextColumn _uuid;
  GeneratedTextColumn get uuid => _uuid ??= _constructUuid();
  GeneratedTextColumn _constructUuid() {
    return GeneratedTextColumn('uuid', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT \'\'',
        defaultValue: const CustomExpression<String, StringType>('\'\''));
  }

  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  GeneratedTextColumn _timestamp;
  GeneratedTextColumn get timestamp => _timestamp ??= _constructTimestamp();
  GeneratedTextColumn _constructTimestamp() {
    return GeneratedTextColumn('timestamp', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _jsonMeta = const VerificationMeta('json');
  GeneratedTextColumn _json;
  GeneratedTextColumn get json => _json ??= _constructJson();
  GeneratedTextColumn _constructJson() {
    return GeneratedTextColumn('json', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _dataMeta = const VerificationMeta('data');
  GeneratedBlobColumn _data;
  GeneratedBlobColumn get data => _data ??= _constructData();
  GeneratedBlobColumn _constructData() {
    return GeneratedBlobColumn('data', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _encryptedMeta = const VerificationMeta('encrypted');
  GeneratedBoolColumn _encrypted;
  GeneratedBoolColumn get encrypted => _encrypted ??= _constructEncrypted();
  GeneratedBoolColumn _constructEncrypted() {
    return GeneratedBoolColumn('encrypted', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression<bool, BoolType>('0'));
  }

  final VerificationMeta _lockedMeta = const VerificationMeta('locked');
  GeneratedBoolColumn _locked;
  GeneratedBoolColumn get locked => _locked ??= _constructLocked();
  GeneratedBoolColumn _constructLocked() {
    return GeneratedBoolColumn('locked', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression<bool, BoolType>('0'));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, timestamp, json, data, encrypted, locked];
  @override
  Locations get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'locations';
  @override
  final String actualTableName = 'locations';
  @override
  VerificationContext validateIntegrity(LocationsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.uuid.present) {
      context.handle(
          _uuidMeta, uuid.isAcceptableValue(d.uuid.value, _uuidMeta));
    }
    if (d.timestamp.present) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableValue(d.timestamp.value, _timestampMeta));
    }
    if (d.json.present) {
      context.handle(
          _jsonMeta, json.isAcceptableValue(d.json.value, _jsonMeta));
    }
    if (d.data.present) {
      context.handle(
          _dataMeta, data.isAcceptableValue(d.data.value, _dataMeta));
    }
    if (d.encrypted.present) {
      context.handle(_encryptedMeta,
          encrypted.isAcceptableValue(d.encrypted.value, _encryptedMeta));
    }
    if (d.locked.present) {
      context.handle(
          _lockedMeta, locked.isAcceptableValue(d.locked.value, _lockedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Location.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocationsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.uuid.present) {
      map['uuid'] = Variable<String, StringType>(d.uuid.value);
    }
    if (d.timestamp.present) {
      map['timestamp'] = Variable<String, StringType>(d.timestamp.value);
    }
    if (d.json.present) {
      map['json'] = Variable<String, StringType>(d.json.value);
    }
    if (d.data.present) {
      map['data'] = Variable<Uint8List, BlobType>(d.data.value);
    }
    if (d.encrypted.present) {
      map['encrypted'] = Variable<bool, BoolType>(d.encrypted.value);
    }
    if (d.locked.present) {
      map['locked'] = Variable<bool, BoolType>(d.locked.value);
    }
    return map;
  }

  @override
  Locations createAlias(String alias) {
    return Locations(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Geofence extends DataClass implements Insertable<Geofence> {
  final int id;
  final String identifier;
  final double latitude;
  final double sinLatitude;
  final double cosLatitude;
  final double longitude;
  final double sinLongitude;
  final double cosLongitude;
  final double radius;
  final bool notifyOnEntry;
  final bool notifyOnExit;
  final bool notifyOnDwell;
  final int loiteringDelay;
  final String extras;
  Geofence(
      {this.id,
      @required this.identifier,
      @required this.latitude,
      @required this.sinLatitude,
      @required this.cosLatitude,
      @required this.longitude,
      @required this.sinLongitude,
      @required this.cosLongitude,
      @required this.radius,
      @required this.notifyOnEntry,
      @required this.notifyOnExit,
      @required this.notifyOnDwell,
      @required this.loiteringDelay,
      this.extras});
  factory Geofence.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Geofence(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      identifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}identifier']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      sinLatitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}sin_latitude']),
      cosLatitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}cos_latitude']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
      sinLongitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}sin_longitude']),
      cosLongitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}cos_longitude']),
      radius:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}radius']),
      notifyOnEntry: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}notifyOnEntry']),
      notifyOnExit: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}notifyOnExit']),
      notifyOnDwell: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}notifyOnDwell']),
      loiteringDelay: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}loiteringDelay']),
      extras:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}extras']),
    );
  }
  factory Geofence.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Geofence(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      latitude: serializer.fromJson<double>(json['latitude']),
      sinLatitude: serializer.fromJson<double>(json['sinLatitude']),
      cosLatitude: serializer.fromJson<double>(json['cosLatitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      sinLongitude: serializer.fromJson<double>(json['sinLongitude']),
      cosLongitude: serializer.fromJson<double>(json['cosLongitude']),
      radius: serializer.fromJson<double>(json['radius']),
      notifyOnEntry: serializer.fromJson<bool>(json['notifyOnEntry']),
      notifyOnExit: serializer.fromJson<bool>(json['notifyOnExit']),
      notifyOnDwell: serializer.fromJson<bool>(json['notifyOnDwell']),
      loiteringDelay: serializer.fromJson<int>(json['loiteringDelay']),
      extras: serializer.fromJson<String>(json['extras']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'latitude': serializer.toJson<double>(latitude),
      'sinLatitude': serializer.toJson<double>(sinLatitude),
      'cosLatitude': serializer.toJson<double>(cosLatitude),
      'longitude': serializer.toJson<double>(longitude),
      'sinLongitude': serializer.toJson<double>(sinLongitude),
      'cosLongitude': serializer.toJson<double>(cosLongitude),
      'radius': serializer.toJson<double>(radius),
      'notifyOnEntry': serializer.toJson<bool>(notifyOnEntry),
      'notifyOnExit': serializer.toJson<bool>(notifyOnExit),
      'notifyOnDwell': serializer.toJson<bool>(notifyOnDwell),
      'loiteringDelay': serializer.toJson<int>(loiteringDelay),
      'extras': serializer.toJson<String>(extras),
    };
  }

  @override
  GeofencesCompanion createCompanion(bool nullToAbsent) {
    return GeofencesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      identifier: identifier == null && nullToAbsent
          ? const Value.absent()
          : Value(identifier),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      sinLatitude: sinLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(sinLatitude),
      cosLatitude: cosLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(cosLatitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      sinLongitude: sinLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(sinLongitude),
      cosLongitude: cosLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(cosLongitude),
      radius:
          radius == null && nullToAbsent ? const Value.absent() : Value(radius),
      notifyOnEntry: notifyOnEntry == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyOnEntry),
      notifyOnExit: notifyOnExit == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyOnExit),
      notifyOnDwell: notifyOnDwell == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyOnDwell),
      loiteringDelay: loiteringDelay == null && nullToAbsent
          ? const Value.absent()
          : Value(loiteringDelay),
      extras:
          extras == null && nullToAbsent ? const Value.absent() : Value(extras),
    );
  }

  Geofence copyWith(
          {int id,
          String identifier,
          double latitude,
          double sinLatitude,
          double cosLatitude,
          double longitude,
          double sinLongitude,
          double cosLongitude,
          double radius,
          bool notifyOnEntry,
          bool notifyOnExit,
          bool notifyOnDwell,
          int loiteringDelay,
          String extras}) =>
      Geofence(
        id: id ?? this.id,
        identifier: identifier ?? this.identifier,
        latitude: latitude ?? this.latitude,
        sinLatitude: sinLatitude ?? this.sinLatitude,
        cosLatitude: cosLatitude ?? this.cosLatitude,
        longitude: longitude ?? this.longitude,
        sinLongitude: sinLongitude ?? this.sinLongitude,
        cosLongitude: cosLongitude ?? this.cosLongitude,
        radius: radius ?? this.radius,
        notifyOnEntry: notifyOnEntry ?? this.notifyOnEntry,
        notifyOnExit: notifyOnExit ?? this.notifyOnExit,
        notifyOnDwell: notifyOnDwell ?? this.notifyOnDwell,
        loiteringDelay: loiteringDelay ?? this.loiteringDelay,
        extras: extras ?? this.extras,
      );
  @override
  String toString() {
    return (StringBuffer('Geofence(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('latitude: $latitude, ')
          ..write('sinLatitude: $sinLatitude, ')
          ..write('cosLatitude: $cosLatitude, ')
          ..write('longitude: $longitude, ')
          ..write('sinLongitude: $sinLongitude, ')
          ..write('cosLongitude: $cosLongitude, ')
          ..write('radius: $radius, ')
          ..write('notifyOnEntry: $notifyOnEntry, ')
          ..write('notifyOnExit: $notifyOnExit, ')
          ..write('notifyOnDwell: $notifyOnDwell, ')
          ..write('loiteringDelay: $loiteringDelay, ')
          ..write('extras: $extras')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          identifier.hashCode,
          $mrjc(
              latitude.hashCode,
              $mrjc(
                  sinLatitude.hashCode,
                  $mrjc(
                      cosLatitude.hashCode,
                      $mrjc(
                          longitude.hashCode,
                          $mrjc(
                              sinLongitude.hashCode,
                              $mrjc(
                                  cosLongitude.hashCode,
                                  $mrjc(
                                      radius.hashCode,
                                      $mrjc(
                                          notifyOnEntry.hashCode,
                                          $mrjc(
                                              notifyOnExit.hashCode,
                                              $mrjc(
                                                  notifyOnDwell.hashCode,
                                                  $mrjc(
                                                      loiteringDelay.hashCode,
                                                      extras
                                                          .hashCode))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Geofence &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.latitude == this.latitude &&
          other.sinLatitude == this.sinLatitude &&
          other.cosLatitude == this.cosLatitude &&
          other.longitude == this.longitude &&
          other.sinLongitude == this.sinLongitude &&
          other.cosLongitude == this.cosLongitude &&
          other.radius == this.radius &&
          other.notifyOnEntry == this.notifyOnEntry &&
          other.notifyOnExit == this.notifyOnExit &&
          other.notifyOnDwell == this.notifyOnDwell &&
          other.loiteringDelay == this.loiteringDelay &&
          other.extras == this.extras);
}

class GeofencesCompanion extends UpdateCompanion<Geofence> {
  final Value<int> id;
  final Value<String> identifier;
  final Value<double> latitude;
  final Value<double> sinLatitude;
  final Value<double> cosLatitude;
  final Value<double> longitude;
  final Value<double> sinLongitude;
  final Value<double> cosLongitude;
  final Value<double> radius;
  final Value<bool> notifyOnEntry;
  final Value<bool> notifyOnExit;
  final Value<bool> notifyOnDwell;
  final Value<int> loiteringDelay;
  final Value<String> extras;
  const GeofencesCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.latitude = const Value.absent(),
    this.sinLatitude = const Value.absent(),
    this.cosLatitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.sinLongitude = const Value.absent(),
    this.cosLongitude = const Value.absent(),
    this.radius = const Value.absent(),
    this.notifyOnEntry = const Value.absent(),
    this.notifyOnExit = const Value.absent(),
    this.notifyOnDwell = const Value.absent(),
    this.loiteringDelay = const Value.absent(),
    this.extras = const Value.absent(),
  });
  GeofencesCompanion.insert({
    this.id = const Value.absent(),
    @required String identifier,
    @required double latitude,
    @required double sinLatitude,
    @required double cosLatitude,
    @required double longitude,
    @required double sinLongitude,
    @required double cosLongitude,
    @required double radius,
    this.notifyOnEntry = const Value.absent(),
    this.notifyOnExit = const Value.absent(),
    this.notifyOnDwell = const Value.absent(),
    this.loiteringDelay = const Value.absent(),
    this.extras = const Value.absent(),
  })  : identifier = Value(identifier),
        latitude = Value(latitude),
        sinLatitude = Value(sinLatitude),
        cosLatitude = Value(cosLatitude),
        longitude = Value(longitude),
        sinLongitude = Value(sinLongitude),
        cosLongitude = Value(cosLongitude),
        radius = Value(radius);
  GeofencesCompanion copyWith(
      {Value<int> id,
      Value<String> identifier,
      Value<double> latitude,
      Value<double> sinLatitude,
      Value<double> cosLatitude,
      Value<double> longitude,
      Value<double> sinLongitude,
      Value<double> cosLongitude,
      Value<double> radius,
      Value<bool> notifyOnEntry,
      Value<bool> notifyOnExit,
      Value<bool> notifyOnDwell,
      Value<int> loiteringDelay,
      Value<String> extras}) {
    return GeofencesCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      latitude: latitude ?? this.latitude,
      sinLatitude: sinLatitude ?? this.sinLatitude,
      cosLatitude: cosLatitude ?? this.cosLatitude,
      longitude: longitude ?? this.longitude,
      sinLongitude: sinLongitude ?? this.sinLongitude,
      cosLongitude: cosLongitude ?? this.cosLongitude,
      radius: radius ?? this.radius,
      notifyOnEntry: notifyOnEntry ?? this.notifyOnEntry,
      notifyOnExit: notifyOnExit ?? this.notifyOnExit,
      notifyOnDwell: notifyOnDwell ?? this.notifyOnDwell,
      loiteringDelay: loiteringDelay ?? this.loiteringDelay,
      extras: extras ?? this.extras,
    );
  }
}

class Geofences extends Table with TableInfo<Geofences, Geofence> {
  final GeneratedDatabase _db;
  final String _alias;
  Geofences(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, true,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _identifierMeta = const VerificationMeta('identifier');
  GeneratedTextColumn _identifier;
  GeneratedTextColumn get identifier => _identifier ??= _constructIdentifier();
  GeneratedTextColumn _constructIdentifier() {
    return GeneratedTextColumn('identifier', $tableName, false,
        $customConstraints: 'NOT NULL UNIQUE');
  }

  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  GeneratedRealColumn _latitude;
  GeneratedRealColumn get latitude => _latitude ??= _constructLatitude();
  GeneratedRealColumn _constructLatitude() {
    return GeneratedRealColumn('latitude', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _sinLatitudeMeta =
      const VerificationMeta('sinLatitude');
  GeneratedRealColumn _sinLatitude;
  GeneratedRealColumn get sinLatitude =>
      _sinLatitude ??= _constructSinLatitude();
  GeneratedRealColumn _constructSinLatitude() {
    return GeneratedRealColumn('sin_latitude', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _cosLatitudeMeta =
      const VerificationMeta('cosLatitude');
  GeneratedRealColumn _cosLatitude;
  GeneratedRealColumn get cosLatitude =>
      _cosLatitude ??= _constructCosLatitude();
  GeneratedRealColumn _constructCosLatitude() {
    return GeneratedRealColumn('cos_latitude', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  GeneratedRealColumn _longitude;
  GeneratedRealColumn get longitude => _longitude ??= _constructLongitude();
  GeneratedRealColumn _constructLongitude() {
    return GeneratedRealColumn('longitude', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _sinLongitudeMeta =
      const VerificationMeta('sinLongitude');
  GeneratedRealColumn _sinLongitude;
  GeneratedRealColumn get sinLongitude =>
      _sinLongitude ??= _constructSinLongitude();
  GeneratedRealColumn _constructSinLongitude() {
    return GeneratedRealColumn('sin_longitude', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _cosLongitudeMeta =
      const VerificationMeta('cosLongitude');
  GeneratedRealColumn _cosLongitude;
  GeneratedRealColumn get cosLongitude =>
      _cosLongitude ??= _constructCosLongitude();
  GeneratedRealColumn _constructCosLongitude() {
    return GeneratedRealColumn('cos_longitude', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _radiusMeta = const VerificationMeta('radius');
  GeneratedRealColumn _radius;
  GeneratedRealColumn get radius => _radius ??= _constructRadius();
  GeneratedRealColumn _constructRadius() {
    return GeneratedRealColumn('radius', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _notifyOnEntryMeta =
      const VerificationMeta('notifyOnEntry');
  GeneratedBoolColumn _notifyOnEntry;
  GeneratedBoolColumn get notifyOnEntry =>
      _notifyOnEntry ??= _constructNotifyOnEntry();
  GeneratedBoolColumn _constructNotifyOnEntry() {
    return GeneratedBoolColumn('notifyOnEntry', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression<bool, BoolType>('0'));
  }

  final VerificationMeta _notifyOnExitMeta =
      const VerificationMeta('notifyOnExit');
  GeneratedBoolColumn _notifyOnExit;
  GeneratedBoolColumn get notifyOnExit =>
      _notifyOnExit ??= _constructNotifyOnExit();
  GeneratedBoolColumn _constructNotifyOnExit() {
    return GeneratedBoolColumn('notifyOnExit', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression<bool, BoolType>('0'));
  }

  final VerificationMeta _notifyOnDwellMeta =
      const VerificationMeta('notifyOnDwell');
  GeneratedBoolColumn _notifyOnDwell;
  GeneratedBoolColumn get notifyOnDwell =>
      _notifyOnDwell ??= _constructNotifyOnDwell();
  GeneratedBoolColumn _constructNotifyOnDwell() {
    return GeneratedBoolColumn('notifyOnDwell', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression<bool, BoolType>('0'));
  }

  final VerificationMeta _loiteringDelayMeta =
      const VerificationMeta('loiteringDelay');
  GeneratedIntColumn _loiteringDelay;
  GeneratedIntColumn get loiteringDelay =>
      _loiteringDelay ??= _constructLoiteringDelay();
  GeneratedIntColumn _constructLoiteringDelay() {
    return GeneratedIntColumn('loiteringDelay', $tableName, false,
        $customConstraints: 'NOT NULL DEFAULT 0',
        defaultValue: const CustomExpression<int, IntType>('0'));
  }

  final VerificationMeta _extrasMeta = const VerificationMeta('extras');
  GeneratedTextColumn _extras;
  GeneratedTextColumn get extras => _extras ??= _constructExtras();
  GeneratedTextColumn _constructExtras() {
    return GeneratedTextColumn('extras', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        identifier,
        latitude,
        sinLatitude,
        cosLatitude,
        longitude,
        sinLongitude,
        cosLongitude,
        radius,
        notifyOnEntry,
        notifyOnExit,
        notifyOnDwell,
        loiteringDelay,
        extras
      ];
  @override
  Geofences get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'geofences';
  @override
  final String actualTableName = 'geofences';
  @override
  VerificationContext validateIntegrity(GeofencesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.identifier.present) {
      context.handle(_identifierMeta,
          identifier.isAcceptableValue(d.identifier.value, _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (d.latitude.present) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableValue(d.latitude.value, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (d.sinLatitude.present) {
      context.handle(_sinLatitudeMeta,
          sinLatitude.isAcceptableValue(d.sinLatitude.value, _sinLatitudeMeta));
    } else if (isInserting) {
      context.missing(_sinLatitudeMeta);
    }
    if (d.cosLatitude.present) {
      context.handle(_cosLatitudeMeta,
          cosLatitude.isAcceptableValue(d.cosLatitude.value, _cosLatitudeMeta));
    } else if (isInserting) {
      context.missing(_cosLatitudeMeta);
    }
    if (d.longitude.present) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableValue(d.longitude.value, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (d.sinLongitude.present) {
      context.handle(
          _sinLongitudeMeta,
          sinLongitude.isAcceptableValue(
              d.sinLongitude.value, _sinLongitudeMeta));
    } else if (isInserting) {
      context.missing(_sinLongitudeMeta);
    }
    if (d.cosLongitude.present) {
      context.handle(
          _cosLongitudeMeta,
          cosLongitude.isAcceptableValue(
              d.cosLongitude.value, _cosLongitudeMeta));
    } else if (isInserting) {
      context.missing(_cosLongitudeMeta);
    }
    if (d.radius.present) {
      context.handle(
          _radiusMeta, radius.isAcceptableValue(d.radius.value, _radiusMeta));
    } else if (isInserting) {
      context.missing(_radiusMeta);
    }
    if (d.notifyOnEntry.present) {
      context.handle(
          _notifyOnEntryMeta,
          notifyOnEntry.isAcceptableValue(
              d.notifyOnEntry.value, _notifyOnEntryMeta));
    }
    if (d.notifyOnExit.present) {
      context.handle(
          _notifyOnExitMeta,
          notifyOnExit.isAcceptableValue(
              d.notifyOnExit.value, _notifyOnExitMeta));
    }
    if (d.notifyOnDwell.present) {
      context.handle(
          _notifyOnDwellMeta,
          notifyOnDwell.isAcceptableValue(
              d.notifyOnDwell.value, _notifyOnDwellMeta));
    }
    if (d.loiteringDelay.present) {
      context.handle(
          _loiteringDelayMeta,
          loiteringDelay.isAcceptableValue(
              d.loiteringDelay.value, _loiteringDelayMeta));
    }
    if (d.extras.present) {
      context.handle(
          _extrasMeta, extras.isAcceptableValue(d.extras.value, _extrasMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Geofence map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Geofence.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(GeofencesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.identifier.present) {
      map['identifier'] = Variable<String, StringType>(d.identifier.value);
    }
    if (d.latitude.present) {
      map['latitude'] = Variable<double, RealType>(d.latitude.value);
    }
    if (d.sinLatitude.present) {
      map['sin_latitude'] = Variable<double, RealType>(d.sinLatitude.value);
    }
    if (d.cosLatitude.present) {
      map['cos_latitude'] = Variable<double, RealType>(d.cosLatitude.value);
    }
    if (d.longitude.present) {
      map['longitude'] = Variable<double, RealType>(d.longitude.value);
    }
    if (d.sinLongitude.present) {
      map['sin_longitude'] = Variable<double, RealType>(d.sinLongitude.value);
    }
    if (d.cosLongitude.present) {
      map['cos_longitude'] = Variable<double, RealType>(d.cosLongitude.value);
    }
    if (d.radius.present) {
      map['radius'] = Variable<double, RealType>(d.radius.value);
    }
    if (d.notifyOnEntry.present) {
      map['notifyOnEntry'] = Variable<bool, BoolType>(d.notifyOnEntry.value);
    }
    if (d.notifyOnExit.present) {
      map['notifyOnExit'] = Variable<bool, BoolType>(d.notifyOnExit.value);
    }
    if (d.notifyOnDwell.present) {
      map['notifyOnDwell'] = Variable<bool, BoolType>(d.notifyOnDwell.value);
    }
    if (d.loiteringDelay.present) {
      map['loiteringDelay'] = Variable<int, IntType>(d.loiteringDelay.value);
    }
    if (d.extras.present) {
      map['extras'] = Variable<String, StringType>(d.extras.value);
    }
    return map;
  }

  @override
  Geofences createAlias(String alias) {
    return Geofences(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

abstract class _$MoorDb extends GeneratedDatabase {
  _$MoorDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  Locations _locations;
  Locations get locations => _locations ??= Locations(this);
  Geofences _geofences;
  Geofences get geofences => _geofences ??= Geofences(this);
  Location _rowToLocation(QueryRow row) {
    return Location(
      id: row.readInt('id'),
      uuid: row.readString('uuid'),
      timestamp: row.readString('timestamp'),
      json: row.readString('json'),
      data: row.readBlob('data'),
      encrypted: row.readBool('encrypted'),
      locked: row.readBool('locked'),
    );
  }

  Selectable<Location> getAllLocations() {
    return customSelectQuery('SELECT * FROM locations',
        variables: [], readsFrom: {locations}).map(_rowToLocation);
  }

  Selectable<Location> getLocationsBetween(String var1, String var2) {
    return customSelectQuery(
        'SELECT * FROM locations WHERE timestamp BETWEEN ? AND ?',
        variables: [Variable.withString(var1), Variable.withString(var2)],
        readsFrom: {locations}).map(_rowToLocation);
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [locations, geofences];
}
