abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  // final StreamController _inputStreamController = BehaviorSubject<FlowState>();

  @override
  void dispose();
}

abstract class BaseViewModelInputs {
  void start();

  void dispose();
  // Sink get inputState;
}

abstract class BaseViewModelOutputs {
//  Stream<FlowState> get outState;
}
