class AppBootstrapState {
  final bool loading;
  final bool ready;
  final String? error;

  const AppBootstrapState({
    this.loading = false,
    this.ready = false,
    this.error,
  });

  AppBootstrapState copyWith({bool? loading, bool? ready, String? error}) {
    return AppBootstrapState(
      loading: loading ?? this.loading,
      ready: ready ?? this.ready,
      error: error,
    );
  }
}
