import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FilterBar extends StatefulWidget {
  final List<FilterOption> filters;
  final Function(Map<String, dynamic>) onFiltersChanged;
  final VoidCallback? onRefresh;
  final VoidCallback? onExport;
  final bool showSearch;
  final String? searchHint;
  final Function(String)? onSearchChanged;

  const FilterBar({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    this.onRefresh,
    this.onExport,
    this.showSearch = false,
    this.searchHint,
    this.onSearchChanged,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final Map<String, dynamic> _filterValues = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize filter values
    for (final filter in widget.filters) {
      _filterValues[filter.key] = filter.defaultValue;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _filterValues[key] = value;
    });
    widget.onFiltersChanged(_filterValues);
  }

  void _clearFilters() {
    setState(() {
      for (final filter in widget.filters) {
        _filterValues[filter.key] = filter.defaultValue;
      }
      _searchController.clear();
    });
    widget.onFiltersChanged(_filterValues);
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          if (widget.showSearch) ...[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.searchHint ?? 'Search...',
                prefixIcon: const Icon(Symbols.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Symbols.clear),
                        onPressed: () {
                          _searchController.clear();
                          if (widget.onSearchChanged != null) {
                            widget.onSearchChanged!('');
                          }
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: widget.onSearchChanged,
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: widget.filters.map((filter) {
                    return _buildFilterWidget(filter);
                  }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Symbols.clear_all, size: 16),
                    label: const Text('Clear'),
                  ),
                  if (widget.onRefresh != null)
                    IconButton(
                      onPressed: widget.onRefresh,
                      icon: const Icon(Symbols.refresh),
                      tooltip: 'Refresh',
                    ),
                  if (widget.onExport != null)
                    IconButton(
                      onPressed: widget.onExport,
                      icon: const Icon(Symbols.download),
                      tooltip: 'Export',
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterWidget(FilterOption filter) {
    switch (filter.type) {
      case FilterType.dropdown:
        return SizedBox(
          width: 150,
          child: DropdownButtonFormField<dynamic>(
            value: _filterValues[filter.key],
            decoration: InputDecoration(
              labelText: filter.label,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items: filter.options?.map((option) {
              return DropdownMenuItem(
                value: option.value,
                child: Text(option.label),
              );
            }).toList(),
            onChanged: (value) => _updateFilter(filter.key, value),
          ),
        );

      case FilterType.dateRange:
        return SizedBox(
          width: 200,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: filter.label,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Symbols.calendar_month),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            readOnly: true,
            onTap: () => _showDateRangePicker(filter.key),
            controller: TextEditingController(
              text: _formatDateRange(_filterValues[filter.key]),
            ),
          ),
        );

      case FilterType.multiSelect:
        return SizedBox(
          width: 150,
          child: FilterChip(
            label: Text(filter.label),
            selected: (_filterValues[filter.key] as List?)?.isNotEmpty ?? false,
            onSelected: (selected) => _showMultiSelectDialog(filter),
          ),
        );

      case FilterType.toggle:
        return FilterChip(
          label: Text(filter.label),
          selected: _filterValues[filter.key] == true,
          onSelected: (selected) => _updateFilter(filter.key, selected),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  String _formatDateRange(dynamic dateRange) {
    if (dateRange == null) return '';
    if (dateRange is Map) {
      final start = dateRange['start'] as DateTime?;
      final end = dateRange['end'] as DateTime?;
      if (start != null && end != null) {
        return '${start.day}/${start.month} - ${end.day}/${end.month}';
      }
    }
    return '';
  }

  void _showDateRangePicker(String key) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _filterValues[key] != null
          ? DateTimeRange(
              start: _filterValues[key]['start'],
              end: _filterValues[key]['end'],
            )
          : null,
    );

    if (picked != null) {
      _updateFilter(key, {
        'start': picked.start,
        'end': picked.end,
      });
    }
  }

  void _showMultiSelectDialog(FilterOption filter) {
    showDialog(
      context: context,
      builder: (context) {
        final List<dynamic> selectedValues = 
            List.from(_filterValues[filter.key] ?? []);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select ${filter.label}'),
              content: SizedBox(
                width: 300,
                height: 400,
                child: ListView(
                  children: filter.options?.map((option) {
                    final isSelected = selectedValues.contains(option.value);
                    return CheckboxListTile(
                      title: Text(option.label),
                      value: isSelected,
                      onChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            selectedValues.add(option.value);
                          } else {
                            selectedValues.remove(option.value);
                          }
                        });
                      },
                    );
                  }).toList() ?? [],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateFilter(filter.key, selectedValues);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

enum FilterType {
  dropdown,
  dateRange,
  multiSelect,
  toggle,
}

class FilterOption {
  final String key;
  final String label;
  final FilterType type;
  final dynamic defaultValue;
  final List<FilterOptionItem>? options;

  const FilterOption({
    required this.key,
    required this.label,
    required this.type,
    this.defaultValue,
    this.options,
  });
}

class FilterOptionItem {
  final String label;
  final dynamic value;

  const FilterOptionItem({
    required this.label,
    required this.value,
  });
}
