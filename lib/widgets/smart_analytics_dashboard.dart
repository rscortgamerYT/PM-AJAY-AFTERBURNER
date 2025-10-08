import 'package:flutter/material.dart';
import 'dart:math';

class SmartAnalyticsDashboard extends StatefulWidget {
  final String userRole;
  final bool highContrast;

  const SmartAnalyticsDashboard({
    super.key,
    required this.userRole,
    this.highContrast = false,
  });

  @override
  State<SmartAnalyticsDashboard> createState() => _SmartAnalyticsDashboardState();
}

class _SmartAnalyticsDashboardState extends State<SmartAnalyticsDashboard>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late AnimationController _insightAnimationController;
  int _selectedTimeRange = 0; // 0: 7 days, 1: 30 days, 2: 90 days
  bool _showPredictions = true;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _insightAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _chartAnimationController.forward();
    _insightAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    _insightAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AI Insights Panel
        _buildAIInsightsPanel(),
        
        const SizedBox(height: 16),
        
        // Time Range Selector
        _buildTimeRangeSelector(),
        
        const SizedBox(height: 16),
        
        // Interactive Charts Grid
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildFundUtilizationChart(),
              _buildStatePerformanceHeatmap(),
              _buildProjectCompletionForecast(),
              _buildAgencyCollaborationNetwork(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightsPanel() {
    return AnimatedBuilder(
      animation: _insightAnimationController,
      builder: (context, child) {
        return Transform.translateY(
          offset: Offset(0, 20 * (1 - _insightAnimationController.value)),
          child: Opacity(
            opacity: _insightAnimationController.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.highContrast
                      ? [Colors.grey[800]!, Colors.grey[900]!]
                      : [Colors.blue[50]!, Colors.purple[50]!],
                ),
                borderRadius: BorderRadius.circular(12),
                border: widget.highContrast
                    ? Border.all(color: Colors.yellow, width: 2)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.highContrast
                              ? Colors.yellow.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.psychology,
                          color: widget.highContrast ? Colors.yellow : Colors.blue[700],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI-Powered Insights',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: widget.highContrast ? Colors.white : Colors.blue[700],
                              ),
                            ),
                            Text(
                              'Real-time analysis and predictions',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.highContrast ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _showPredictions,
                        onChanged: (value) {
                          setState(() {
                            _showPredictions = value;
                          });
                        },
                        activeColor: widget.highContrast ? Colors.yellow : Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // AI Insights List
                  ..._getAIInsights().map((insight) => _buildInsightItem(insight)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInsightItem(AIInsight insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.highContrast
            ? Colors.grey[800]
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: widget.highContrast
            ? Border.all(color: Colors.grey[600]!)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _getInsightColor(insight.type).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getInsightIcon(insight.type),
              size: 16,
              color: widget.highContrast ? Colors.yellow : _getInsightColor(insight.type),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.highContrast ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insight.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.highContrast ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getInsightColor(insight.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${insight.confidence}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: widget.highContrast ? Colors.yellow : _getInsightColor(insight.type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    final ranges = ['7 Days', '30 Days', '90 Days'];
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.highContrast ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: ranges.asMap().entries.map((entry) {
          final index = entry.key;
          final range = entry.value;
          final isSelected = _selectedTimeRange == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeRange = index;
                });
                _chartAnimationController.reset();
                _chartAnimationController.forward();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (widget.highContrast ? Colors.yellow : Colors.blue)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  range,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? (widget.highContrast ? Colors.black : Colors.white)
                        : (widget.highContrast ? Colors.white : Colors.grey[700]),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFundUtilizationChart() {
    return _buildChartContainer(
      title: 'Fund Utilization Trends',
      child: AnimatedBuilder(
        animation: _chartAnimationController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 120),
            painter: FundUtilizationChartPainter(
              progress: _chartAnimationController.value,
              highContrast: widget.highContrast,
              timeRange: _selectedTimeRange,
            ),
          );
        },
      ),
      insights: [
        'Utilization improved 15% this quarter',
        '3 states showing concerning patterns',
        'Predicted shortfall in Q4 for Bihar',
      ],
      onTap: () => _showDetailedChart('Fund Utilization'),
    );
  }

  Widget _buildStatePerformanceHeatmap() {
    return _buildChartContainer(
      title: 'State Performance Matrix',
      child: AnimatedBuilder(
        animation: _chartAnimationController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 120),
            painter: StatePerformanceHeatmapPainter(
              progress: _chartAnimationController.value,
              highContrast: widget.highContrast,
            ),
          );
        },
      ),
      insights: [
        'Maharashtra leading in performance',
        'Bihar needs immediate attention',
        'Karnataka showing improvement',
      ],
      onTap: () => _showDetailedChart('State Performance'),
    );
  }

  Widget _buildProjectCompletionForecast() {
    return _buildChartContainer(
      title: 'Project Completion Forecast',
      child: AnimatedBuilder(
        animation: _chartAnimationController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 120),
            painter: ProjectForecastChartPainter(
              progress: _chartAnimationController.value,
              highContrast: widget.highContrast,
              showPredictions: _showPredictions,
            ),
          );
        },
      ),
      insights: [
        '95% projects on track for completion',
        'AI predicts 2 weeks early delivery',
        'Resource optimization suggested',
      ],
      onTap: () => _showDetailedChart('Project Forecast'),
    );
  }

  Widget _buildAgencyCollaborationNetwork() {
    return _buildChartContainer(
      title: 'Agency Collaboration Network',
      child: AnimatedBuilder(
        animation: _chartAnimationController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 120),
            painter: CollaborationNetworkPainter(
              progress: _chartAnimationController.value,
              highContrast: widget.highContrast,
            ),
          );
        },
      ),
      insights: [
        'Strong collaboration between MH-KA',
        'TN agencies need better coordination',
        'Cross-state knowledge sharing up 40%',
      ],
      onTap: () => _showDetailedChart('Collaboration Network'),
    );
  }

  Widget _buildChartContainer({
    required String title,
    required Widget child,
    required List<String> insights,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.highContrast ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: widget.highContrast
              ? Border.all(color: Colors.grey[700]!)
              : null,
          boxShadow: widget.highContrast
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.highContrast ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_full,
                  size: 16,
                  color: widget.highContrast ? Colors.yellow : Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: child),
            const SizedBox(height: 8),
            
            // Mini insights
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.highContrast
                    ? Colors.grey[800]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: insights.take(2).map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: widget.highContrast ? Colors.yellow : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          insight,
                          style: TextStyle(
                            fontSize: 10,
                            color: widget.highContrast ? Colors.white : Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AIInsight> _getAIInsights() {
    switch (widget.userRole.toLowerCase()) {
      case 'centre admin':
        return [
          AIInsight(
            type: InsightType.positive,
            title: 'Fund Utilization Optimization',
            description: 'AI suggests reallocating ₹200 Cr from slow states to high-performing ones',
            confidence: 87,
          ),
          AIInsight(
            type: InsightType.warning,
            title: 'Project Delay Risk',
            description: '15 projects at risk of missing deadlines. Immediate intervention needed',
            confidence: 92,
          ),
          AIInsight(
            type: InsightType.prediction,
            title: 'Q4 Performance Forecast',
            description: 'Predicted 95% target achievement based on current trends',
            confidence: 78,
          ),
        ];
      case 'state officer':
        return [
          AIInsight(
            type: InsightType.positive,
            title: 'Agency Performance',
            description: 'Top 3 agencies showing 25% above-average completion rates',
            confidence: 85,
          ),
          AIInsight(
            type: InsightType.warning,
            title: 'Budget Variance Alert',
            description: 'District-wise spending shows 15% variance from planned allocation',
            confidence: 90,
          ),
        ];
      default:
        return [
          AIInsight(
            type: InsightType.positive,
            title: 'Performance Trend',
            description: 'Overall performance metrics showing positive trend',
            confidence: 80,
          ),
        ];
    }
  }

  Color _getInsightColor(InsightType type) {
    switch (type) {
      case InsightType.positive:
        return Colors.green;
      case InsightType.warning:
        return Colors.orange;
      case InsightType.prediction:
        return Colors.blue;
      case InsightType.critical:
        return Colors.red;
    }
  }

  IconData _getInsightIcon(InsightType type) {
    switch (type) {
      case InsightType.positive:
        return Icons.trending_up;
      case InsightType.warning:
        return Icons.warning;
      case InsightType.prediction:
        return Icons.auto_graph;
      case InsightType.critical:
        return Icons.error;
    }
  }

  void _showDetailedChart(String chartType) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Detailed $chartType Analysis',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Detailed $chartType view',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Interactive drill-down analysis with AI-powered insights',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data Models
class AIInsight {
  final InsightType type;
  final String title;
  final String description;
  final int confidence;

  AIInsight({
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
  });
}

enum InsightType {
  positive,
  warning,
  prediction,
  critical,
}

// Custom Painters for Charts
class FundUtilizationChartPainter extends CustomPainter {
  final double progress;
  final bool highContrast;
  final int timeRange;

  FundUtilizationChartPainter({
    required this.progress,
    required this.highContrast,
    required this.timeRange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Generate sample data points
    final points = <Offset>[];
    final dataPoints = timeRange == 0 ? 7 : (timeRange == 1 ? 30 : 90);
    
    for (int i = 0; i < dataPoints; i++) {
      final x = (i / (dataPoints - 1)) * size.width;
      final baseY = size.height * 0.7;
      final variation = sin(i * 0.5) * 20 + Random().nextDouble() * 10;
      final y = baseY - variation;
      points.add(Offset(x, y * progress));
    }

    // Draw trend line
    paint.color = highContrast ? Colors.yellow : Colors.blue;
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, paint);

    // Draw data points
    paint.style = PaintingStyle.fill;
    for (final point in points) {
      canvas.drawCircle(point, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StatePerformanceHeatmapPainter extends CustomPainter {
  final double progress;
  final bool highContrast;

  StatePerformanceHeatmapPainter({
    required this.progress,
    required this.highContrast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final cellWidth = size.width / 6;
    final cellHeight = size.height / 5;

    // Sample state performance data
    final performanceData = [
      [0.9, 0.8, 0.7, 0.6, 0.8, 0.9],
      [0.7, 0.9, 0.8, 0.5, 0.7, 0.8],
      [0.6, 0.7, 0.9, 0.8, 0.6, 0.7],
      [0.8, 0.6, 0.7, 0.9, 0.8, 0.6],
      [0.9, 0.8, 0.6, 0.7, 0.9, 0.8],
    ];

    for (int row = 0; row < performanceData.length; row++) {
      for (int col = 0; col < performanceData[row].length; col++) {
        final performance = performanceData[row][col] * progress;
        final rect = Rect.fromLTWH(
          col * cellWidth,
          row * cellHeight,
          cellWidth - 1,
          cellHeight - 1,
        );

        if (highContrast) {
          paint.color = Color.lerp(Colors.grey[800]!, Colors.yellow, performance)!;
        } else {
          paint.color = Color.lerp(Colors.red[100]!, Colors.green, performance)!;
        }
        
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ProjectForecastChartPainter extends CustomPainter {
  final double progress;
  final bool highContrast;
  final bool showPredictions;

  ProjectForecastChartPainter({
    required this.progress,
    required this.highContrast,
    required this.showPredictions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Historical data
    final historicalPoints = <Offset>[];
    for (int i = 0; i < 10; i++) {
      final x = (i / 20) * size.width;
      final y = size.height * (0.8 - i * 0.05) * progress;
      historicalPoints.add(Offset(x, y));
    }

    // Draw historical trend
    paint.color = highContrast ? Colors.white : Colors.blue;
    final historicalPath = Path();
    if (historicalPoints.isNotEmpty) {
      historicalPath.moveTo(historicalPoints.first.dx, historicalPoints.first.dy);
      for (final point in historicalPoints.skip(1)) {
        historicalPath.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(historicalPath, paint);

    // Prediction line
    if (showPredictions) {
      final predictionPoints = <Offset>[];
      for (int i = 8; i < 20; i++) {
        final x = (i / 20) * size.width;
        final y = size.height * (0.4 - (i - 8) * 0.02) * progress;
        predictionPoints.add(Offset(x, y));
      }

      paint.color = highContrast ? Colors.yellow : Colors.orange;
      paint.strokeWidth = 2;
      paint.pathEffect = null; // Dashed line would be implemented here
      
      final predictionPath = Path();
      if (predictionPoints.isNotEmpty) {
        predictionPath.moveTo(predictionPoints.first.dx, predictionPoints.first.dy);
        for (final point in predictionPoints.skip(1)) {
          predictionPath.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(predictionPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CollaborationNetworkPainter extends CustomPainter {
  final double progress;
  final bool highContrast;

  CollaborationNetworkPainter({
    required this.progress,
    required this.highContrast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Node positions (representing agencies/states)
    final nodes = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.6),
    ];

    // Draw connections
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = (highContrast ? Colors.yellow : Colors.blue).withOpacity(0.6);
    
    // Connection strength data
    final connections = [
      [0, 1, 0.8], // Strong connection
      [1, 2, 0.6], // Medium connection
      [2, 3, 0.9], // Very strong
      [3, 4, 0.4], // Weak connection
      [0, 3, 0.7], // Strong connection
    ];

    for (final connection in connections) {
      final startNode = nodes[connection[0] as int];
      final endNode = nodes[connection[1] as int];
      final strength = connection[2] as double;
      
      paint.strokeWidth = strength * 4 * progress;
      canvas.drawLine(startNode, endNode, paint);
    }

    // Draw nodes
    paint.style = PaintingStyle.fill;
    paint.color = highContrast ? Colors.yellow : Colors.blue;
    
    for (final node in nodes) {
      canvas.drawCircle(node, 8 * progress, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
