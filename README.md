# otel_stigg

Dartastic OpenTelemetry bridge for Stigg (usage-based billing + entitlements).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_stigg/otel_stigg.dart';

await tracedStigg<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return StiggCallResult(value: r, result: StiggResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutStiggInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
