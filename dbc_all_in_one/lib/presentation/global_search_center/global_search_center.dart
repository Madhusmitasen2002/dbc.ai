import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/global_search_service.dart';
import '../../widgets/dbc_back_button.dart';
import '../business_dashboard/widgets/desktop_sidebar_widget.dart';
import '../business_dashboard/widgets/desktop_right_panel_widget.dart';
import './widgets/advanced_filter_sheet_widget.dart';
import './widgets/module_tab_widget.dart';
import './widgets/search_result_card_widget.dart';
import './widgets/search_suggestion_item_widget.dart';

class GlobalSearchCenter extends StatefulWidget {
  const GlobalSearchCenter({super.key});

  @override
  State<GlobalSearchCenter> createState() => _GlobalSearchCenterState();
}

class _GlobalSearchCenterState extends State<GlobalSearchCenter> {
  final GlobalSearchService _searchService = GlobalSearchService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedModule = 'All';
  bool _isLoading = false;
  Map<String, List<Map<String, dynamic>>> _searchResults = {};
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Filter states
  DateTime? _startDate;
  DateTime? _endDate;
  String? _statusFilter;
  double? _minAmount;
  double? _maxAmount;

  @override
  void initState() {
    super.initState();
    _suggestions = _searchService.getSearchSuggestions('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSuggestions = false;
    });

