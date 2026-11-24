import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/Models/incidence_teacher_model.dart';
import 'package:Padres360/Screens/Incidences%20Dashboard%20Alumnos/IncidenceDetailStudent.dart';
import 'package:Padres360/extensions/datetime/time_ago.dart';
import 'package:flutter/material.dart';
import 'package:Padres360/constants.dart';

class AllIncidencesStudentScreen extends StatelessWidget {
  final List<IncidenceTeacher> incidences;

  const AllIncidencesStudentScreen({super.key, required this.incidences});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSurfaceLight,
      appBar: AppBar(title: Text("Incidencias")),
      body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: incidences.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = incidences[index];
            return notificationItem(context, incidence: item);
          },
        ),
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
                  child: Icon(
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
                  Text(
                    incidence.incidenceToShow ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: kNeutralColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    incidence.createdAt.timeAgo,
                    style: const TextStyle(fontSize: 13, color: kGreyTextColor),
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
