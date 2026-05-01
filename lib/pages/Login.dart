import '/components/button/button_widget.dart';
import '/components/role_card/role_card_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'login_screen_model.dart';
export 'login_screen_model.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  static String routeName = 'LoginScreen';
  static String routePath = '/loginScreen';

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  late LoginScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(24),
                                shape: BoxShape.rectangle,
                              ),
                              alignment: AlignmentDirectional(0, 0),
                              child: Icon(
                                Icons.security_rounded,
                                color: FlutterFlowTheme.of(context).onPrimary,
                                size: 40,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'SafeGuard School',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                        lineHeight: 1.25,
                                      ),
                                ),
                                Text(
                                  'Nurturing Safety, Ensuring Care',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.45,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4)),
                            ),
                          ].divide(SizedBox(height: 16)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              'Please select your role and sign in',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.45,
                                  ),
                            ),
                          ].divide(SizedBox(height: 8)),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 8),
                            child: Container(
                              child: Text(
                                'I am a...',
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                      lineHeight: 1.3,
                                    ),
                              ),
                            ),
                          ),
                          wrapWithModel(
                            model: _model.roleCardModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: RoleCardWidget(
                              description: 'Manage children & authorizations',
                              icon: Icon(
                                Icons.family_restroom_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24,
                              ),
                              title: 'Parent / Tutor',
                              selected: true,
                            ),
                          ),
                          wrapWithModel(
                            model: _model.roleCardModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: RoleCardWidget(
                              description: 'Scan QR & validate identity',
                              icon: Icon(
                                Icons.shield_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                              title: 'Security Guard',
                              selected: false,
                            ),
                          ),
                          wrapWithModel(
                            model: _model.roleCardModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: RoleCardWidget(
                              description: 'Reports & school management',
                              icon: Icon(
                                Icons.admin_panel_settings_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                              title: 'Administrator',
                              selected: false,
                            ),
                          ),
                        ].divide(SizedBox(height: 0)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          wrapWithModel(
                            model: _model.textFieldModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: TextFieldWidget(
                              label: false,
                              helper: false,
                              hint: 'parent@school.com',
                              value: '',
                              leading_icon: Icon(
                                Icons.email_outlined,
                              ),
                              leading_icon_present: true,
                              trailing_icon_present: false,
                              variant: 'outlined',
                              error: false,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              wrapWithModel(
                                model: _model.textFieldModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: TextFieldWidget(
                                  label: false,
                                  helper: false,
                                  hint: '••••••••',
                                  value: '',
                                  leading_icon: Icon(
                                    Icons.lock_outlined,
                                  ),
                                  leading_icon_present: true,
                                  trailing_icon: Icon(
                                    Icons.visibility_outlined,
                                  ),
                                  trailing_icon_present: true,
                                  variant: 'outlined',
                                  error: false,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1, -1),
                                child: Container(
                                  child: wrapWithModel(
                                    model: _model.buttonModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: ButtonWidget(
                                      content: 'Forgot Password?',
                                      icon_present: false,
                                      icon_end_present: false,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      bg: FlutterFlowTheme.of(context).tertiary,
                                      on_tap: 'navigate:PickupHistory',
                                      variant: 'ghost',
                                      size: 'small',
                                      full_width: false,
                                      loading: false,
                                      disabled: false,
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 4)),
                          ),
                        ].divide(SizedBox(height: 16)),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondary,
                                borderRadius: BorderRadius.circular(24),
                                shape: BoxShape.rectangle,
                              ),
                              alignment: AlignmentDirectional(0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .onSurface,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                          lineHeight: 1.35,
                                        ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).onSurface,
                                    size: 20,
                                  ),
                                ].divide(SizedBox(width: 8)),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Divider(
                                    height: 16,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                Text(
                                  'OR',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .onSurface,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                        lineHeight: 1.2,
                                      ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Divider(
                                    height: 16,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                              ].divide(SizedBox(width: 16)),
                            ),
                            wrapWithModel(
                              model: _model.buttonModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                content: 'Sign in with Biometrics',
                                icon: Icon(
                                  Icons.fingerprint_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 16,
                                ),
                                icon_present: true,
                                icon_end_present: false,
                                color: FlutterFlowTheme.of(context).primary,
                                bg: FlutterFlowTheme.of(context).tertiary,
                                on_tap: 'navigate:PickupHistory',
                                variant: 'outline',
                                size: 'medium',
                                full_width: true,
                                loading: false,
                                disabled: false,
                              ),
                            ),
                          ].divide(SizedBox(height: 16)),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                          child: Container(
                            child: Container(
                              alignment: AlignmentDirectional(0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'New to SafeGuard?',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.45,
                                        ),
                                  ),
                                  Text(
                                    'Contact Admin',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          decoration: TextDecoration.underline,
                                          lineHeight: 1.45,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 4)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 24)),
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
