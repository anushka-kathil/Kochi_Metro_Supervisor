// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
//
// import '../../controllers/dashboard_controller.dart';
//
// import '../../../core/theme/app_theme.dart';
//
// import '../../../data/models/train_model.dart';
//
// class TrainStatusSection extends GetView<DashboardController> {
//   const TrainStatusSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//         const Text(
//           'Recent Train Activity',
//
//           style: TextStyle(
//             fontSize: 18,
//
//             fontWeight: FontWeight.w600,
//
//             color: AppTheme.textPrimary,
//           ),
//         ),
//
//         const SizedBox(height: 16),
//
//         Obx(
//           () => ListView.builder(
//             shrinkWrap: true,
//
//             physics: const NeverScrollableScrollPhysics(),
//
//             itemCount:
//                 (controller.availableTrains.length +
//                         controller.maintenanceTrains.length)
//                     .clamp(0, 5),
//
//             itemBuilder: (context, index) {
//               final allTrains = [
//                 ...controller.availableTrains,
//                 ...controller.maintenanceTrains,
//               ];
//
//               if (index >= allTrains.length) return const SizedBox();
//
//               final train = allTrains[index];
//
//               return _TrainStatusCard(train: train);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _TrainStatusCard extends StatelessWidget {
//   final TrainModel train;
//
//   const _TrainStatusCard({required this.train});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//
//       padding: const EdgeInsets.all(16),
//
//       decoration: BoxDecoration(
//         color: Colors.white,
//
//         borderRadius: BorderRadius.circular(12),
//
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//
//             blurRadius: 10,
//
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//
//             height: 48,
//
//             decoration: BoxDecoration(
//               color: train.isOperational
//                   ? AppTheme.successColor.withOpacity(0.1)
//                   : AppTheme.warningColor.withOpacity(0.1),
//
//               borderRadius: BorderRadius.circular(8),
//             ),
//
//             child: Icon(
//               train.isOperational ? Icons.train : Icons.build,
//
//               color: train.isOperational
//                   ? AppTheme.successColor
//                   : AppTheme.warningColor,
//
//               size: 24,
//             ),
//           ),
//
//           const SizedBox(width: 16),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//
//               children: [
//                 Text(
//                   'Train ${train.number}',
//
//                   style: const TextStyle(
//                     fontSize: 16,
//
//                     fontWeight: FontWeight.w600,
//
//                     color: AppTheme.textPrimary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 Text(
//                   train.currentLocation,
//
//                   style: const TextStyle(
//                     fontSize: 14,
//
//                     color: AppTheme.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//
//             decoration: BoxDecoration(
//               color: train.isOperational
//                   ? AppTheme.successColor
//                   : AppTheme.warningColor,
//
//               borderRadius: BorderRadius.circular(12),
//             ),
//
//             child: Text(
//               train.status,
//
//               style: const TextStyle(
//                 fontSize: 12,
//
//                 color: Colors.white,
//
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
