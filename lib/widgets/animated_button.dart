import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ButtonStyle? style;
  final bool isLoading;
  final bool isOutlined;
  final bool isText;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
    this.isLoading = false,
    this.isOutlined = false,
    this.isText = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget button;
    
    if (widget.isText) {
      button = _buildTextButton();
    } else if (widget.isOutlined) {
      button = _buildOutlinedButton();
    } else {
      button = _buildElevatedButton();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: button,
          ),
        );
      },
    );
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 48,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: widget.style ?? ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? AppTheme.primaryIndigo,
          foregroundColor: widget.foregroundColor ?? Colors.white,
          elevation: 2,
          shadowColor: AppTheme.cardShadow.first.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          padding: widget.padding ?? const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing4,
            vertical: AppTheme.spacing3,
          ),
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 48,
      child: OutlinedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: widget.style ?? OutlinedButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? AppTheme.primaryIndigo,
          side: BorderSide(
            color: widget.backgroundColor ?? AppTheme.primaryIndigo,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          padding: widget.padding ?? const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing4,
            vertical: AppTheme.spacing3,
          ),
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildTextButton() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: widget.style ?? TextButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? AppTheme.primaryIndigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          padding: widget.padding ?? const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing4,
            vertical: AppTheme.spacing2,
          ),
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.isText || widget.isOutlined 
                ? AppTheme.primaryIndigo 
                : Colors.white,
          ),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18),
          const SizedBox(width: AppTheme.spacing2),
          Text(
            widget.text,
            style: const TextStyle(
              fontFamily: AppTheme.primaryFontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: const TextStyle(
        fontFamily: AppTheme.primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class FloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool mini;

  const FloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.mini = false,
  });

  @override
  State<FloatingActionButton> createState() => _FloatingActionButtonState();
}

class _FloatingActionButtonState extends State<FloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.bounceOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 0.1,
            child: Container(
              width: widget.mini ? 40 : 56,
              height: widget.mini ? 40 : 56,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? AppTheme.secondaryTeal,
                borderRadius: BorderRadius.circular(widget.mini ? 20 : 28),
                boxShadow: AppTheme.floatingShadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: BorderRadius.circular(widget.mini ? 20 : 28),
                  child: Icon(
                    widget.icon,
                    color: widget.foregroundColor ?? Colors.white,
                    size: widget.mini ? 20 : 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PulseButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? pulseColor;
  final Duration pulseDuration;
  final bool enablePulse;

  const PulseButton({
    super.key,
    required this.child,
    this.onPressed,
    this.pulseColor,
    this.pulseDuration = const Duration(seconds: 2),
    this.enablePulse = true,
  });

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeInOut,
    ));
    
    if (widget.enablePulse) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.enablePulse)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.pulseColor ?? AppTheme.primaryIndigo)
                          .withOpacity(_opacityAnimation.value),
                    ),
                    child: widget.child,
                  ),
                );
              },
            ),
          widget.child,
        ],
      ),
    );
  }
}
