// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_stigg/otel_stigg.dart';
import 'package:test/test.dart';

void main() {
  group('otel_stigg', () {
    test('suppression toggles in zone', () async {
      expect(stiggInstrumentationSuppressed(), isFalse);
      await runWithoutStiggInstrumentationAsync(() async {
        expect(stiggInstrumentationSuppressed(), isTrue);
      });
      expect(stiggInstrumentationSuppressed(), isFalse);
    });

    test('StiggResult fields default null', () {
      const r = StiggResult();
      expect(r.statusCode, isNull);
    });
  });
}
