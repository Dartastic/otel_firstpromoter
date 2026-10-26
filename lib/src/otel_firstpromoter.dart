// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_firstpromoter_suppression.dart';

class FirstPromoterResult {
  /// Creates a result.
  const FirstPromoterResult({
    this.companyId,
    this.promoterId,
    this.campaignId,
    this.referralId,
    this.status,
    this.commissionAmount,
    this.currency,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? companyId;
  final String? promoterId;
  final String? campaignId;
  final String? referralId;
  final String? status;
  final double? commissionAmount;
  final String? currency;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class FirstPromoterCallResult<T> {
  /// Creates a call result.
  const FirstPromoterCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final FirstPromoterResult? result;
}

Future<T> tracedFirstPromoter<T>({
  required String operation,
  required Future<FirstPromoterCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (firstPromoterInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_firstpromoter');
  final span = t.startSpan('firstpromoter $operation', kind: SpanKind.client);
  try {
    span.addAttributes(OTelAPI.attributes(
        [OTelAPI.attributeString('rpc.system', 'firstpromoter')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.companyId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('firstpromoter.company.id', res.companyId!)
        ]));
      }
      if (res.promoterId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('firstpromoter.promoter.id', res.promoterId!)
        ]));
      }
      if (res.campaignId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('firstpromoter.campaign.id', res.campaignId!)
        ]));
      }
      if (res.referralId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('firstpromoter.referral.id', res.referralId!)
        ]));
      }
      if (res.status != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('firstpromoter.status', res.status!)]));
      }
      if (res.commissionAmount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeDouble(
            'firstpromoter.commission.amount',
            res.commissionAmount!,
          )
        ]));
      }
      if (res.currency != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('firstpromoter.currency', res.currency!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('firstpromoter.error.code', res.errorCode!)
        ]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
            ErrorAttributes.errorType.key,
            res.errorCode ?? 'firstpromoter.error',
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
