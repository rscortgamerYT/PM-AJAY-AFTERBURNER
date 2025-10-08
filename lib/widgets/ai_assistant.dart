import 'package:flutter/material.dart';

class PMajayAIAssistant extends StatefulWidget {
  final String userRole;
  final String context;

  const PMajayAIAssistant({
    super.key,
    required this.userRole,
    this.context = 'general',
  });

  @override
  State<PMajayAIAssistant> createState() => _PMajayAIAssistantState();
}

class _PMajayAIAssistantState extends State<PMajayAIAssistant>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  String _selectedLanguage = 'English';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = _getWelcomeMessage();
    setState(() {
      _messages.add(ChatMessage(
        text: welcomeMessage,
        isUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.welcome,
      ));
    });
  }

  String _getWelcomeMessage() {
    switch (widget.userRole.toLowerCase()) {
      case 'centre admin':
        return 'नमस्ते! I\'m your PM-AJAY AI Assistant. I can help you with:\n• National policy guidance\n• Fund allocation queries\n• State performance insights\n• Compliance monitoring\n\nHow can I assist you today?';
      case 'state officer':
        return 'नमस्ते! I\'m here to help with state-level operations:\n• Agency management guidance\n• Public request processing\n• Compliance verification\n• District coordination\n\nWhat would you like to know?';
      case 'agency user':
        return 'नमस्ते! I can assist with project execution:\n• Evidence submission guidelines\n• Document requirements\n• Process navigation\n• Quality standards\n\nHow can I help you today?';
      case 'public':
        return 'नमस्ते! Welcome to PM-AJAY support:\n• Scheme eligibility checker\n• Application process guide\n• Status tracking help\n• Document requirements\n\nWhat information do you need?';
      default:
        return 'नमस्ते! Welcome to PM-AJAY AI Assistant. How can I help you today?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildLanguageSelector(),
          Expanded(child: _buildChatArea()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3F51B5),
            const Color(0xFF3F51B5).withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2 + _pulseController.value * 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PM-AJAY AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.userRole} Support • Powered by Bhashini',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final languages = [
      'English', 'हिंदी', 'বাংলা', 'தமிழ்', 'తెలుగు', 'ಕನ್ನಡ', 
      'മലയാളം', 'ગુજરાતી', 'ਪੰਜਾਬੀ', 'मराठी', 'ଓଡ଼ିଆ', 'অসমীয়া'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.translate, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: languages.map((lang) {
                  final isSelected = lang == _selectedLanguage;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        lang,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedLanguage = lang;
                        });
                        _handleLanguageChange(lang);
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color(0xFF3F51B5),
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length + (_isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _messages.length && _isTyping) {
            return _buildTypingIndicator();
          }
          return _buildMessageBubble(_messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF3F51B5),
              child: const Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? const Color(0xFF3F51B5) 
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: message.isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.messageType == MessageType.welcome)
                    _buildWelcomeContent(message.text)
                  else
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  if (message.quickReplies.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: message.quickReplies.map((reply) {
                        return ActionChip(
                          label: Text(
                            reply,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () => _handleQuickReply(reply),
                          backgroundColor: Colors.blue[50],
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser ? Colors.white70 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 16, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWelcomeContent(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        _buildQuickActionButtons(),
      ],
    );
  }

  Widget _buildQuickActionButtons() {
    final actions = _getQuickActions();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((action) {
        return ElevatedButton.icon(
          onPressed: () => _handleQuickAction(action['action']!),
          icon: Icon(action['icon'] as IconData, size: 16),
          label: Text(
            action['label']!,
            style: const TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F51B5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getQuickActions() {
    switch (widget.userRole.toLowerCase()) {
      case 'centre admin':
        return [
          {'label': 'Fund Status', 'icon': Icons.account_balance_wallet, 'action': 'fund_status'},
          {'label': 'State Performance', 'icon': Icons.analytics, 'action': 'state_performance'},
          {'label': 'Policy Guide', 'icon': Icons.policy, 'action': 'policy_guide'},
        ];
      case 'state officer':
        return [
          {'label': 'Agency Status', 'icon': Icons.business, 'action': 'agency_status'},
          {'label': 'Public Requests', 'icon': Icons.request_page, 'action': 'public_requests'},
          {'label': 'Compliance Check', 'icon': Icons.verified, 'action': 'compliance_check'},
        ];
      case 'agency user':
        return [
          {'label': 'Submit Evidence', 'icon': Icons.upload_file, 'action': 'submit_evidence'},
          {'label': 'Project Guide', 'icon': Icons.help_outline, 'action': 'project_guide'},
          {'label': 'Quality Standards', 'icon': Icons.star, 'action': 'quality_standards'},
        ];
      case 'public':
        return [
          {'label': 'Check Eligibility', 'icon': Icons.check_circle, 'action': 'check_eligibility'},
          {'label': 'Track Request', 'icon': Icons.track_changes, 'action': 'track_request'},
          {'label': 'Submit Request', 'icon': Icons.add_circle, 'action': 'submit_request'},
        ];
      default:
        return [
          {'label': 'General Help', 'icon': Icons.help, 'action': 'general_help'},
        ];
    }
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF3F51B5),
            child: const Icon(Icons.smart_toy, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final delay = index * 0.3;
        final animationValue = (_pulseController.value + delay) % 1.0;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3 + animationValue * 0.7),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _handleVoiceInput,
            icon: const Icon(Icons.mic, color: Color(0xFF3F51B5)),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message... (${_selectedLanguage})',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: () => _sendMessage(_messageController.text),
            backgroundColor: const Color(0xFF3F51B5),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: _generateAIResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
          quickReplies: _getContextualReplies(text),
        ));
      });
      _scrollToBottom();
    });
  }

  String _generateAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Context-aware responses based on user role and message content
    if (message.contains('fund') || message.contains('budget')) {
      return _getFundRelatedResponse();
    } else if (message.contains('project') || message.contains('status')) {
      return _getProjectRelatedResponse();
    } else if (message.contains('help') || message.contains('guide')) {
      return _getHelpResponse();
    } else if (message.contains('eligibility') || message.contains('scheme')) {
      return _getEligibilityResponse();
    } else {
      return _getGeneralResponse();
    }
  }

  String _getFundRelatedResponse() {
    switch (widget.userRole.toLowerCase()) {
      case 'centre admin':
        return 'Current fund allocation status:\n• Total Budget: ₹15,000 Cr\n• Allocated: ₹12,500 Cr (83%)\n• Utilized: ₹10,200 Cr (68%)\n\nTop performing states: Maharashtra, Karnataka, Tamil Nadu\nStates needing attention: Bihar, Jharkhand\n\nWould you like detailed state-wise breakdown?';
      case 'state officer':
        return 'Your state fund status:\n• Allocated: ₹2,000 Cr\n• Utilized: ₹1,500 Cr (75%)\n• Pending approvals: ₹200 Cr\n• Available for new projects: ₹300 Cr\n\nNext fund release expected: 15th of next month\n\nNeed help with fund request submission?';
      default:
        return 'I can help you understand fund allocation and utilization. What specific information do you need?';
    }
  }

  String _getProjectRelatedResponse() {
    switch (widget.userRole.toLowerCase()) {
      case 'agency user':
        return 'Your project status overview:\n• Active Projects: 12\n• Pending Evidence: 3 projects\n• Upcoming Deadlines: 2 projects (next 7 days)\n• Quality Score: 4.2/5.0\n\nNext actions needed:\n1. Submit evidence for Project #PM001\n2. Update milestone for Project #PM005\n\nWould you like detailed guidance for any project?';
      case 'state officer':
        return 'State project overview:\n• Total Projects: 245\n• On Track: 180 (73%)\n• Delayed: 45 (18%)\n• At Risk: 20 (8%)\n\nTop performing agencies: Infrastructure Corp, Rural Dev Agency\nAgencies needing support: Urban Planning Ltd\n\nWould you like to drill down into specific projects?';
      default:
        return 'I can provide project status and guidance. What specific project information do you need?';
    }
  }

  String _getHelpResponse() {
    return 'I\'m here to help! Here are some things I can assist with:\n\n📋 Process Guidance\n💰 Fund Information\n📊 Status Updates\n📝 Documentation Help\n🔍 Compliance Checks\n\nYou can also use voice commands in ${_selectedLanguage}. Just tap the microphone icon!\n\nWhat would you like to know more about?';
  }

  String _getEligibilityResponse() {
    return 'PM-AJAY Eligibility Checker:\n\n✅ For Individuals:\n• Scheduled Caste/Scheduled Tribe community\n• Annual income below ₹3 lakh\n• Age 18-60 years\n• Valid Aadhaar card\n\n✅ For Organizations:\n• Registered NGO/Trust\n• 3+ years experience\n• Audited financial statements\n• Valid registrations\n\nWould you like me to check specific eligibility criteria or help with application process?';
  }

  String _getGeneralResponse() {
    return 'I understand you need assistance. I can help with:\n\n• Scheme information and eligibility\n• Application processes and requirements\n• Status tracking and updates\n• Document submission guidelines\n• Compliance and quality standards\n\nPlease let me know what specific information you\'re looking for, and I\'ll provide detailed guidance in ${_selectedLanguage}.';
  }

  List<String> _getContextualReplies(String message) {
    if (message.toLowerCase().contains('fund')) {
      return ['State-wise breakdown', 'Utilization report', 'Next release date'];
    } else if (message.toLowerCase().contains('project')) {
      return ['Project details', 'Timeline', 'Evidence requirements'];
    } else {
      return ['More info', 'Step-by-step guide', 'Contact support'];
    }
  }

  void _handleQuickReply(String reply) {
    _sendMessage(reply);
  }

  void _handleQuickAction(String action) {
    String response = '';
    
    switch (action) {
      case 'fund_status':
        response = 'Show me current fund allocation status';
        break;
      case 'check_eligibility':
        response = 'Check my eligibility for PM-AJAY schemes';
        break;
      case 'submit_evidence':
        response = 'How do I submit project evidence?';
        break;
      case 'track_request':
        response = 'Help me track my request status';
        break;
      default:
        response = 'Help me with $action';
    }
    
    _sendMessage(response);
  }

  void _handleLanguageChange(String language) {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Language switched to $language. I can now assist you in your preferred language. How can I help you?',
        isUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.system,
      ));
    });
    _scrollToBottom();
  }

  void _handleVoiceInput() {
    // Voice input implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice input in $_selectedLanguage - Feature coming soon!'),
        backgroundColor: const Color(0xFF3F51B5),
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType messageType;
  final List<String> quickReplies;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.messageType = MessageType.normal,
    this.quickReplies = const [],
  });
}

enum MessageType {
  normal,
  welcome,
  system,
  error,
}

// AI Assistant Floating Action Button
class AIAssistantFAB extends StatelessWidget {
  final String userRole;
  final String context;

  const AIAssistantFAB({
    super.key,
    required this.userRole,
    this.context = 'general',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAIAssistant(context),
      backgroundColor: const Color(0xFF3F51B5),
      icon: const Icon(Icons.smart_toy, color: Colors.white),
      label: const Text(
        'AI Assistant',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showAIAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PMajayAIAssistant(
        userRole: userRole,
        context: this.context,
      ),
    );
  }
}
