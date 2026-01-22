class MSSingletonClass {
  static final MSSingletonClass instance = MSSingletonClass._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory MSSingletonClass() => instance;

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  MSSingletonClass._internal() {
    // initialization logic
  }
}
