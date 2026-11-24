import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/Models/incidence_teacher_model.dart';
import 'package:Padres360/Screens/Incidences%20Dashboard%20Alumnos/IncidenceDetailStudent.dart';
import 'package:Padres360/Screens/MyIncidencesReported/Repo/myIncidencesReported_Repo.dart';
import 'package:Padres360/Screens/States/EmptyView.dart';
import 'package:Padres360/Screens/States/ErrorView.dart';
import 'package:Padres360/Screens/States/LoadingView.dart';
import 'package:Padres360/Screens/States/enum_state.dart';
import 'package:Padres360/extensions/datetime/time_ago.dart';
import 'package:flutter/material.dart';
import 'package:Padres360/constants.dart';

class MyIncidencesReportedScreen extends StatefulWidget {
  const MyIncidencesReportedScreen({super.key});

  @override
  State<MyIncidencesReportedScreen> createState() =>
      _MyIncidencesReportedScreenState();
}

class _MyIncidencesReportedScreenState
    extends State<MyIncidencesReportedScreen> {
  final MyincidencesReportedRepo _repository = MyincidencesReportedRepo();

  ListState state = ListState.loading;

  List<IncidenceTeacher> incidences = [];

  @override
  void initState() {
    super.initState();
    _loadIncidences(context: context);
  }

  Future<void> _loadIncidences({required BuildContext context}) async {
    try {
      final data = await _repository.getMyReportedIncidences(context: context);
      var user = await UserService.getUser();
      setState(() {
        incidences = data
            .where((i)=> i.createdByName == user.fullName)
            .toList();

        if (incidences.isEmpty) {
          state = ListState.empty;
        } else {
          state = ListState.loaded;
        }
      });
    } catch (e) {
      setState(() {
        state = ListState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSurfaceLight,
      appBar: AppBar(
        title: const Text("Incidencias"),
        centerTitle: true,
      ),
      body: switch (state) {
        ListState.loading => const LoadingView(),

        ListState.empty => const EmptyView(),

        ListState.error => ErrorView(
          onRetry: () {
            _loadIncidences(context: context);
          },
        ),

        ListState.loaded => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: incidences.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = incidences[index];
            return notificationItem(context, incidence: item);
          },
        ),
      },
    );
  }

  Widget notificationItem(
      BuildContext context, {
        required IncidenceTeacher incidence,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IncidenceStudentDetail(incidence: incidence),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(color: kWhite),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 24,
                  child: const Icon(
                    Icons.notifications,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                if (!(incidence.read ?? false))
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: kErrorColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: kWhite, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Nombre del alumno
                  Text(
                    incidence.studentName ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: kNeutralColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Tipo de incidencia
                  Text(
                    "${incidence.incidenceName ?? ''}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: kNeutralColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Tiempo
                  Text(
                    incidence.createdAt.timeAgo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: kGreyTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}