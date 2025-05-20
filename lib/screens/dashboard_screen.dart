import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pani_express/blocs/auth/auth_bloc.dart';
import 'package:pani_express/blocs/auth/auth_event.dart';
import 'package:pani_express/blocs/auth/auth_state.dart';
import 'package:pani_express/utils/app_routes.dart';
import 'package:pani_express/widgets/order_card.dart';
import 'package:pani_express/widgets/product_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const _HomeTab(),
    const _OrdersTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          // User logged out, navigate to login
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.phoneLogin,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () {
                  // TODO: Implement order creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Creating new order...')),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: const Text('Order Now'),
                icon: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

// Home Tab
class _HomeTab extends StatelessWidget {
  const _HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header with greeting and profile image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.fullName.split(' ').first ?? 'User'}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'What would you like to order today?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to profile
                          Navigator.pushNamed(context, AppRoutes.profile);
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Water delivery banner
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Opacity(
                            opacity: 0.2,
                            child: Icon(
                              Icons.water_drop,
                              size: 150,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pure Drinking Water',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Fast delivery to your doorstep',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement subscription
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ),
                                child: const Text('Subscribe Now'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Popular products
                  Text(
                    'Popular Products',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Products grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: const [
                      ProductCard(
                        name: '20L Water Jar',
                        price: 60.0,
                        imageAsset: 'assets/images/water_jar.png',
                      ),
                      ProductCard(
                        name: '1L Water Bottle',
                        price: 20.0,
                        imageAsset: 'assets/images/water_bottle.png',
                      ),
                      ProductCard(
                        name: '10L Water Can',
                        price: 40.0,
                        imageAsset: 'assets/images/water_can.png',
                      ),
                      ProductCard(
                        name: '2L Water Bottle',
                        price: 30.0,
                        imageAsset: 'assets/images/small_bottle.png',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Recent orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          // setState(() {
                          //   _currentIndex = 1; // Switch to Orders tab
                          // });
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mock recent orders
                  const OrderCard(
                    orderNumber: 'ORD-3845',
                    date: 'Today, 10:30 AM',
                    status: 'Delivered',
                    items: '1x 20L Water Jar',
                    amount: 60.0,
                  ),
                  const SizedBox(height: 12),
                  const OrderCard(
                    orderNumber: 'ORD-3844',
                    date: 'Yesterday, 2:15 PM',
                    status: 'Delivered',
                    items: '2x 1L Water Bottle',
                    amount: 40.0,
                  ),

                  const SizedBox(height: 80), // Extra space for FAB
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Orders Tab
class _OrdersTab extends StatelessWidget {
  const _OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'My Orders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),

          // Order filtering tabs
          Container(
            height: 50,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Active'),
                      Tab(text: 'Completed'),
                    ],
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: const [
                  OrderCard(
                    orderNumber: 'ORD-3845',
                    date: 'Today, 10:30 AM',
                    status: 'Delivered',
                    items: '1x 20L Water Jar',
                    amount: 60.0,
                    showDetails: true,
                  ),
                  SizedBox(height: 12),
                  OrderCard(
                    orderNumber: 'ORD-3844',
                    date: 'Yesterday, 2:15 PM',
                    status: 'Delivered',
                    items: '2x 1L Water Bottle',
                    amount: 40.0,
                    showDetails: true,
                  ),
                  SizedBox(height: 12),
                  OrderCard(
                    orderNumber: 'ORD-3843',
                    date: '15 May, 11:45 AM',
                    status: 'Delivered',
                    items: '1x 20L Water Jar, 1x 1L Water Bottle',
                    amount: 80.0,
                    showDetails: true,
                  ),
                  SizedBox(height: 12),
                  OrderCard(
                    orderNumber: 'ORD-3842',
                    date: '12 May, 4:20 PM',
                    status: 'Delivered',
                    items: '1x 10L Water Can',
                    amount: 40.0,
                    showDetails: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Tab
class _ProfileTab extends StatelessWidget {
  const _ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header with title
                  Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 30),

                  // User profile card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // User avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User name
                        Text(
                          user?.fullName ?? 'User Name',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),

                        // User phone
                        Text(
                          user?.phoneNumber ?? '+977 XXXXXXXXXX',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),

                        const SizedBox(height: 20),

                        // Edit profile button
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.profile,
                            );
                            // TODO: Navigate to edit profile
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Profile menu items
                  _buildProfileMenuItem(
                    context,
                    icon: Icons.loyalty,
                    title: 'My Referral Code',
                    subtitle: user?.referralCode ?? 'XXXXXX',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.referrals);
                    },
                  ),
                  _buildProfileMenuItem(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Address',
                    subtitle: user?.address ?? 'Not set',
                    onTap: () {
                      // TODO: Navigate to address management
                    },
                  ),
                  _buildProfileMenuItem(
                    context,
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Add or manage payment methods',
                    onTap: () {
                      // TODO: Navigate to payment methods
                    },
                  ),
                  _buildProfileMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Contact us, FAQs, terms',
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  _buildProfileMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'App preferences, notifications',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                  ),
                  _buildProfileMenuItem(
                    context,
                    icon: Icons.logout,
                    title: 'Log Out',
                    subtitle: 'Sign out from the app',
                    isDestructive: true,
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.1)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDestructive ? Colors.red : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
