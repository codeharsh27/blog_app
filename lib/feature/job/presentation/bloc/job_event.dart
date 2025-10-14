import 'package:equatable/equatable.dart';

abstract class JobEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchJobs extends JobEvent {
  final bool refresh;
  final String? query;
  FetchJobs({this.refresh = false, this.query});
  @override List<Object?> get props => [refresh, query];
}

class FetchMoreJobs extends JobEvent {}
