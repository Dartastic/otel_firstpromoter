// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_firstpromoter/otel_firstpromoter.dart';

/// Traces Firstpromoter calls with OpenTelemetry.
///
/// `otel_firstpromoter` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Firstpromoter call in
/// [tracedFirstPromoter]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'firstpromoter-example');

  // Traces a Firstpromoter call.
  final firstPromoterId = await tracedFirstPromoter<String>(
    operation: 'create',
    invoke: () async {
      // Make the Firstpromoter call here, then report what it returned.
      const id = 'firstpromoter_8f3a2c';
      return const FirstPromoterCallResult(
          value: id,
          result: FirstPromoterResult(
              companyId: 'company_8f3a2c',
              promoterId: 'promoter_8f3a2c',
              campaignId: 'campaign_8f3a2c',
              referralId: 'referral_8f3a2c',
              status: 'succeeded',
              commissionAmount: 0.5,
              currency: 'usd',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedFirstPromoter create returned $firstPromoterId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutFirstPromoterInstrumentationAsync.
  await runWithoutFirstPromoterInstrumentationAsync(
    () => tracedFirstPromoter<String>(
      operation: 'create',
      invoke: () async {
        const id = 'firstpromoter_8f3a2c';
        return const FirstPromoterCallResult(
            value: id,
            result: FirstPromoterResult(
                companyId: 'company_8f3a2c',
                promoterId: 'promoter_8f3a2c',
                campaignId: 'campaign_8f3a2c',
                referralId: 'referral_8f3a2c',
                status: 'succeeded',
                commissionAmount: 0.5,
                currency: 'usd',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
