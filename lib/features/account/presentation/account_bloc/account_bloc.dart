import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  late final SessionDataRepository _sessionDataRepository;
  late final AccountRepository _accountRepository;

  AccountBloc({
    required SessionDataRepository sessionDataRepository,
    required AccountRepository accountRepository,
  })  : _sessionDataRepository = sessionDataRepository,
        _accountRepository = accountRepository,
        super(AccountState()) {
    on<AccountLoadAccountDetailsEvent>(_onLoadProfileInfo);
  }

  Future<void> _onLoadProfileInfo(
    AccountLoadAccountDetailsEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoadingState());

    String? sessionId;
    int? accountId;

    SessionDataRepositoryPattern sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepositoryPattern) {
      case (final RepositoryFailure failure, null):
        return emit(AccountFailureState(failure: failure));
      case (null, final String patternSessionId):
        sessionId = patternSessionId;
    }

    sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetAccountId();
    switch (sessionDataRepositoryPattern) {
      case (final RepositoryFailure failure, null):
        return emit(AccountFailureState(failure: failure));
      case (null, final int patternAccountId):
        accountId = patternAccountId;
    }

    AccountRepositoryPattern accountRepositoryPattern =
        await _accountRepository.onGetAccountDetails(
      accountId: accountId!,
      sessionId: sessionId!,
    );

    switch (accountRepositoryPattern) {
      case (final RepositoryFailure failure, null):
        return emit(AccountFailureState(failure: failure));
      case (null, final AccountModel account):
        return emit(AccountLoadedState(account: account));
    }
  }
}
