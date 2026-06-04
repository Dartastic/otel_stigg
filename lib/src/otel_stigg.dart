// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_stigg_suppression.dart';

class StiggResult {
  const StiggResult({
    this.environmentId,
    this.productId,
    this.planId,
    this.customerId,
    this.subscriptionId,
    this.featureId,
    this.usageAmount,
    this.limitAmount,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? environmentId;
  final String? productId;
  final String? planId;
  final String? customerId;
  final String? subscriptionId;
  final String? featureId;
  final double? usageAmount;
  final double? limitAmount;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class StiggCallResult<T> {
  const StiggCallResult({required this.value, this.result});
  final T value;
  final StiggResult? result;
}

Future<T> tracedStigg<T>({
  required String operation,
  required Future<StiggCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (stiggInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_stigg');
  final span = t.startSpan('stigg $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'stigg')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.environmentId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('stigg.environment.id', res.environmentId!)
        ]));
      }
      if (res.productId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('stigg.product.id', res.productId!)]));
      }
      if (res.planId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('stigg.plan.id', res.planId!)]));
      }
      if (res.customerId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('stigg.customer.id', res.customerId!)]));
      }
      if (res.subscriptionId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('stigg.subscription.id', res.subscriptionId!)
        ]));
      }
      if (res.featureId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('stigg.feature.id', res.featureId!)]));
      }
      if (res.usageAmount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeDouble('stigg.usage.amount', res.usageAmount!)]));
      }
      if (res.limitAmount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeDouble('stigg.limit.amount', res.limitAmount!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('stigg.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
            res.errorCode ?? 'stigg.error',
          )
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
