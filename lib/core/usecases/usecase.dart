// Generic UseCase interface
// Since we don't have dartz yet, we use dynamic or a simple Result wrapper.
// For now, let's just define the structure.

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
