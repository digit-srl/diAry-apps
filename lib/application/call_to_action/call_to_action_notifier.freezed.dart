// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'call_to_action_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$CallToActionStateTearOff {
  const _$CallToActionStateTearOff();

  Initial initial() {
    return const Initial();
  }

  Loading loading() {
    return const Loading();
  }

  Error error([String message]) {
    return Error(
      message,
    );
  }

  CallResult callResult(List<Call> calls) {
    return CallResult(
      calls,
    );
  }
}

// ignore: unused_element
const $CallToActionState = _$CallToActionStateTearOff();

mixin _$CallToActionState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result loading(),
    @required Result error(String message),
    @required Result callResult(List<Call> calls),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result loading(),
    Result error(String message),
    Result callResult(List<Call> calls),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result loading(Loading value),
    @required Result error(Error value),
    @required Result callResult(CallResult value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result loading(Loading value),
    Result error(Error value),
    Result callResult(CallResult value),
    @required Result orElse(),
  });
}

abstract class $CallToActionStateCopyWith<$Res> {
  factory $CallToActionStateCopyWith(
          CallToActionState value, $Res Function(CallToActionState) then) =
      _$CallToActionStateCopyWithImpl<$Res>;
}

class _$CallToActionStateCopyWithImpl<$Res>
    implements $CallToActionStateCopyWith<$Res> {
  _$CallToActionStateCopyWithImpl(this._value, this._then);

  final CallToActionState _value;
  // ignore: unused_field
  final $Res Function(CallToActionState) _then;
}

abstract class $InitialCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) then) =
      _$InitialCopyWithImpl<$Res>;
}

class _$InitialCopyWithImpl<$Res> extends _$CallToActionStateCopyWithImpl<$Res>
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
    return 'CallToActionState.initial()';
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
    @required Result loading(),
    @required Result error(String message),
    @required Result callResult(List<Call> calls),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result loading(),
    Result error(String message),
    Result callResult(List<Call> calls),
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
    @required Result loading(Loading value),
    @required Result error(Error value),
    @required Result callResult(CallResult value),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result loading(Loading value),
    Result error(Error value),
    Result callResult(CallResult value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements CallToActionState {
  const factory Initial() = _$Initial;
}

abstract class $LoadingCopyWith<$Res> {
  factory $LoadingCopyWith(Loading value, $Res Function(Loading) then) =
      _$LoadingCopyWithImpl<$Res>;
}

class _$LoadingCopyWithImpl<$Res> extends _$CallToActionStateCopyWithImpl<$Res>
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
    return 'CallToActionState.loading()';
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
    @required Result loading(),
    @required Result error(String message),
    @required Result callResult(List<Call> calls),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result loading(),
    Result error(String message),
    Result callResult(List<Call> calls),
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
    @required Result loading(Loading value),
    @required Result error(Error value),
    @required Result callResult(CallResult value),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result loading(Loading value),
    Result error(Error value),
    Result callResult(CallResult value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements CallToActionState {
  const factory Loading() = _$Loading;
}

abstract class $ErrorCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) then) =
      _$ErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

class _$ErrorCopyWithImpl<$Res> extends _$CallToActionStateCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(Error _value, $Res Function(Error) _then)
      : super(_value, (v) => _then(v as Error));

  @override
  Error get _value => super._value as Error;

  @override
  $Res call({
    Object message = freezed,
  }) {
    return _then(Error(
      message == freezed ? _value.message : message as String,
    ));
  }
}

class _$Error implements Error {
  const _$Error([this.message]);

  @override
  final String message;

  @override
  String toString() {
    return 'CallToActionState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Error &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(message);

  @override
  $ErrorCopyWith<Error> get copyWith =>
      _$ErrorCopyWithImpl<Error>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result loading(),
    @required Result error(String message),
    @required Result callResult(List<Call> calls),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return error(message);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result loading(),
    Result error(String message),
    Result callResult(List<Call> calls),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result loading(Loading value),
    @required Result error(Error value),
    @required Result callResult(CallResult value),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result loading(Loading value),
    Result error(Error value),
    Result callResult(CallResult value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements CallToActionState {
  const factory Error([String message]) = _$Error;

  String get message;
  $ErrorCopyWith<Error> get copyWith;
}

abstract class $CallResultCopyWith<$Res> {
  factory $CallResultCopyWith(
          CallResult value, $Res Function(CallResult) then) =
      _$CallResultCopyWithImpl<$Res>;
  $Res call({List<Call> calls});
}

class _$CallResultCopyWithImpl<$Res>
    extends _$CallToActionStateCopyWithImpl<$Res>
    implements $CallResultCopyWith<$Res> {
  _$CallResultCopyWithImpl(CallResult _value, $Res Function(CallResult) _then)
      : super(_value, (v) => _then(v as CallResult));

  @override
  CallResult get _value => super._value as CallResult;

  @override
  $Res call({
    Object calls = freezed,
  }) {
    return _then(CallResult(
      calls == freezed ? _value.calls : calls as List<Call>,
    ));
  }
}

class _$CallResult implements CallResult {
  const _$CallResult(this.calls) : assert(calls != null);

  @override
  final List<Call> calls;

  @override
  String toString() {
    return 'CallToActionState.callResult(calls: $calls)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is CallResult &&
            (identical(other.calls, calls) ||
                const DeepCollectionEquality().equals(other.calls, calls)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(calls);

  @override
  $CallResultCopyWith<CallResult> get copyWith =>
      _$CallResultCopyWithImpl<CallResult>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result loading(),
    @required Result error(String message),
    @required Result callResult(List<Call> calls),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return callResult(calls);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result loading(),
    Result error(String message),
    Result callResult(List<Call> calls),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (callResult != null) {
      return callResult(calls);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial value),
    @required Result loading(Loading value),
    @required Result error(Error value),
    @required Result callResult(CallResult value),
  }) {
    assert(initial != null);
    assert(loading != null);
    assert(error != null);
    assert(callResult != null);
    return callResult(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial value),
    Result loading(Loading value),
    Result error(Error value),
    Result callResult(CallResult value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (callResult != null) {
      return callResult(this);
    }
    return orElse();
  }
}

abstract class CallResult implements CallToActionState {
  const factory CallResult(List<Call> calls) = _$CallResult;

  List<Call> get calls;
  $CallResultCopyWith<CallResult> get copyWith;
}
