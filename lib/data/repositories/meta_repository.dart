import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_transport.dart';
import '../models/buyer_dto.dart';
import '../models/catalog_models.dart';
import 'repo_result.dart';

class MetaRepository {
  MetaRepository(this._transport, this._config);

  final ApiTransport _transport;
  final AppConfig _config;

  Future<RepoResult<HealthReport>> health({CancelToken? cancelToken}) {
    return runRequest<HealthReport>(
      hasBaseUrl: _config.hasBaseUrl,
      request: () async {
        final raw = await _transport.get('/health', cancelToken: cancelToken);
        if (raw is! Map) throw const FormatException('health');
        return mapHealth(HealthDto.fromJson(Map<String, dynamic>.from(raw)));
      },
    );
  }

  Future<RepoResult<ServiceStatus>> status({CancelToken? cancelToken}) {
    return runRequest<ServiceStatus>(
      hasBaseUrl: _config.hasBaseUrl,
      request: () async {
        final raw = await _transport.get(
          '/meta/status',
          cancelToken: cancelToken,
        );
        if (raw is! Map) throw const FormatException('status');
        return mapStatus(
          MetaStatusDto.fromJson(Map<String, dynamic>.from(raw)),
        );
      },
    );
  }

  Future<RepoResult<List<CityModel>>> cities({CancelToken? cancelToken}) {
    return runRequest<List<CityModel>>(
      hasBaseUrl: _config.hasBaseUrl,
      request: () async {
        final raw = await _transport.get('/cities', cancelToken: cancelToken);
        return [
          for (final dto in decodeCityList(raw))
            if (mapCity(dto) case final city?) city,
        ];
      },
    );
  }
}
