// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:js' as js; // para llamar gtag_report_conversion en web

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:metalwailers/widgets/animated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Contactanos extends StatefulWidget {
  const Contactanos({super.key});

  @override
  State<Contactanos> createState() => _ContactanosState();
}

class _ContactanosState extends State<Contactanos>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _rubroController = TextEditingController();
  final _comentariosController = TextEditingController();

  // FocusNodes (para autovalidar solo el campo tocado)
  final _fnName = FocusNode();
  final _fnEmail = FocusNode();
  final _fnPhone = FocusNode();
  final _fnRubro = FocusNode();
  final _fnComentarios = FocusNode();

  late final AnimationController _lottieCtrl;

  // Flags de autovalidación por campo
  bool _avName = false,
      _avEmail = false,
      _avPhone = false,
      _avRubro = false,
      _avComentarios = false;
  bool _avServicio = false;

  String? selectedServicio;
  bool _sending = false;

  // Regex email simple/efectiva
  static final _emailRegExp = RegExp(
    r"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$",
    caseSensitive: false,
  );

  // Para contar dígitos del teléfono
  static final _phoneDigits = RegExp(r"\d");

  @override
  void initState() {
    super.initState();

    _lottieCtrl = AnimationController(vsync: this);

    _fnName.addListener(() {
      if (!_fnName.hasFocus) setState(() => _avName = true);
    });
    _fnEmail.addListener(() {
      if (!_fnEmail.hasFocus) setState(() => _avEmail = true);
    });
    _fnPhone.addListener(() {
      if (!_fnPhone.hasFocus) setState(() => _avPhone = true);
    });
    _fnRubro.addListener(() {
      if (!_fnRubro.hasFocus) setState(() => _avRubro = true);
    });
    _fnComentarios.addListener(() {
      if (!_fnComentarios.hasFocus) setState(() => _avComentarios = true);
    });
  }

  @override
  void dispose() {
    _lottieCtrl.dispose();

    _fnName.dispose();
    _fnEmail.dispose();
    _fnPhone.dispose();
    _fnRubro.dispose();
    _fnComentarios.dispose();

    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _rubroController.dispose();
    _comentariosController.dispose();
    super.dispose();
  }

  Future<void> sendEmails({
    required String nombre,
    required String email,
    required String telefono,
    required String servicio,
    required String rubro,
    required String comentarios,
  }) async {
    final functionUrl = Uri.parse(
      'https://metalwailers-mail-9556.twil.io/send-email',
    );
    final headers = {'Content-Type': 'application/json'};

    final r = await http.post(
      functionUrl,
      headers: headers,
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'telefono': telefono,
        'servicio': servicio,
        'rubro': rubro,
        'comentarios': comentarios,
      }),
    );

    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Function error ${r.statusCode}: ${r.body}');
    }
  }

  // --- GTM helper: push a dataLayer + console.log ---
  void _pushGtmEvent(String event, Map<String, dynamic> data) {
    final payload = {'event': event, ...data};

    // print siempre funciona
    // ignore: avoid_print
    print('[GTM] push $payload');

    try {
      // dataLayer.push
      final jsPayload = js.JsObject.jsify(payload);
      final dl = js.context['dataLayer'];
      if (dl == null) {
        js.context['dataLayer'] = js.JsArray();
        (js.context['dataLayer'] as js.JsObject).callMethod('push', [
          jsPayload,
        ]);
      } else {
        (dl as js.JsObject).callMethod('push', [jsPayload]);
      }
    } catch (_) {}

    // console.log seguro
    try {
      final console = js.context['console'];
      if (console is js.JsObject) {
        console.callMethod('log', ['[GTM] push', js.JsObject.jsify(payload)]);
      }
    } catch (_) {}
  }

  Future<void> _showSuccessDialog() async {
    _lottieCtrl.reset();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Lottie.asset(
                      'assets/lottie/success.json',
                      controller: _lottieCtrl,
                      onLoaded: (comp) {
                        // Duración máxima de visualización: 4s
                        const maxWait = Duration(seconds: 4);
                        final animDuration = comp.duration;
                        final playFor =
                            animDuration > maxWait ? maxWait : animDuration;

                        _lottieCtrl.duration = playFor;
                        // 🔧 forward SOLO una vez
                        final forwardFuture = _lottieCtrl.forward();

                        // Cerrar cuando termine (o a los 4s, lo que ocurra primero)
                        Future.any([
                          forwardFuture,
                          Future.delayed(playFor),
                        ]).whenComplete(() {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '¡Gracias por contactarte!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Recibimos tu consulta y te responderemos a la brevedad.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _emailController.clear();
    _nameController.clear();
    _phoneController.clear();
    _rubroController.clear();
    _comentariosController.clear();
    setState(() {
      selectedServicio = null;
      _avName =
          _avEmail = _avPhone = _avRubro = _avComentarios = _avServicio = false;
    });
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Este campo es requerido' : null;

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Este campo es requerido';
    return _emailRegExp.hasMatch(v.trim()) ? null : 'Email inválido';
  }

  String? _phoneValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Este campo es requerido';
    final digitsCount = _phoneDigits.allMatches(v).length;
    if (digitsCount < 7) return 'Teléfono inválido';
    return null;
  }

  Future<void> _onSubmit() async {
    // Si no es válido, mostrar errores de TODOS (por única vez) y salir
    if (!(_formKey.currentState!.validate()) || selectedServicio == null) {
      setState(() {
        _avName =
            _avEmail =
                _avPhone = _avRubro = _avComentarios = _avServicio = true;
      });
      return;
    }

    setState(() => _sending = true);
    try {
      await sendEmails(
        nombre: _nameController.text.trim(),
        email: _emailController.text.trim(),
        telefono: _phoneController.text.trim(),
        servicio: selectedServicio!,
        rubro: _rubroController.text.trim(),
        comentarios: _comentariosController.text.trim(),
      );

      // Dispara conversión (solo web)
      if (kIsWeb) {
        try {
          js.context.callMethod('gtag_report_conversion', ['/gracias']);
        } catch (_) {}
      }

      // Evento de marketing + console.log
      _pushGtmEvent('social_click', {
        'social_network': 'form',
        'social_action': 'submit',
        'social_target': 'contactanos',
        'value': 1,
      });

      await _showSuccessDialog();
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: const Text(
            'Hubo un problema al enviar la consulta. Intentá nuevamente.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  /// ------- BUILD con Enter global -------
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpadEnter): const ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              // No enviar si el foco está en Comentarios (Enter = nueva línea)
              if (!_fnComentarios.hasFocus && !_sending) {
                _onSubmit();
              }
              return null;
            },
          ),
        },
        child: const Focus(autofocus: true, child: SizedBox()),
      ),
    ).copyWithChild(_buildContent());
  }

  /// Contenido original (Row/Column segun ancho)
  Widget _buildContent() {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;

    return isWide
        ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _leftColumn()),
            const SizedBox(width: 40),
            Expanded(child: _rightColumn()),
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_leftColumn(), const SizedBox(height: 32), _rightColumn()],
        );
  }

  Widget _leftColumn() {
    final items = [
      [
        'Whatsapp',
        '1162913437',
        FontAwesomeIcons.whatsapp,
        'https://wa.me/5491162913437',
      ],
      [
        'Email',
        'itdepartmentmetalwailers@gmail.com',
        FontAwesomeIcons.envelope,
        'mailto:itdepartmentmetalwailers@gmail.com',
      ],
      [
        'Dirección',
        'GORRITI 1399, EL TALAR, TIGRE, PROV. BS.AS.',
        FontAwesomeIcons.locationDot,
        'https://www.google.com/maps/place/GORRITI+1399,+El+Talar',
      ],
      [
        'Instagram',
        '@metalwailers',
        FontAwesomeIcons.instagram,
        'https://www.instagram.com/metalwailers',
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        const Text(
          'Contáctanos',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 24),
        ...items.map(
          (item) => _InfoCard(
            title: item[0] as String,
            subtitle: item[1] as String,
            icon: item[2] as IconData,
            url: item[3] as String,
          ),
        ),
      ],
    );
  }

  Widget _rightColumn() {
    final servicios = [
      'Asesoría y diseño',
      'Corte Láser CNC',
      'Corte Plasma CNC',
      'Soldadura',
      'Plegado / Curvado / Cilindrado',
      'Punzonado',
      'Balancinado',
      'Pintura a horno',
      'Solución metalúrgica integral',
    ];

    return StatefulBuilder(
      builder:
          (context, setStateSB) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Hablemos de tu Proyecto',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "¿Tenés una idea o necesitás una solución concreta? Te ayudamos a llevarla a cabo",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _inputField(
                      controller: _nameController,
                      label: 'Nombre y Apellido / Empresa',
                      validator: _required,
                      focusNode: _fnName,
                      autovalidate: _avName,
                      textInputAction: TextInputAction.next,
                      onSubmitted: () => _fnEmail.requestFocus(),
                    ),
                    const SizedBox(height: 16),

                    _inputField(
                      controller: _emailController,
                      label: 'Correo Electrónico',
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator,
                      focusNode: _fnEmail,
                      autovalidate: _avEmail,
                      textInputAction: TextInputAction.next,
                      onSubmitted: () => _fnPhone.requestFocus(),
                    ),
                    const SizedBox(height: 16),

                    _inputField(
                      controller: _phoneController,
                      label: 'Teléfono de contacto',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _phoneValidator,
                      focusNode: _fnPhone,
                      autovalidate: _avPhone,
                      textInputAction: TextInputAction.next,
                      onSubmitted: () => _fnRubro.requestFocus(),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedServicio,
                      autovalidateMode:
                          _avServicio
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                      onChanged: (value) {
                        setStateSB(() {
                          selectedServicio = value;
                          _avServicio =
                              true; // desde que lo tocan, valida solo él
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '¿Qué servicio estás buscando?',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator:
                          (v) =>
                              (v == null || v.isEmpty)
                                  ? 'Este campo es requerido'
                                  : null,
                      items:
                          servicios
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),

                    _inputField(
                      controller: _rubroController,
                      label: 'Rubro o industria de tu proyecto',
                      validator: _required,
                      focusNode: _fnRubro,
                      autovalidate: _avRubro,
                      textInputAction: TextInputAction.next,
                      onSubmitted: () => _fnComentarios.requestFocus(),
                    ),
                    const SizedBox(height: 16),

                    // Multiline + newline en comentarios
                    _inputField(
                      controller: _comentariosController,
                      label: 'Comentarios / Consulta específica',
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      validator: _required,
                      focusNode: _fnComentarios,
                      autovalidate: _avComentarios,
                      textInputAction:
                          TextInputAction.newline, // Enter = salto de línea
                    ),
                    const SizedBox(height: 24),

                    HoverAnimatedButton(
                      onPressed:
                          _sending
                              ? null
                              : () {
                                _onSubmit();
                              },
                      text: _sending ? "Enviando..." : "Enviar consulta",
                      loading: _sending,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    bool autovalidate = false,
    TextInputAction textInputAction = TextInputAction.next,
    VoidCallback? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autovalidateMode:
          autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted: (_) => onSubmitted?.call(),
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        errorMaxLines: 2,
      ).copyWith(labelText: label),
      validator: validator ?? _required,
    );
  }
}

/// Pequeña extensión para incrustar un child real dentro del árbol de Shortcuts/Actions
extension _WithChild on Widget {
  Widget copyWithChild(Widget child) {
    return Stack(children: [this, child]);
  }
}

class _InfoCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String url;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.url,
  });

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          transform:
              _isHover
                  ? Matrix4.translationValues(0, -6, 0)
                  : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _isHover ? Colors.grey.shade400 : Colors.grey.shade200,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                color: _isHover ? Colors.black : Colors.black87,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _isHover ? Colors.black : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
