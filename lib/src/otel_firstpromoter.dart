// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_firstpromoter_suppression.dart';

class FirstPromoterResult {
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

class FirstPromoterCallResult<T> {
  const FirstPromoterCallResult({required this.value, this.result});
  final T value;
  final FirstPromoterResult? result;
}

Future<T> tracedFirstPromoter<T>({
  required String operation,
  required Future<FirstPromoterCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (firstPromoterInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_firstpromoter');
  final span = t.startSpan('firstpromoter $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'firstpromoter');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.companyId != null) {
        span.setStringAttribute('firstpromoter.company.id', res.companyId!);
      }
      if (res.promoterId != null) {
        span.setStringAttribute('firstpromoter.promoter.id', res.promoterId!);
      }
      if (res.campaignId != null) {
        span.setStringAttribute('firstpromoter.campaign.id', res.campaignId!);
      }
      if (res.referralId != null) {
        span.setStringAttribute('firstpromoter.referral.id', res.referralId!);
      }
      if (res.status != null) {
        span.setStringAttribute('firstpromoter.status', res.status!);
      }
      if (res.commissionAmount != null) {
        span.setDoubleAttribute(
          'firstpromoter.commission.amount',
          res.commissionAmount!,
        );
      }
      if (res.currency != null) {
        span.setStringAttribute('firstpromoter.currency', res.currency!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('firstpromoter.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'firstpromoter.error',
        );
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
