enum AuthStatus { checking, authenticated, unauthenticated }

enum UserRole { user, admin }

class AuthState {
  final AuthStatus status;
  final UserRole role;
  final String? redirectLocation;

  const AuthState({
    this.status = AuthStatus.checking,
    this.role = UserRole.user,
    this.redirectLocation,
  });

  bool get checking => status == AuthStatus.checking;
  bool get isLoggedIn => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserRole? role,
    String? redirectLocation,
  }) {
    return AuthState(
      status: status ?? this.status,
      role: role ?? this.role,
      redirectLocation: redirectLocation ?? this.redirectLocation,
    );
  }
}