    try {
      final results = await _searchService.searchAll(
        _searchController.text,
        startDate: _startDate,
        endDate: _endDate,
        statusFilter: _statusFilter,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
      );

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _showSuggestions = value.isNotEmpty;
      _suggestions = _searchService.getSearchSuggestions(value);
    });
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _statusFilter = null;
      _minAmount = null;
      _maxAmount = null;
    });
    _performSearch();
  }

  List<Map<String, dynamic>> _getFilteredResults() {
    if (_selectedModule == 'All') {
      return [
        ..._searchResults['invoices'] ?? [],
        ..._searchResults['inventory'] ?? [],
        ..._searchResults['staff'] ?? [],
        ..._searchResults['vendors'] ?? [],
        ..._searchResults['orders'] ?? [],
      ];
    } else {
      return _searchResults[_selectedModule.toLowerCase()] ?? [];
    }
  }

  int _getModuleCount(String module) {
    if (module == 'All') {
      return (_searchResults['invoices']?.length ?? 0) +
          (_searchResults['inventory']?.length ?? 0) +
          (_searchResults['staff']?.length ?? 0) +
          (_searchResults['vendors']?.length ?? 0) +
          (_searchResults['orders']?.length ?? 0);
    }
    return _searchResults[module.toLowerCase()]?.length ?? 0;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedFilterSheetWidget(
        startDate: _startDate,
        endDate: _endDate,
        statusFilter: _statusFilter,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
        onApply: (startDate, endDate, status, minAmt, maxAmt) {
          setState(() {
            _startDate = startDate;
            _endDate = endDate;
            _statusFilter = status;
            _minAmount = minAmt;
            _maxAmount = maxAmt;
          });
          _performSearch();
        },
        onClear: _clearFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modules = [
      'All',
      'Invoices',
      'Inventory',
      'Staff',
      'Vendors',
      'Orders'
    ];

    // Reuse the same breakpoint pattern as BusinessDashboard for desktop
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;
        return isDesktop ? _buildDesktopScaffold() : _buildMobileScaffold();
      },
    );
  }

  Widget _buildDesktopScaffold() {
    final navItems = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Home',
      },
      {
        'icon': Icons.security_outlined,
        'activeIcon': Icons.security,
        'label': 'Security',
      },
      {
        'icon': Icons.inventory_2_outlined,
        'activeIcon': Icons.inventory_2,
        'label': 'Stock',
      },
      {
        'icon': Icons.people_outline,
        'activeIcon': Icons.people,
        'label': 'Staff',
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'activeIcon': Icons.account_balance_wallet,
        'label': 'Payments',
      },
      {
        'icon': Icons.more_horiz,
        'activeIcon': Icons.more_horiz,
        'label': 'More',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F5),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DesktopSidebarWidget(
            currentIndex: 0,
            navItems: navItems,
            onTap: (i) =>
                Navigator.pushReplacementNamed(context, _routeForIndex(i)),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: _buildMainContent(),
              ),
            ),
          ),
          const DesktopRightPanelWidget(),
        ],
      ),
    );
  }

  Widget _buildMobileScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const DBCBackButton(),
        title: const Text('Global Search',
            style: TextStyle(color: Color(0xFF1A1A1A))),
      ),
      body: SafeArea(child: _buildMainContent()),
    );
  }

  Widget _buildMainContent() {
    final modules = [
      'All',
      'Invoices',
      'Inventory',
      'Staff',
      'Vendors',
      'Orders'
    ];

    return Column(
      children: [
        // Sticky Search Header
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const DBCBackButton(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        onSubmitted: (_) => _performSearch(),
                        decoration: InputDecoration(
                          hintText: 'Search across all modules...',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 20.0),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchResults = {};
                                      _showSuggestions = false;
                                    });
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.mic, color: Colors.blue),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: (_startDate != null || _statusFilter != null)
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    onPressed: _showFilterSheet,
                  ),
                ],
              ),
              if (_startDate != null || _statusFilter != null)
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Active filters: ${[
                            if (_startDate != null) 'Date Range',
                            if (_statusFilter != null) 'Status',
                            if (_minAmount != null) 'Amount',
                          ].join(', ')}',
                          style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: _clearFilters,
                        child: Text('Clear', style: TextStyle(fontSize: 12.sp)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Module Tabs
        if (_searchResults.isNotEmpty)
          Container(
            height: 6.h,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                return ModuleTabWidget(
                  module: modules[index],
                  count: _getModuleCount(modules[index]),
                  isSelected: _selectedModule == modules[index],
                  onTap: () => setState(() => _selectedModule = modules[index]),
                );
              },
            ),
          ),

        // Content area (suggestions / results / loading / empty)
        if (_showSuggestions && _suggestions.isNotEmpty)
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return SearchSuggestionItemWidget(
                    suggestion: _suggestions[index],
                    onTap: () {
                      _searchController.text = _suggestions[index];
                      _performSearch();
                    },
                  );
                },
              ),
            ),
          )
        else if (_searchResults.isNotEmpty && !_isLoading)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: _getFilteredResults().length,
              itemBuilder: (context, index) {
                final result = _getFilteredResults()[index];
                return SearchResultCardWidget(
                  result: result,
                  onTap: () => _navigateToDetail(result),
                );
              },
            ),
          )
        else if (_isLoading)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 2.h),
                  Text('Searching across modules...',
                      style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 80.0, color: Colors.grey[300]),
                  SizedBox(height: 2.h),
                  Text('Search across all modules',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 1.h),
                  Text(
                      'Try searching for invoices, products,\nstaff, vendors, or orders',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _routeForIndex(int i) {
    switch (i) {
      case 0:
        return AppRoutes.businessDashboard;
      case 1:
        return AppRoutes.liveCameraView;
      case 2:
        return AppRoutes.inventoryManagement;
      case 3:
        return AppRoutes.staffManagement;
      case 4:
        return AppRoutes.paymentProcessingCenter;
      case 5:
        return AppRoutes.orderManagementHub;
      default:
        return AppRoutes.businessDashboard;
    }
  }

  void _navigateToDetail(Map<String, dynamic> result) {
    // Determine module type and navigate accordingly
    if (result.containsKey('invoice_number')) {
      Navigator.pushNamed(context, AppRoutes.invoiceManagementCenter);
    } else if (result.containsKey('product_name')) {
      Navigator.pushNamed(context, AppRoutes.inventoryManagement);
    } else if (result.containsKey('full_name') && result.containsKey('email')) {
      Navigator.pushNamed(context, AppRoutes.staffManagement);
    } else if (result.containsKey('vendor_name')) {
      Navigator.pushNamed(context, AppRoutes.vendorMarketplace);
    } else if (result.containsKey('item_name')) {
      Navigator.pushNamed(context, AppRoutes.orderManagementHub);
    }
  }
}
