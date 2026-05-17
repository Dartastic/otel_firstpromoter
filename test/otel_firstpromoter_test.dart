// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_firstpromoter/otel_firstpromoter.dart';
import 'package:test/test.dart';

void main() {
  group('otel_firstpromoter', () {
    test('suppression toggles in zone', () async {
      expect(firstPromoterInstrumentationSuppressed(), isFalse);
      await runWithoutFirstPromoterInstrumentationAsync(() async {
        expect(firstPromoterInstrumentationSuppressed(), isTrue);
      });
      expect(firstPromoterInstrumentationSuppressed(), isFalse);
    });

    test('FirstPromoterResult fields default null', () {
      const r = FirstPromoterResult();
      expect(r.statusCode, isNull);
    });
  });
}
