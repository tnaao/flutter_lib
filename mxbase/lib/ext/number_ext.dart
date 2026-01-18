part of 'common.dart';

extension CalExt on num {
  StreamSubscription interval(Function(int millis) task) {
    final int ms = toDouble().toInt();
    final s1 = Stream.periodic(Duration(milliseconds: ms), (e) => e * ms);
    return s1.listen((c) {
      task(c);
    });
  }

  Future<bool> waitForTrue(
    bool Function() checkFunction, {
    Duration checkInterval =
        const Duration(milliseconds: 300), // Interval between checks
  }) async {
    final Duration timeout = Duration(milliseconds: toInt());
    final stopwatch = Stopwatch()..start(); // Start a stopwatch to track time
    while (stopwatch.elapsed < timeout) {
      try {
        if (checkFunction()) {
          // Await the result of the checkFunction
          return true; // Function returned true, we're done!
        }
      } catch (e) {
        // You might want to return false or re-throw the error depending on your needs
        return false; // Or throw e;
      }

      await Future.delayed(
          checkInterval); // Wait for the interval before checking again
    }

    stopwatch.stop(); // Stop the stopwatch

    return false; // Timeout reached, function never returned true within the time limit
  }

  StreamSubscription counter(Duration interval, Function(int i) task,
      {bool callOI = false}) {
    final seeds = List.generate(toInt(), (e) => e);
    final stream = Stream.fromIterable(seeds).interval(interval).timeInterval();
    stream.doOnCancel(() {
      seeds.clear();
    });
    if (callOI) {
      task(0);
    }
    return stream.listen((i) {
      task(i.value);
    });
  }
}
