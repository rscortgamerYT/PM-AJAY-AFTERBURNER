import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

// AI-Driven Agency Load Balancer with Predictive Capacity Forecasting
class AILoadBalancer extends StatefulWidget {
  final String userRole;
  final String? filterState;

  const AILoadBalancer({
    super.key,
    required this.userRole,
    this.filterState,
  });

  @override
  State<AILoadBalancer> createState() => _AILoadBalancerState();
}

class _AILoadBalancerState extends State<AILoadBalancer>
    with TickerProviderStateMixin {
  late AnimationController _predictionController;
  late Animation<double> _predictionAnimation;

  List<AgencyCapacityForecast> _forecasts = [];
  List<RebalanceRecommendation> _recommendations = [];
  RebalanceScenario? _currentScenario;
  bool _isAnalyzing = false;
  double _forecastWeeks = 4.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCapacityForecasts();
    _generateRecommendations();
  }

  void _initializeAnimations() {
    _predictionController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _predictionAnimation = CurvedAnimation(
      parent: _predictionController,
      curve: Curves.easeInOut,
    );

    _predictionController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildControlHeader(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildForecastPanel(),
              ),
              Expanded(
                flex: 2,
                child: _buildRecommendationsPanel(),
              ),
              Expanded(
                flex: 1,
                child: _buildScenarioPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[50]!, Colors.white],
        ),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.orange, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Load Balancer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Predictive capacity management and smart reassignment',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Forecast Range Slider
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Forecast: ${_forecastWeeks.toInt()} weeks'),
                Slider(
                  value: _forecastWeeks,
                  min: 1,
                  max: 12,
                  divisions: 11,
                  onChanged: (value) {
                    setState(() => _forecastWeeks = value);
                    _updateForecasts();
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          ElevatedButton.icon(
            onPressed: _isAnalyzing ? null : _runAIAnalysis,
            icon: _isAnalyzing 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(_isAnalyzing ? 'Analyzing...' : 'Run AI Analysis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastPanel() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Capacity Forecasts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ML Powered',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: AnimatedBuilder(
              animation: _predictionAnimation,
              builder: (context, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _forecasts.length,
                  itemBuilder: (context, index) {
                    final forecast = _forecasts[index];
                    return _buildForecastCard(forecast, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(AgencyCapacityForecast forecast, int index) {
    final isOverloaded = forecast.predictedCapacity > 90;
    final isUnderutilized = forecast.predictedCapacity < 40;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isOverloaded ? Colors.red : 
                 isUnderutilized ? Colors.orange : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isOverloaded ? Colors.red[50] : 
               isUnderutilized ? Colors.orange[50] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  forecast.agencyName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (isOverloaded)
                const Icon(Icons.warning, color: Colors.red, size: 20)
              else if (isUnderutilized)
                const Icon(Icons.info, color: Colors.orange, size: 20),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${forecast.state} • ${forecast.component}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          
          const SizedBox(height: 12),
          
          // Current vs Predicted Capacity
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current', style: TextStyle(fontSize: 12)),
                    Text(
                      '${forecast.currentCapacity}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, size: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Week ${_forecastWeeks.toInt()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${forecast.predictedCapacity}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOverloaded ? Colors.red : 
                               isUnderutilized ? Colors.orange : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Capacity Progress Bar
          LinearProgressIndicator(
            value: forecast.predictedCapacity / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverloaded ? Colors.red : 
              isUnderutilized ? Colors.orange : Colors.green,
            ),
          ),
          
          if (forecast.riskFactors.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: forecast.riskFactors.map((factor) {
                return Chip(
                  label: Text(factor),
                  backgroundColor: Colors.red[100],
                  labelStyle: const TextStyle(fontSize: 10),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationsPanel() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Smart Recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _recommendations.isNotEmpty ? _applyAllRecommendations : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Apply All', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = _recommendations[index];
                return _buildRecommendationCard(recommendation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(RebalanceRecommendation recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRecommendationIcon(recommendation.type),
                color: _getRecommendationColor(recommendation.type),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  recommendation.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getRecommendationColor(recommendation.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${recommendation.impactScore}% impact',
                  style: TextStyle(
                    fontSize: 10,
                    color: _getRecommendationColor(recommendation.type),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            recommendation.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          
          const SizedBox(height: 12),
          
          // From -> To Transfer
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('From', style: TextStyle(fontSize: 10)),
                      Text(
                        recommendation.fromAgency,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('To', style: TextStyle(fontSize: 10)),
                      Text(
                        recommendation.toAgency,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _previewRecommendation(recommendation),
                  child: const Text('Preview', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _applyRecommendation(recommendation),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioPanel() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Icon(Icons.science, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'What-If Scenarios',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _currentScenario != null
                  ? _buildScenarioDetails(_currentScenario!)
                  : _buildScenarioSelector(),
            ),
          ),
        ],
      ),
    );
  }

  // Event Handlers and Helper Methods
  void _runAIAnalysis() async {
    setState(() => _isAnalyzing = true);
    
    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _isAnalyzing = false;
      _generateRecommendations();
    });
    
    _predictionController.reset();
    _predictionController.forward();
  }

  void _loadCapacityForecasts() {
    setState(() {
      _forecasts = _generateMockForecasts();
    });
  }

  void _generateRecommendations() {
    setState(() {
      _recommendations = _generateMockRecommendations();
    });
  }

  List<AgencyCapacityForecast> _generateMockForecasts() {
    final random = math.Random();
    return List.generate(8, (index) {
      final current = 30 + random.nextInt(70);
      final predicted = current + random.nextInt(40) - 20;
      
      return AgencyCapacityForecast(
        agencyId: 'agency_$index',
        agencyName: 'Agency ${String.fromCharCode(65 + index)}',
        state: ['Maharashtra', 'Karnataka', 'Tamil Nadu'][index % 3],
        component: ['Infrastructure', 'Education', 'Healthcare'][index % 3],
        currentCapacity: current,
        predictedCapacity: predicted.clamp(0, 120),
        confidenceScore: 0.7 + random.nextDouble() * 0.3,
        riskFactors: predicted > 90 
            ? ['High project load', 'Resource constraints']
            : predicted < 40
                ? ['Low utilization', 'Available capacity']
                : [],
      );
    });
  }

  List<RebalanceRecommendation> _generateMockRecommendations() {
    return [
      RebalanceRecommendation(
        id: 'rec_1',
        type: RecommendationType.redistribute,
        title: 'Redistribute 3 projects from Agency A to Agency C',
        description: 'Agency A is predicted to reach 95% capacity. Transfer projects to reduce load.',
        fromAgency: 'Agency A (Maharashtra)',
        toAgency: 'Agency C (Maharashtra)',
        impactScore: 85,
        estimatedTimeSaving: '2.5 weeks',
      ),
      RebalanceRecommendation(
        id: 'rec_2',
        type: RecommendationType.scaleUp,
        title: 'Scale up Agency B capacity',
        description: 'High demand in Karnataka region. Consider expanding Agency B resources.',
        fromAgency: 'System Recommendation',
        toAgency: 'Agency B (Karnataka)',
        impactScore: 70,
        estimatedTimeSaving: '1.8 weeks',
      ),
    ];
  }

  @override
  void dispose() {
    _predictionController.dispose();
    super.dispose();
  }
}

// Data Models
class AgencyCapacityForecast {
  final String agencyId;
  final String agencyName;
  final String state;
  final String component;
  final int currentCapacity;
  final int predictedCapacity;
  final double confidenceScore;
  final List<String> riskFactors;

  AgencyCapacityForecast({
    required this.agencyId,
    required this.agencyName,
    required this.state,
    required this.component,
    required this.currentCapacity,
    required this.predictedCapacity,
    required this.confidenceScore,
    required this.riskFactors,
  });
}

class RebalanceRecommendation {
  final String id;
  final RecommendationType type;
  final String title;
  final String description;
  final String fromAgency;
  final String toAgency;
  final int impactScore;
  final String estimatedTimeSaving;

  RebalanceRecommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.fromAgency,
    required this.toAgency,
    required this.impactScore,
    required this.estimatedTimeSaving,
  });
}

class RebalanceScenario {
  final String id;
  final String name;
  final Map<String, dynamic> parameters;
  final Map<String, dynamic> results;

  RebalanceScenario({
    required this.id,
    required this.name,
    required this.parameters,
    required this.results,
  });
}

enum RecommendationType { redistribute, scaleUp, scaleDown, optimize }
