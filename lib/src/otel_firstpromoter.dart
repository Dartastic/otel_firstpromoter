// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

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
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'firstpromoter')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.companyId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firstpromoter.company.id', res.companyId!)
        ]));
      }
      if (res.promoterId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firstpromoter.promoter.id', res.promoterId!)
        ]));
      }
      if (res.campaignId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firstpromoter.campaign.id', res.campaignId!)
        ]));
      }
      if (res.referralId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firstpromoter.referral.id', res.referralId!)
        ]));
      }
      if (res.status != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('firstpromoter.status', res.status!)]));
      }
      if (res.commissionAmount != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeDouble(
            'firstpromoter.commission.amount',
            res.commissionAmount!,
          )
        ]));
      }
      if (res.currency != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('firstpromoter.currency', res.currency!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firstpromoter.error.code', res.errorCode!)
        ]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
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
