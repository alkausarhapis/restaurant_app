enum ResultStatus { none, loading, success, error, noInternet }

class ResultState<T> {
  final ResultStatus status;
  final T? data;
  final String? message;

  const ResultState({required this.status, this.data, this.message});

  factory ResultState.none() => ResultState(status: ResultStatus.none);

  factory ResultState.loading() => ResultState(status: ResultStatus.loading);

  factory ResultState.success(T data) =>
      ResultState(status: ResultStatus.success, data: data);

  factory ResultState.error(String message) =>
      ResultState(status: ResultStatus.error, message: message);

  factory ResultState.noInternet() =>
      ResultState(status: ResultStatus.noInternet);

  bool get isNone => status == ResultStatus.none;
  bool get isLoading => status == ResultStatus.loading;
  bool get isSuccess => status == ResultStatus.success;
  bool get isError => status == ResultStatus.error;
  bool get isNoInternet => status == ResultStatus.noInternet;
}
