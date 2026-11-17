import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/theme/doory_typography.dart';
import '../../data/models/catalog_models.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/repo_result.dart';

class ApiStatusScreen extends ConsumerStatefulWidget {
  const ApiStatusScreen({super.key});

  @override
  ConsumerState<ApiStatusScreen> createState() => _ApiStatusScreenState();
}

class _ApiStatusScreenState extends ConsumerState<ApiStatusScreen> {
  bool _loading = true;
  int? _latencyMs;
  HealthReport? _report;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_check);
  }

  Future<void> _check() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final watch = Stopwatch()..start();
    final result = await ref.read(metaRepositoryProvider).health();
    watch.stop();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _latencyMs = watch.elapsedMilliseconds;
      switch (result) {
        case RepoOk<HealthReport>(:final data):
          _report = data;
          _error = null;
        case RepoUnavailable<HealthReport>(:final message):
          _report = null;
          _error = message ?? DooryStrings.unavailable;
        case RepoRejected<HealthReport>(:final message):
          _report = null;
          _error = message;
        case RepoNotFound<HealthReport>():
          _report = null;
          _error = DooryStrings.healthFail;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.apiStatus)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          _row(context, DooryStrings.flavorLabel, config.flavor.label),
          _row(
            context,
            DooryStrings.baseUrl,
            config.baseUrl.isEmpty ? '—' : config.baseUrl,
          ),
          _row(
            context,
            DooryStrings.timeoutLabel,
            DooryStrings.milliseconds(config.timeout.inMilliseconds),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text(DooryStrings.statusChecking),
              ],
            )
          else ...[
            _row(
              context,
              DooryStrings.healthOk,
              _report?.ok == true
                  ? DooryStrings.healthOk
                  : DooryStrings.healthFail,
            ),
            if (_latencyMs != null)
              _row(
                context,
                DooryStrings.latency,
                DooryStrings.milliseconds(_latencyMs!),
              ),
            if (_report?.requestId != null)
              _row(context, 'request id', _report!.requestId!),
            if (_report?.platformVersion != null)
              _row(context, 'platform', _report!.platformVersion!),
            if (_error != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8),
                child: Text(_error!, style: DooryTypography.body(context)),
              ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _check,
            child: const Text(DooryStrings.checkConnection),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: DooryTypography.label(context)),
          const SizedBox(height: 2),
          Text(value, style: DooryTypography.body(context)),
        ],
      ),
    );
  }
}
