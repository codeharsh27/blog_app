import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class Usecase<SuccesType, Params>{
  Future<Either<Failure,SuccesType>> call(Params params);
}

class NoParams{

}
