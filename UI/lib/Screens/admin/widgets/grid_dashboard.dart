import 'package:flutter/material.dart';
import 'package:garbageClassification/common/constants/appSizes.dart';
import 'package:garbageClassification/router/app_router.dart';
import 'package:garbageClassification/widgets/rounded_container.dart';

class GridDashboard extends StatelessWidget {
  const GridDashboard(
      {super.key,
      required this.revenueQuantity,
      required this.gameQuantity,
      required this.vipUserQuantity,
      required this.userQuantity});

  final int revenueQuantity;
  final int gameQuantity;
  final int vipUserQuantity;
  final int userQuantity;

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> dashboardItems = [
      _DashboardItem(
          icon: Icons.shopping_cart,
          label: 'Doanh thu',
          count: '${revenueQuantity.toString()} \$',
          color: Colors.blueAccent,
          route: () {
            Navigator.pushNamed(
              context,
              AppRouter.revenue,
            );
          }),
      _DashboardItem(
          icon: Icons.supervised_user_circle_outlined,
          label: 'Người dùng thường',
          count: userQuantity.toString(),
          color: Colors.orangeAccent,
          route: () {
            Navigator.pushNamed(
              context,
              AppRouter.userNormal,
            );
          }),
      _DashboardItem(
          icon: Icons.verified_sharp,
          label: 'Người dùng VIP',
          count: vipUserQuantity.toString(),
          color: Colors.green,
          route: () {
            Navigator.pushNamed(
              context,
              AppRouter.userVip,
            );
          }),
      _DashboardItem(
          icon: Icons.games,
          label: 'Trò chơi',
          count: gameQuantity.toString(),
          color: Colors.deepPurple,
          route: () {}),
    ];
    return GridView.builder(
      itemCount: dashboardItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.spaceBtwItems,
        crossAxisSpacing: AppSizes.spaceBtwItems,
        mainAxisExtent: 180,
      ),
      itemBuilder: (_, index) {
        final item = dashboardItems[index];
        return GestureDetector(
          onTap: item.route,
          child: RoundedContainer(
            backgroundColor: item.color.withOpacity(0.1),
            showBorder: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 40, color: item.color),
                const SizedBox(height: 10),
                Text(item.label,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(item.count,
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardItem {
  final IconData icon;
  final String label;
  final String count;
  final Color color;
  final VoidCallback route; // Nullable

  _DashboardItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.route, // Optional
  });
}
