// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'info_pin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$InfoPinStateTearOff {
  const _$InfoPinStateTearOff();

  Initial initial() {
    return const Initial();
  }

  Error error(String error) {
    return Error(
      error,
    );
  }

  Loading loading() {
    return const Loading();
  }

  Deleting deleting() {
    return const Deleting();
  }

  DeleteComplete deleteComplete() {
    return const DeleteComplete();
  }

  Editing editing(String text) {
    return Editing(
      text,
    );
  }
}

// ignore: unused_element
const $InfoPinState = _$InfoPinStateTearOff();

mixin _$InfoPinState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result error(String error),
    @required Result loading(),
    @required Result deleting(),
    @required Result deleteComplete(),
    @required Result editing(String text),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result error(String error),
    Result loading(),
    Result deleting(),
    Result deleteComplete(),
    Result editing(String text),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result error(Error value),
    @required Result loading(Loading value),
    @required Result deleting(Deleting value),
    @required Result deleteComplete(DeleteComplete value),
    @required Result editing(Editing value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result error(Error value),
    Result loading(Loading value),
    Result deleting(Deleting value),
    Result deleteComplete(DeleteComplete value),
    Result editing(Editing value),
    @required Result orElse(),
  });
}

abstract class $InfoPinStateCopyWith<$Res> {
  factory $InfoPinStateCopyWith(
          InfoPinState value, $Res Function(InfoPinState) then) =
      _$InfoPinStateCopyWithImpl<$Res>;
}

class _$InfoPinStateCopyWithImpl<$Res> implements $InfoPinStateCopyWith<$Res> {
  _$InfoPinStateCopyWithImpl(this._value, this._then);

  final InfoPinState _value;
  // ignore: unused_field
  final $Res Function(InfoPinState) _then;
}

abstract class $InitialCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) then) =
      _$InitialCopyWithImpl<$Res>;
}

class _$InitialCopyWithImpl<$Res> extends _$InfoPinStateCopyWithImpl<$Res>
    implements $InitialCopyWith<$Res> {
  _$InitialCopyWithImpl(Initial _value, $Res Function(Initial) _then)
      : super(_value, (v) => _then(v as Initial));

  @override
  Initial get _value => super._value as Initial;
}

class _$Initial implements Initial {
  const _$Initial();

  @override
  String toString() {
    return 'InfoPinState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result error(String error),
    @required Result loading(),
    @required Result deleting(),
    @required Result deleteComplete(),
    @required Result editing(String text),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result error(String error),
    Result loading(),
    Result deleting(),
    Result deleteComplete(),
    Result editing(String text),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result error(Error value),
    @required Result loading(Loading value),
    @required Result deleting(Deleting value),
    @required Result deleteComplete(DeleteComplete value),
    @required Result editing(Editing value),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result error(Error value),
    Result loading(Loading value),
    Result deleting(Deleting value),
    Result deleteComplete(DeleteComplete value),
    Result editing(Editing value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements InfoPinState {
  const factory Initial() = _$Initial;
}

abstract class $ErrorCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) then) =
      _$ErrorCopyWithImpl<$Res>;
  $Res call({String error});
}

class _$ErrorCopyWithImpl<$Res> extends _$InfoPinStateCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(Error _value, $Res Function(Error) _then)
      : super(_value, (v) => _then(v as Error));

  @override
  Error get _value => super._value as Error;

  @override
  $Res call({
    Object error = freezed,
  }) {
    return _then(Error(
      error == freezed ? _value.error : error as String,
    ));
  }
}

class _$Error implements Error {
  const _$Error(this.error) : assert(error != null);

  @override
  final String error;

