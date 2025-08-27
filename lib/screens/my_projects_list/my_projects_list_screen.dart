import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProjectsListScreen extends ConsumerWidget {
  const MyProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(allMyProjectsProvider);

    return Scaffold(
      appBar: const ScreenHeader(
        title: 'مشاريعي وطلباتي',
        showBackButton: false,
      ),
      body: projects.when(
        data: (projectList) {
          if (projectList.isEmpty) {
            return const Center(child: Text('لا توجد مشاريع أو طلبات حالياً.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: projectList.length,
            itemBuilder: (context, index) {
              final project = projectList[index];
              return ProjectCard(
                project: project,
                onTap: () {
                  // TODO: Navigate to project details
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('حدث خطأ أثناء تحميل المشاريع')),
      ),
    );
  }
}
