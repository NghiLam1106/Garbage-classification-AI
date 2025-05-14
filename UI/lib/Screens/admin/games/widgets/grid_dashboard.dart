import 'package:flutter/material.dart';
import 'package:garbageClassification/common/constants/appSizes.dart';
import 'package:garbageClassification/widgets/rounded_container.dart';

class GridDashboard extends StatelessWidget {
  const GridDashboard({
    super.key,
    required this.orderQuantity,
    required this.productQuantity,
    required this.brandQuantity,
    required this.categoriesQuantity
  });

  final int orderQuantity;
  final int productQuantity;
  final int brandQuantity;
  final int categoriesQuantity;

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> _dashboardItems = [
      _DashboardItem(
        icon: Icons.shopping_cart,
        label: 'Doanh thu',
        count: orderQuantity.toString(),
        color: Colors.blueAccent,
      ),
      _DashboardItem(
        icon: Icons.supervised_user_circle_outlined,
        label: 'Người dùng',
        count: categoriesQuantity.toString(),
        color: Colors.orangeAccent,
      ),
      _DashboardItem(
        icon: Icons.verified_sharp,
        label: 'Người dùng VIP',
        count: brandQuantity.toString(),
        color: Colors.green,
      ),
      _DashboardItem(
        icon: Icons.games,
        label: 'Trò chơi',
        count: productQuantity.toString(),
        color: Colors.deepPurple,
      ),
    ];
    return GridView.builder(
      itemCount: _dashboardItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.spaceBtwItems,
        crossAxisSpacing: AppSizes.spaceBtwItems,
        mainAxisExtent: 130,
      ),
      itemBuilder: (_, index) {
        final item = _dashboardItems[index];
        return GestureDetector(
          onTap: (){},
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

  _DashboardItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });
}