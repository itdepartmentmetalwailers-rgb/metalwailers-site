import 'dart:js' as dartJs;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappFloatingButton extends StatefulWidget {
  const WhatsappFloatingButton({super.key});

  @override
  State<WhatsappFloatingButton> createState() => _WhatsappFloatingButtonState();
}

class _WhatsappFloatingButtonState extends State<WhatsappFloatingButton> {
  bool _isHovered = false;

  // ===== Helper GTM seguro =====
  void _gtmPush(String event, Map<String, dynamic> data) {
    final payload = {'event': event, ...data};
    // ignore: avoid_print
    print('[GTM] push $payload');
    if (!kIsWeb) return;
    try {
      dynamic dl;
      try {
        dl = dartJs.context['dataLayer'];
      } catch (_) {
        dl = null;
      }
      if (dl == null) {
        dartJs.context.callMethod('console.log',
            const ['[GTM] dataLayer not found (local / early load)']);
        return;
      }
      if (dl is dartJs.JsObject) {
        dl.callMethod('push', [dartJs.JsObject.jsify(payload)]);
      } else {
        dartJs.context.callMethod('console.log',
            const ['[GTM] dataLayer exists but is not a JsObject']);
      }
    } catch (e) {
      // ignore: avoid_print
      print('[GTM] Error pushing event: $e');
    }
  }
  // =============================

  void _openWhatsapp() async {
    _gtmPush('whatsapp_click', {'location': 'floating_button'});
    final url = Uri.parse('https://wa.me/5491162913437');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    }
  }

  bool get _esWebDesktop =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  @override
  Widget build(BuildContext context) {
    final icono = AnimatedScale(
      scale: _isHovered && _esWebDesktop ? 2.0 : 1.4,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color(0xFF25D366),
          shape: BoxShape.circle,
        ),
        child: const FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 40,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(onTap: _openWhatsapp, child: icono),
      ),
    );
  }
}