  @override
  String toString() {
    return 'InfoPinState.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Error &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @override
  $ErrorCopyWith<Error> get copyWith =>
      _$ErrorCopyWithImpl<Error>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result error(String error),
    @required Result loading(),
    @required Result deleting(),
    @required Result deleteComplete(),
    @required Result editing(String text),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result error(String error),
    Result loading(),
    Result deleting(),
    Result deleteComplete(),
    Result editing(String text),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result error(Error value),
    @required Result loading(Loading value),
    @required Result deleting(Deleting value),
    @required Result deleteComplete(DeleteComplete value),
    @required Result editing(Editing value),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result error(Error value),
    Result loading(Loading value),
    Result deleting(Deleting value),
    Result deleteComplete(DeleteComplete value),
    Result editing(Editing value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements InfoPinState {
  const factory Error(String error) = _$Error;

  String get error;
  $ErrorCopyWith<Error> get copyWith;
}

abstract class $LoadingCopyWith<$Res> {
  factory $LoadingCopyWith(Loading value, $Res Function(Loading) then) =
      _$LoadingCopyWithImpl<$Res>;
}

class _$LoadingCopyWithImpl<$Res> extends _$InfoPinStateCopyWithImpl<$Res>
    implements $LoadingCopyWith<$Res> {
  _$LoadingCopyWithImpl(Loading _value, $Res Function(Loading) _then)
      : super(_value, (v) => _then(v as Loading));

  @override
  Loading get _value => super._value as Loading;
}

class _$Loading implements Loading {
  const _$Loading();

  @override
  String toString() {
    return 'InfoPinState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result error(String error),
    @required Result loading(),
    @required Result deleting(),
    @required Result deleteComplete(),
    @required Result editing(String text),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result error(String error),
    Result loading(),
    Result deleting(),
    Result deleteComplete(),
    Result editing(String text),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result error(Error value),
    @required Result loading(Loading value),
    @required Result deleting(Deleting value),
    @required Result deleteComplete(DeleteComplete value),
    @required Result editing(Editing value),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result error(Error value),
    Result loading(Loading value),
    Result deleting(Deleting value),
    Result deleteComplete(DeleteComplete value),
    Result editing(Editing value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements InfoPinState {
  const factory Loading() = _$Loading;
}

abstract class $DeletingCopyWith<$Res> {
  factory $DeletingCopyWith(Deleting value, $Res Function(Deleting) then) =
      _$DeletingCopyWithImpl<$Res>;
}

class _$DeletingCopyWithImpl<$Res> extends _$InfoPinStateCopyWithImpl<$Res>
    implements $DeletingCopyWith<$Res> {
  _$DeletingCopyWithImpl(Deleting _value, $Res Function(Deleting) _then)
      : super(_value, (v) => _then(v as Deleting));

  @override
  Deleting get _value => super._value as Deleting;
}

class _$Deleting implements Deleting {
  const _$Deleting();

  @override
  String toString() {
    return 'InfoPinState.deleting()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Deleting);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result error(String error),
    @required Result loading(),
    @required Result deleting(),
    @required Result deleteComplete(),
    @required Result editing(String text),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return deleting();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result error(String error),
    Result loading(),
    Result deleting(),
    Result deleteComplete(),
    Result editing(String text),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (deleting != null) {
      return deleting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result error(Error value),
    @required Result loading(Loading value),
    @required Result deleting(Deleting value),
    @required Result deleteComplete(DeleteComplete value),
    @required Result editing(Editing value),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return deleting(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result error(Error value),
    Result loading(Loading value),
    Result deleting(Deleting value),
    Result deleteComplete(DeleteComplete value),
    Result editing(Editing value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (deleting != null) {
      return deleting(this);
    }
    return orElse();
  }
}

abstract class Deleting implements InfoPinState {
  const factory Deleting() = _$Deleting;
}

abstract class $DeleteCompleteCopyWith<$Res> {
  factory $DeleteCompleteCopyWith(
          DeleteComplete value, $Res Function(DeleteComplete) then) =
      _$DeleteCompleteCopyWithImpl<$Res>;
}

class _$DeleteCompleteCopyWithImpl<$Res>
    extends _$InfoPinStateCopyWithImpl<$Res>
    implements $DeleteCompleteCopyWith<$Res> {
  _$DeleteCompleteCopyWithImpl(
      DeleteComplete _value, $Res Function(DeleteComplete) _then)
      : super(_value, (v) => _then(v as DeleteComplete));

  @override
  DeleteComplete get _value => super._value as DeleteComplete;
}

class _$DeleteComplete implements DeleteComplete {
  const _$DeleteComplete();

  @override
  String toString() {
    return 'InfoPinState.deleteComplete()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is DeleteComplete);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result error(String error),
    @required Result loading(),
    @required Result deleting(),
    @required Result deleteComplete(),
    @required Result editing(String text),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return deleteComplete();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result error(String error),
    Result loading(),
    Result deleting(),
    Result deleteComplete(),
    Result editing(String text),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (deleteComplete != null) {
      return deleteComplete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result error(Error value),
    @required Result loading(Loading value),
    @required Result deleting(Deleting value),
    @required Result deleteComplete(DeleteComplete value),
    @required Result editing(Editing value),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return deleteComplete(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result error(Error value),
    Result loading(Loading value),
    Result deleting(Deleting value),
    Result deleteComplete(DeleteComplete value),
    Result editing(Editing value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (deleteComplete != null) {
      return deleteComplete(this);
    }
    return orElse();
  }
}

abstract class DeleteComplete implements InfoPinState {
  const factory DeleteComplete() = _$DeleteComplete;
}

abstract class $EditingCopyWith<$Res> {
  factory $EditingCopyWith(Editing value, $Res Function(Editing) then) =
      _$EditingCopyWithImpl<$Res>;
  $Res call({String text});
}

class _$EditingCopyWithImpl<$Res> extends _$InfoPinStateCopyWithImpl<$Res>
    implements $EditingCopyWith<$Res> {
  _$EditingCopyWithImpl(Editing _value, $Res Function(Editing) _then)
      : super(_value, (v) => _then(v as Editing));

  @override
  Editing get _value => super._value as Editing;

  @override
  $Res call({
    Object text = freezed,
  }) {
    return _then(Editing(
      text == freezed ? _value.text : text as String,
    ));
  }
}

class _$Editing implements Editing {
  const _$Editing(this.text) : assert(text != null);

  @override
  final String text;

  @override
  String toString() {
    return 'InfoPinState.editing(text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Editing &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(text);

  @override
  $EditingCopyWith<Editing> get copyWith =>
      _$EditingCopyWithImpl<Editing>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result error(String error),
    @required Result loading(),
    @required Result deleting(),
    @required Result deleteComplete(),
    @required Result editing(String text),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return editing(text);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result error(String error),
    Result loading(),
    Result deleting(),
    Result deleteComplete(),
    Result editing(String text),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (editing != null) {
      return editing(text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result error(Error value),
    @required Result loading(Loading value),
    @required Result deleting(Deleting value),
    @required Result deleteComplete(DeleteComplete value),
    @required Result editing(Editing value),
  }) {
    assert(initial != null);
    assert(error != null);
    assert(loading != null);
    assert(deleting != null);
    assert(deleteComplete != null);
    assert(editing != null);
    return editing(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result error(Error value),
    Result loading(Loading value),
    Result deleting(Deleting value),
    Result deleteComplete(DeleteComplete value),
    Result editing(Editing value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (editing != null) {
      return editing(this);
    }
    return orElse();
  }
}

abstract class Editing implements InfoPinState {
  const factory Editing(String text) = _$Editing;

  String get text;
  $EditingCopyWith<Editing> get copyWith;
}
