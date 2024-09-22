import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.tab,
  });

  final String tab;

  static const tabs = [
    DashboardPage.pageConfig,
    OverviewPage.pageConfig,
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final int index = HomePage.tabs.indexWhere((element) => element.name == widget.tab);

  final destinations = HomePage.tabs
      .map(
        (page) => NavigationDestination(
          icon: Icon(page.icon),
          label: page.name,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AdaptiveLayout(
          primaryNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('primary-navigation-medium'),
                builder: (context) => AdaptiveScaffold.standardNavigationRail(
                  selectedIndex: index,
                  onDestinationSelected: (index) => _tapOnNavigationDestination(context, index),
                  destinations: destinations
                      .map(
                        (element) => AdaptiveScaffold.toRailDestination(element),
                      )
                      .toList(),
                ),
              ),
            },
          ),
          bottomNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.small: SlotLayout.from(
                key: const Key('bottom-navigation-small'),
                builder: (context) => AdaptiveScaffold.standardBottomNavigationBar(
                  currentIndex: index,
                  destinations: destinations,
                  onDestinationSelected: (value) => _tapOnNavigationDestination(context, value),
                ),
              ),
            },
          ),
          body: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.smallAndUp: SlotLayout.from(
                key: const Key('primary-body'),
                builder: (_) => HomePage.tabs[index].child,
              ),
            },
          ),
          secondaryBody: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('secondary-body'),
                builder: AdaptiveScaffold.emptyBuilder,
              ),
            },
          ),
        ),
      ),
    );
  }

  void _tapOnNavigationDestination(BuildContext context, int index) =>
      context.go('/home/${HomePage.tabs[index].name}');
}