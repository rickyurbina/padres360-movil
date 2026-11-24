import 'package:Padres360/Const/states.dart';
import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/Notification/Repo/notification_repo.dart';
import 'package:Padres360/providers/badge_provider.dart';
import 'package:flutter/material.dart';
import 'package:Padres360/Screens/Notification/Model/notification_incidence.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationDetailScreen extends ConsumerStatefulWidget {
  final int idIncidence;

  const NotificationDetailScreen({super.key, required this.idIncidence});

  @override
  ConsumerState<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends ConsumerState<NotificationDetailScreen> {
  ViewState _state = ViewState.loading;
  late final NotificationRepository _notificationRepository;
  NotificationIncidence? _incidence;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _notificationRepository = NotificationRepository();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _state = ViewState.loading;
      _errorMessage = null;
    });

    try {
      final incidence = await _notificationRepository.getById(
        context: context,
        id: widget.idIncidence,
      );

      if (!mounted) return;

      setState(() {
        _incidence = incidence;
        _state = ViewState.loaded;
      });

      await _markAsReadOnOpen();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _state = ViewState.error;
        _errorMessage = 'Error al cargar la incidencia: ${e.toString()}';
      });
      debugPrint("❌ Error cargando incidencia: $e");
    }
  }

  Future<void> _markAsReadOnOpen() async {
    if (_incidence?.read == true || _incidence == null) return;

    try {
      final wasMarked = await _notificationRepository.markAsReadNotification(
        context: context,
        incidence: _incidence!,
      );

      if (!mounted) return;

      if (wasMarked) {
        ref.read(badgeProvider.notifier).decrement();
        setState(() {
          _incidence?.read = true;
        });
      }
    } catch (e) {
      debugPrint("❌ Error marcando como leída: $e");
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Fecha no disponible';
    final localTime = date.isUtc ? date.toLocal() : date;

    return '${localTime.day.toString().padLeft(2, '0')}/${localTime.month.toString().padLeft(2, '0')}/${localTime.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    final localTime = date.isUtc ? date.toLocal() : date;

    return '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getIncidenceColor(String? incidenceName) {
    final name = incidenceName?.toLowerCase() ?? '';

    if (name.contains('falta') || name.contains('grave')) {
      return Colors.red.shade600;
    } else if (name.contains('tardanza') || name.contains('retardo')) {
      return Colors.orange.shade600;
    } else if (name.contains('advertencia') || name.contains('observación')) {
      return Colors.amber.shade700;
    } else if (name.contains('felicitación') ||
        name.contains('reconocimiento')) {
      return Colors.green.shade600;
    }
    return Colors.blue.shade600;
  }

  IconData _getIncidenceIcon(String? incidenceName) {
    final name = incidenceName?.toLowerCase() ?? '';

    if (name.contains('falta')) return Icons.warning_rounded;
    if (name.contains('tardanza')) return Icons.access_time_rounded;
    if (name.contains('comportamiento')) return Icons.psychology_rounded;
    if (name.contains('tarea')) return Icons.assignment_rounded;
    if (name.contains('material')) return Icons.school_rounded;
    if (name.contains('felicitación')) return Icons.star_rounded;
    return Icons.notifications_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _incidence?.read ?? false);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(
          title: const Text('Detalle de Incidencia'),
          elevation: 0,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case ViewState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case ViewState.error:
        return _buildErrorView();
      case ViewState.loaded:
        return _buildSuccessView();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Ocurrió un error inesperado',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    if (_incidence == null) {
      return const Center(child: Text('No se encontró la incidencia'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMainCardFromSketch(),
        ],
      ),
    );
  }
  Widget _buildMainCardFromSketch() {
    final date = _incidence?.createdAt;
    final observation = _incidence?.observation ?? '';
    final isRead = _incidence?.read ?? false;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER: ícono + texto Incidencia + check ----------
            Row(
              children: [
                // Ícono izquierda
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getIncidenceColor(_incidence?.incidenceName),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIncidenceIcon(_incidence?.incidenceName),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Nombre de la incidencia
                Expanded(
                  child: Text(
                    _incidence?.incidenceName ?? 'Incidencia',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Check de leído
                Icon(
                  isRead ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isRead ? Colors.green : Colors.grey,
                  size: 22,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ---------- FECHA ----------
            Text(
              "${_formatDate(date)} a las ${_formatTime(date)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // ---------- NOMBRE DEL ESTUDIANTE ----------
            Text(
              _incidence?.createdBy ?? "",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // ---------- OBSERVACIÓN ----------
            const Text(
              "Observación:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade200,
                ),
              ),
              child: Text(
                observation.isEmpty ? "Sin observación" : observation,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}