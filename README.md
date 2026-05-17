# otel_firstpromoter

Dartastic OpenTelemetry bridge for FirstPromoter (affiliate / referral).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_firstpromoter/otel_firstpromoter.dart';

await tracedFirstPromoter<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return FirstPromoterCallResult(value: r, result: FirstPromoterResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutFirstPromoterInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
