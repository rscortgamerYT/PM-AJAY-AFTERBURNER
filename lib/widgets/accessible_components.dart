import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Accessibility-First Government Card Component
class AccessibleGovernmentCard extends StatelessWidget {
  final String title;
  final String value;
  final String? semanticLabel;
  final bool highContrast;
  final IconData? icon;
  final Color? accentColor;
  final VoidCallback? onTap;
  final String? description;

  const AccessibleGovernmentCard({
    super.key,
    required this.title,
    required this.value,
    this.semanticLabel,
    this.highContrast = false,
    this.icon,
    this.accentColor,
    this.onTap,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveAccentColor = accentColor ?? theme.primaryColor;
    
    return Semantics(
      label: semanticLabel ?? '$title: $value${description != null ? '. $description' : ''}',
      button: onTap != null,
      enabled: onTap != null,
      child: Card(
        elevation: highContrast ? 8 : 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            // WCAG AAA contrast ratio compliance
            color: highContrast ? Colors.black : theme.cardColor,
            padding: const EdgeInsets.all(20), // Minimum 44px touch targets
            constraints: const BoxConstraints(
              minHeight: 120, // Adequate touch target size
              minWidth: 120,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (highContrast ? Colors.yellow : effectiveAccentColor)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: highContrast ? Colors.yellow : effectiveAccentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Title with proper contrast
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16, // Minimum readable size
                    fontWeight: FontWeight.w600,
                    color: highContrast ? Colors.white : theme.textTheme.titleMedium?.color,
                    height: 1.4, // Better line spacing for readability
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Value with high contrast support
                ExcludeSemantics(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: highContrast 
                          ? Colors.yellow 
                          : effectiveAccentColor,
                      height: 1.2,
                    ),
                  ),
                ),
                
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: highContrast 
                          ? Colors.white70 
                          : theme.textTheme.bodySmall?.color,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Accessible Button with Enhanced Touch Targets
class AccessibleElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool highContrast;
  final bool isLoading;
  final String? semanticLabel;

  const AccessibleElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.highContrast = false,
    this.isLoading = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: SizedBox(
        height: 48, // Minimum touch target height
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : (icon != null ? Icon(icon) : const SizedBox.shrink()),
          label: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: highContrast ? Colors.black : null,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: highContrast ? Colors.yellow : null,
            foregroundColor: highContrast ? Colors.black : null,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: highContrast 
                  ? const BorderSide(color: Colors.white, width: 2)
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

// Accessible Form Field with Enhanced Labels
class AccessibleFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool required;
  final bool highContrast;
  final IconData? prefixIcon;
  final int? maxLines;

  const AccessibleFormField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.required = false,
    this.highContrast = false,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: '$label${required ? ' (required)' : ''}${hint != null ? '. $hint' : ''}',
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: highContrast ? Colors.white : theme.textTheme.labelLarge?.color,
              ),
              children: required ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: highContrast ? Colors.yellow : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] : null,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 16,
              color: highContrast ? Colors.white : null,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: highContrast ? Colors.white60 : null,
              ),
              prefixIcon: prefixIcon != null 
                  ? Icon(
                      prefixIcon,
                      color: highContrast ? Colors.yellow : null,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: highContrast ? Colors.white : Colors.grey,
                  width: highContrast ? 2 : 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: highContrast ? Colors.white : Colors.grey,
                  width: highContrast ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: highContrast ? Colors.yellow : theme.primaryColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: highContrast 
                  ? Colors.grey[900] 
                  : theme.inputDecorationTheme.fillColor,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}

// Accessible Navigation with Screen Reader Support
class AccessibleBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<AccessibleNavItem> items;
  final bool highContrast;

  const AccessibleBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.highContrast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highContrast ? Colors.black : null,
        border: highContrast 
            ? const Border(top: BorderSide(color: Colors.white, width: 2))
            : null,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Haptic feedback for accessibility
          HapticFeedback.selectionClick();
          onTap(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: highContrast ? Colors.black : null,
        selectedItemColor: highContrast ? Colors.yellow : null,
        unselectedItemColor: highContrast ? Colors.white : null,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: items.map((item) {
          final isSelected = items.indexOf(item) == currentIndex;
          return BottomNavigationBarItem(
            icon: Semantics(
              label: '${item.label}${isSelected ? ' (selected)' : ''}',
              selected: isSelected,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: isSelected && highContrast
                    ? BoxDecoration(
                        color: Colors.yellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Icon(
                  item.icon,
                  size: 24,
                  semanticLabel: item.semanticLabel,
                ),
              ),
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class AccessibleNavItem {
  final String label;
  final IconData icon;
  final String? semanticLabel;

  const AccessibleNavItem({
    required this.label,
    required this.icon,
    this.semanticLabel,
  });
}

// High Contrast Theme Provider
class AccessibilityTheme {
  static ThemeData getHighContrastTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.yellow,
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.grey[900],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
        titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[900],
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.yellow,
        secondary: Colors.yellow,
        surface: Colors.black,
        background: Colors.black,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
    );
  }

  static ThemeData getStandardTheme() {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.indigo,
      primaryColor: const Color(0xFF3F51B5),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3F51B5),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, height: 1.4),
        bodyMedium: TextStyle(fontSize: 14, height: 1.4),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.2),
      ),
    );
  }
}

// Accessibility Settings Widget
class AccessibilitySettings extends StatefulWidget {
  final Function(bool) onHighContrastChanged;
  final Function(double) onTextScaleChanged;
  final bool initialHighContrast;
  final double initialTextScale;

  const AccessibilitySettings({
    super.key,
    required this.onHighContrastChanged,
    required this.onTextScaleChanged,
    this.initialHighContrast = false,
    this.initialTextScale = 1.0,
  });

  @override
  State<AccessibilitySettings> createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  late bool _highContrast;
  late double _textScale;

  @override
  void initState() {
    super.initState();
    _highContrast = widget.initialHighContrast;
    _textScale = widget.initialTextScale;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Accessibility Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // High Contrast Toggle
        Semantics(
          label: 'High contrast mode toggle. Currently ${_highContrast ? 'enabled' : 'disabled'}',
          child: SwitchListTile(
            title: const Text('High Contrast Mode'),
            subtitle: const Text('Improves visibility with high contrast colors'),
            value: _highContrast,
            onChanged: (value) {
              setState(() {
                _highContrast = value;
              });
              widget.onHighContrastChanged(value);
              HapticFeedback.selectionClick();
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Text Scale Slider
        Semantics(
          label: 'Text size adjustment. Current scale: ${_textScale.toStringAsFixed(1)}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Text Size',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _textScale,
                min: 0.8,
                max: 2.0,
                divisions: 12,
                label: '${(_textScale * 100).round()}%',
                onChanged: (value) {
                  setState(() {
                    _textScale = value;
                  });
                  widget.onTextScaleChanged(value);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Small',
                    style: TextStyle(
                      fontSize: 12 * _textScale,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Normal',
                    style: TextStyle(
                      fontSize: 14 * _textScale,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Large',
                    style: TextStyle(
                      fontSize: 16 * _textScale,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Screen Reader Information
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.accessibility, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Screen Reader Support',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'This app is optimized for screen readers like TalkBack (Android) and VoiceOver (iOS). All interactive elements have proper semantic labels.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
