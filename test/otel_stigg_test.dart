// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
