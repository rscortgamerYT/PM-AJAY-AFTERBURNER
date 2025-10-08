import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;
  final bool enableGlassmorphism;
  final Gradient? gradient;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.enableHover = true,
    this.enableGlassmorphism = false,
    this.gradient,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 1,
      end: (widget.elevation ?? 1) + 4,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (!widget.enableHover) return;
    
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? const EdgeInsets.all(AppTheme.spacing2),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cardShadow.first.color,
                  offset: const Offset(0, 1),
                  blurRadius: _elevationAnimation.value * 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onHover: _onHover,
                borderRadius: widget.borderRadius ?? 
                    BorderRadius.circular(AppTheme.radiusMedium),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.enableGlassmorphism 
                        ? Colors.white.withOpacity(0.9)
                        : widget.backgroundColor ?? AppTheme.surfaceWhite,
                    gradient: widget.gradient,
                    borderRadius: widget.borderRadius ?? 
                        BorderRadius.circular(AppTheme.radiusMedium),
                    border: widget.borderColor != null
                        ? Border.all(
                            color: widget.borderColor!,
                            width: widget.borderWidth ?? 1,
                          )
                        : null,
                    backgroundBlendMode: widget.enableGlassmorphism 
                        ? BlendMode.overlay 
                        : null,
                  ),
                  padding: widget.padding ?? const EdgeInsets.all(AppTheme.spacing4),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color? accentColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showTrend;
  final double? trendValue;
  final bool isPositiveTrend;

  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.accentColor,
    this.onTap,
    this.trailing,
    this.showTrend = false,
    this.trendValue,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppTheme.primaryIndigo;
    
    return ModernCard(
      onTap: onTap,
      borderColor: effectiveAccentColor.withOpacity(0.2),
      borderWidth: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing2),
                decoration: BoxDecoration(
                  color: effectiveAccentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Icon(
                  icon,
                  color: effectiveAccentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacing1),
                    Row(
                      children: [
                        Text(
                          value,
                          style: AppTheme.h3.copyWith(
                            color: effectiveAccentColor,
                          ),
                        ),
                        if (showTrend && trendValue != null) ...[
                          const SizedBox(width: AppTheme.spacing2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing1,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isPositiveTrend 
                                  ? AppTheme.successGreen.withOpacity(0.1)
                                  : AppTheme.errorRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositiveTrend 
                                      ? Icons.trending_up 
                                      : Icons.trending_down,
                                  size: 12,
                                  color: isPositiveTrend 
                                      ? AppTheme.successGreen 
                                      : AppTheme.errorRed,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${trendValue!.abs().toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isPositiveTrend 
                                        ? AppTheme.successGreen 
                                        : AppTheme.errorRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacing2),
            Text(
              subtitle!,
              style: AppTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String? description;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onTap;

  const StatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    this.description,
    this.leading,
    this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppTheme.spacing3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.h3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacing1),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing2,
                        vertical: AppTheme.spacing1,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: AppTheme.spacing3),
            Text(
              description!,
              style: AppTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacing4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
          ],
        ],
      ),
    );
  }
}

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double opacity;
  final double blur;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.opacity = 0.1,
    this.blur = 10.0,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(AppTheme.spacing2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(
            color: Colors.white.withOpacity(opacity),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Container(
                padding: padding ?? const EdgeInsets.all(AppTheme.spacing4),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

