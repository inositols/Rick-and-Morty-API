import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// EVENTS
abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final List<ConnectivityResult> results;
  const ConnectivityChanged(this.results);
  @override
  List<Object> get props => [results];
}

// STATES
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {}

class ConnectivityDisconnected extends ConnectivityState {}

// BLOC
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription? _subscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<ConnectivityChanged>((event, emit) {
      if (event.results.contains(ConnectivityResult.none)) {
        emit(ConnectivityDisconnected());
      } else {
        emit(ConnectivityConnected());
      }
    });

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      add(ConnectivityChanged(results));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
