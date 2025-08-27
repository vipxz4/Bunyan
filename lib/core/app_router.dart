import 'package:bonyan/screens/account/account_screen.dart';
import 'package:bonyan/screens/home/home_screen.dart';
import 'package:bonyan/screens/login/login_screen.dart';
import 'package:bonyan/screens/my_projects_list/my_projects_list_screen.dart';
import 'package:bonyan/screens/onboarding/onboarding_screen.dart';
import 'package:bonyan/screens/otp/otp_screen.dart';
import 'package:bonyan/screens/register/register_screen.dart';
import 'package:bonyan/screens/materials_search/materials_search_screen.dart';
import 'package:bonyan/screens/general_search_results/general_search_results_screen.dart';
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
import 'package:bonyan/screens/my_ratings/my_ratings_screen.dart';
import 'package:bonyan/screens/quotation_requests/quotation_requests_screen.dart';
import 'package:bonyan/screens/saved_contracts/saved_contracts_screen.dart';
import 'package:bonyan/screens/help_and_support/help_and_support_screen.dart';
import 'package:bonyan/screens/settings/settings_screen.dart';
import 'package:bonyan/screens/supplier_dashboard/supplier_dashboard_screen.dart';
import 'package:bonyan/screens/supplier_dashboard/my_products_screen.dart';
import 'package:bonyan/screens/supplier_dashboard/my_orders_screen.dart';
import 'package:bonyan/screens/supplier_dashboard/add_edit_product_screen.dart';
import 'package:bonyan/screens/service_provider_dashboard/service_provider_dashboard_screen.dart';
import 'package:bonyan/screens/service_provider_dashboard/sp_my_projects_screen.dart';
import 'package:bonyan/screens/service_provider_dashboard/sp_my_bids_screen.dart';
import 'package:bonyan/screens/service_provider_dashboard/sp_ratings_screen.dart';
import 'package:bonyan/screens/service_provider_dashboard/sp_earnings_screen.dart';
import 'package:bonyan/screens/guarantee_funding/guarantee_funding_screen.dart';
import 'package:bonyan/screens/forgot_password/forgot_password_screen.dart';
import 'package:bonyan/screens/splash/splash_screen.dart';
import 'package:bonyan/screens/supplier_profile/supplier_profile_screen.dart';
import 'package:bonyan/services/auth_service.dart';
import 'package:bonyan/widgets/navigation/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKeyForProjects =
    GlobalKey<NavigatorState>(debugLabel: 'shellProjects');
final _shellNavigatorKeyForHome =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorKeyForAccount =
    GlobalKey<NavigatorState>(debugLabel: 'shellAccount');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      // If the user is not logged in, they can only access the auth pages.
      final isLoggedIn = authState.value != null;
      final location = state.uri.toString();
      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password';
      final isPublicRoute =
          isAuthRoute || location == '/splash' || location == '/onboarding';

      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      return null; // No redirect needed.
    },
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
                  routes: [
                    GoRoute(
                      path: 'guarantee-funding',
                      name: 'guarantee-funding',
                      builder: (context, state) =>
                          const GuaranteeFundingScreen(),
                    ),
                  ]),
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
                GoRoute(
                    path: 'search-results',
                    name: 'search-results',
                    builder: (context, state) {
                      final query = state.uri.queryParameters['q'] ?? '';
                      return GeneralSearchResultsScreen(query: query);
                    }),
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
                GoRoute(
                  path: 'my-ratings',
                  name: 'my-ratings',
                  builder: (context, state) => const MyRatingsScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  name: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  path: 'help-and-support',
                  name: 'help-and-support',
                  builder: (context, state) => const HelpAndSupportScreen(),
                ),
                GoRoute(
                    path: 'supplier-dashboard',
                    name: 'supplier-dashboard',
                    builder: (context, state) => const SupplierDashboardScreen(),
                    routes: [
                      GoRoute(
                          path: 'my-products',
                          name: 'my-products',
                          builder: (context, state) => const MyProductsScreen(),
                          routes: [
                            GoRoute(
                              path: 'add',
                              name: 'add-product',
                              builder: (context, state) =>
                                  const AddEditProductScreen(),
                            ),
                            GoRoute(
                              path: 'edit/:id',
                              name: 'edit-product',
                              builder: (context, state) => AddEditProductScreen(
                                  productId: state.pathParameters['id']!),
                            ),
                          ]),
                      GoRoute(
                        path: 'my-orders',
                        name: 'my-orders',
                        builder: (context, state) => const MyOrdersScreen(),
                      ),
                    ]),
                GoRoute(
                    path: 'service-provider-dashboard',
                    name: 'service-provider-dashboard',
                    builder: (context, state) =>
                        const ServiceProviderDashboardScreen(),
                    routes: [
                      GoRoute(
                        path: 'my-projects',
                        name: 'sp-my-projects',
                        builder: (context, state) => const SpMyProjectsScreen(),
                      ),
                      GoRoute(
                        path: 'my-bids',
                        name: 'sp-my-bids',
                        builder: (context, state) => const SpMyBidsScreen(),
                      ),
                      GoRoute(
                        path: 'my-ratings',
                        name: 'sp-my-ratings',
                        builder: (context, state) => const SpRatingsScreen(),
                      ),
                      GoRoute(
                        path: 'my-earnings',
                        name: 'sp-my-earnings',
                        builder: (context, state) => const SpEarningsScreen(),
                      ),
                    ]),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
