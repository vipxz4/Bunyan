import 'package:bonyan/screens/account/account_screen.dart';
import 'package:bonyan/screens/home/home_screen.dart';
import 'package:bonyan/screens/login/login_screen.dart';
import 'package:bonyan/screens/my_projects_list/my_projects_list_screen.dart';
import 'package:bonyan/screens/onboarding/onboarding_screen.dart';
import 'package:bonyan/screens/otp/otp_screen.dart';
import 'package:bonyan/screens/register/register_screen.dart';
import 'package:bonyan/screens/materials_search/materials_search_screen.dart';
import 'package:bonyan/screens/materials_search_results/materials_search_results_screen.dart';
import 'package:bonyan/screens/product_details/product_details_screen.dart';
import 'package:bonyan/screens/professional_profile/professional_profile_screen.dart';
import 'package:bonyan/screens/professional_search/professional_search_screen.dart';
import 'package:bonyan/screens/professional_search_results/professional_search_results_screen.dart';
import 'package:bonyan/screens/cart/cart_screen.dart';
import 'package:bonyan/screens/checkout_summary/checkout_summary_screen.dart';
import 'package:bonyan/screens/chat_interface/chat_interface_screen.dart';
import 'package:bonyan/screens/chat_list/chat_list_screen.dart';
import 'package:bonyan/screens/coming_soon/coming_soon_screen.dart';
import 'package:bonyan/screens/edit_profile/edit_profile_screen.dart';
import 'package:bonyan/screens/favorites/favorites_screen.dart';
import 'package:bonyan/screens/notification_details/notification_details_screen.dart';
import 'package:bonyan/screens/notifications/notifications_screen.dart';
import 'package:bonyan/screens/purchase_orders/purchase_orders_screen.dart';
import 'package:bonyan/screens/quotation_requests/quotation_requests_screen.dart';
import 'package:bonyan/screens/saved_contracts/saved_contracts_screen.dart';
import 'package:bonyan/screens/forgot_password/forgot_password_screen.dart';
import 'package:bonyan/screens/splash/splash_screen.dart';
import 'package:bonyan/screens/supplier_profile/supplier_profile_screen.dart';
import 'package:bonyan/widgets/navigation/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKeyForProjects =
    GlobalKey<NavigatorState>(debugLabel: 'shellProjects');
final _shellNavigatorKeyForHome =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorKeyForAccount =
    GlobalKey<NavigatorState>(debugLabel: 'shellAccount');

final goRouter = GoRouter(
  initialLocation: '/splash',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) => const OTPScreen(),
    ),
    // Main application shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Branch for the 'My Projects' tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyForProjects,
          routes: [
            GoRoute(
              path: '/my-projects',
              name: 'my-projects',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: MyProjectsListScreen(),
              ),
            ),
          ],
        ),
        // Branch for the 'Home' tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyForHome,
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'professional-search',
                  name: 'professional-search',
                  builder: (context, state) => const ProfessionalSearchScreen(),
                ),
                GoRoute(
                  path: 'professional-search-results',
                  name: 'professional-search-results',
                  builder: (context, state) =>
                      const ProfessionalSearchResultsScreen(),
                ),
                GoRoute(
                  path: 'professional-profile/:id',
                  name: 'professional-profile',
                  builder: (context, state) => ProfessionalProfileScreen(
                      id: state.pathParameters['id']!),
                ),
                GoRoute(
                  path: 'materials-search',
                  name: 'materials-search',
                  builder: (context, state) => const MaterialsSearchScreen(),
                ),
                GoRoute(
                  path: 'materials-search-results',
                  name: 'materials-search-results',
                  builder: (context, state) =>
                      const MaterialsSearchResultsScreen(),
                ),
                GoRoute(
                  path: 'product-details/:id',
                  name: 'product-details',
                  builder: (context, state) =>
                      ProductDetailsScreen(id: state.pathParameters['id']!),
                ),
                GoRoute(
                  path: 'supplier-profile/:id',
                  name: 'supplier-profile',
                  builder: (context, state) =>
                      SupplierProfileScreen(id: state.pathParameters['id']!),
                ),
                GoRoute(
                  path: 'cart',
                  name: 'cart',
                  builder: (context, state) => const CartScreen(),
                ),
                GoRoute(
                  path: 'checkout-summary',
                  name: 'checkout-summary',
                  builder: (context, state) => const CheckoutSummaryScreen(),
                ),
                GoRoute(
                    path: 'notifications',
                    name: 'notifications',
                    builder: (context, state) => const NotificationsScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        name: 'notification-details',
                        builder: (context, state) => NotificationDetailsScreen(
                            id: state.pathParameters['id']!),
                      )
                    ]),
                GoRoute(
                    path: 'chat',
                    name: 'chat',
                    builder: (context, state) => const ChatListScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        name: 'chat-interface',
                        builder: (context, state) => ChatInterfaceScreen(
                            chatId: state.pathParameters['id']!),
                      )
                    ]),
                GoRoute(
                  path: 'favorites',
                  name: 'favorites',
                  builder: (context, state) => const FavoritesScreen(),
                ),
              ],
            ),
          ],
        ),
        // Branch for the 'Account' tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyForAccount,
          routes: [
            GoRoute(
              path: '/account',
              name: 'account',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AccountScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'edit-profile',
                  name: 'edit-profile',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'coming-soon',
                  name: 'coming-soon',
                  builder: (context, state) => const ComingSoonScreen(),
                ),
                GoRoute(
                  path: 'purchase-orders',
                  name: 'purchase-orders',
                  builder: (context, state) => const PurchaseOrdersScreen(),
                ),
                GoRoute(
                  path: 'quotation-requests',
                  name: 'quotation-requests',
                  builder: (context, state) => const QuotationRequestsScreen(),
                ),
                GoRoute(
                  path: 'saved-contracts',
                  name: 'saved-contracts',
                  builder: (context, state) => const SavedContractsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
