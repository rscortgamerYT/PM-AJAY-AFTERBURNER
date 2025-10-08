import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/user_role.dart';
import '../screens/hub/communication_hub_screen.dart';
import '../utils/navigation_helper.dart';

class CommunicationHubButton extends StatefulWidget {
  final UserRole userRole;
  final int unreadCount;
  final bool hasUrgentNotifications;

  const CommunicationHubButton({
    super.key,
    required this.userRole,
    this.unreadCount = 0,
    this.hasUrgentNotifications = false,
  });

  @override
  State<CommunicationHubButton> createState() => _CommunicationHubButtonState();
}

class _CommunicationHubButtonState extends State<CommunicationHubButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start pulsing if there are urgent notifications
    if (widget.hasUrgentNotifications) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CommunicationHubButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasUrgentNotifications && !oldWidget.hasUrgentNotifications) {
      _animationController.repeat(reverse: true);
    } else if (!widget.hasUrgentNotifications && oldWidget.hasUrgentNotifications) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  Color _getHubColor() {
    switch (widget.userRole) {
      case UserRole.centreAdmin:
        return const Color(0xFF3F51B5); // Indigo
      case UserRole.stateOfficer:
        return const Color(0xFF1976D2); // Blue
      case UserRole.agencyUser:
        return const Color(0xFF26A69A); // Teal
      case UserRole.auditor:
        return const Color(0xFF7B1FA2); // Purple
      case UserRole.publicViewer:
        return const Color(0xFF388E3C); // Green (not used)
    }
  }

  String _getHubLabel() {
    switch (widget.userRole) {
      case UserRole.centreAdmin:
        return 'Centre Hub';
      case UserRole.stateOfficer:
        return 'State Hub';
      case UserRole.agencyUser:
        return 'Agency Hub';
      case UserRole.auditor:
        return 'Audit Hub';
      case UserRole.publicViewer:
        return 'Public Hub';
    }
  }

  List<String> _getAvailableChannels() {
    switch (widget.userRole) {
      case UserRole.centreAdmin:
        return [
          'Centre ↔ All States',
          'Centre ↔ Auditors',
          'Policy Discussions',
          'Emergency Alerts'
        ];
      case UserRole.stateOfficer:
        return [
          'State ↔ Centre',
          'State ↔ Agencies',
          'Inter-State Coordination',
          'Regional Updates'
        ];
      case UserRole.agencyUser:
        return [
          'Agency ↔ State',
          'Agency ↔ Auditors',
          'Field Operations',
          'Project Updates'
        ];
      case UserRole.auditor:
        return [
          'Auditor ↔ Centre',
          'Auditor ↔ States',
          'Auditor ↔ Agencies',
          'Compliance Alerts'
        ];
      case UserRole.publicViewer:
        return ['Public Forum'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Quick access menu
          if (_isExpanded) ...[
            _buildQuickAccessMenu(),
            const SizedBox(height: 12),
          ],
          
          // Main Hub Button
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.hasUrgentNotifications 
                    ? _pulseAnimation.value 
                    : _scaleAnimation.value,
                child: GestureDetector(
                  onTap: _openCommunicationHub,
                  onLongPress: _toggleQuickAccess,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _getHubColor(),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: _getHubColor().withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                        if (widget.hasUrgentNotifications)
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            offset: const Offset(0, 0),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Main Icon
                        Center(
                          child: Icon(
                            Symbols.hub,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        
                        // Unread Count Badge
                        if (widget.unreadCount > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: widget.hasUrgentNotifications 
                                    ? Colors.red 
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                widget.unreadCount > 99 ? '99+' : '${widget.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        
                        // Urgent Indicator
                        if (widget.hasUrgentNotifications)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Label
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getHubLabel(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessMenu() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getHubColor(),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          
          // Quick Actions
          _buildQuickAction(
            icon: Symbols.chat,
            label: 'Messages',
            onTap: () => _openHubSection('messages'),
          ),
          _buildQuickAction(
            icon: Symbols.support_agent,
            label: 'Tickets',
            onTap: () => _openHubSection('tickets'),
          ),
          _buildQuickAction(
            icon: Symbols.folder_shared,
            label: 'Documents',
            onTap: () => _openHubSection('documents'),
          ),
          _buildQuickAction(
            icon: Symbols.event,
            label: 'Meetings',
            onTap: () => _openHubSection('meetings'),
          ),
          _buildQuickAction(
            icon: Symbols.notifications,
            label: 'Notifications',
            onTap: () => _openHubSection('notifications'),
          ),
          
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          
          // Available Channels
          Text(
            'Available Channels',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          ..._getAvailableChannels().map((channel) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                Icon(
                  Symbols.radio_button_checked,
                  size: 8,
                  color: _getHubColor(),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    channel,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: _getHubColor(),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCommunicationHub() {
    setState(() {
      _isExpanded = false;
    });
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommunicationHubScreen(
          userRole: widget.userRole,
        ),
      ),
    );
  }

  void _openHubSection(String section) {
    setState(() {
      _isExpanded = false;
    });
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommunicationHubScreen(
          userRole: widget.userRole,
          initialSection: section,
        ),
      ),
    );
  }

  void _toggleQuickAccess() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}

// Compact version for smaller screens
class CompactCommunicationHubButton extends StatelessWidget {
  final UserRole userRole;
  final int unreadCount;
  final bool hasUrgentNotifications;

  const CompactCommunicationHubButton({
    super.key,
    required this.userRole,
    this.unreadCount = 0,
    this.hasUrgentNotifications = false,
  });

  Color _getHubColor() {
    switch (userRole) {
      case UserRole.centreAdmin:
        return const Color(0xFF3F51B5);
      case UserRole.stateOfficer:
        return const Color(0xFF1976D2);
      case UserRole.agencyUser:
        return const Color(0xFF26A69A);
      case UserRole.auditor:
        return const Color(0xFF7B1FA2);
      case UserRole.publicViewer:
        return const Color(0xFF388E3C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openCommunicationHub(context),
      backgroundColor: _getHubColor(),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Symbols.hub,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: hasUrgentNotifications ? Colors.red : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openCommunicationHub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommunicationHubScreen(
          userRole: userRole,
        ),
      ),
    );
  }
}
