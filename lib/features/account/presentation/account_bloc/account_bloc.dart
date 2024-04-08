import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
    on<AccountRefreshAccountDetailsEvent>(_onRefreshAccountDetails);
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
      case (final ApiRepositoryFailure failure, null):
        return emit(AccountFailureState(failure: failure));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetAccountId();
    switch (sessionDataRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(AccountFailureState(failure: failure));
      case (null, final int resAccountId):
        accountId = resAccountId;
    }

    AccountRepositoryPattern accountRepositoryPattern =
        await _accountRepository.onGetAccountDetails(
      accountId: accountId!,
      sessionId: sessionId!,
    );

    switch (accountRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(AccountFailureState(failure: failure));
      case (null, final AccountModel resAccountModel):
        return emit(AccountLoadedState(account: resAccountModel));
    }
  }

  Future<void> _onRefreshAccountDetails(
    AccountRefreshAccountDetailsEvent event,
    Emitter<AccountState> emit,
  ) async {
    add(AccountLoadAccountDetailsEvent());
    event.refreshController.refreshCompleted();
  }
}
