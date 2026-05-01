import '/components/quick_action/quick_action_widget.dart';
import '/components/student_card/student_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'parent_dashboard_model.dart';
export 'parent_dashboard_model.dart';

class ParentDashboardWidget extends StatefulWidget {
  const ParentDashboardWidget({super.key});

  static String routeName = 'ParentDashboard';
  static String routePath = '/parentDashboard';

  @override
  State<ParentDashboardWidget> createState() => _ParentDashboardWidgetState();
}

class _ParentDashboardWidgetState extends State<ParentDashboardWidget> {
  late ParentDashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ParentDashboardModel());
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
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 16),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hola, Familia García',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                        lineHeight: 1.3,
                                      ),
                                ),
                                Text(
                                  'Lunes, 24 de Octubre',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                        lineHeight: 1.4,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4)),
                            ),
                            FlutterFlowIconButton(
                              borderRadius: 8,
                              buttonSize: 48,
                              fillColor: Colors.transparent,
                              icon: Icon(
                                Icons.account_circle_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 32,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context).primary,
                                FlutterFlowTheme.of(context).tertiary
                              ],
                              stops: [0, 1],
                              begin: AlignmentDirectional(-1, 0),
                              end: AlignmentDirectional(1, 0),
                            ),
                            borderRadius: BorderRadius.circular(24),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.network(
                                    'https://dimg.dreamflow.cloud/v1/lottie/shield+security+protection',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.contain,
                                    animate: true,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Escuela Segura',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                                lineHeight: 1.3,
                                              ),
                                        ),
                                        Text(
                                          'Todos tus hijos han ingresado correctamente hoy.',
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                                lineHeight: 1.4,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 4)),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16)),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 24)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Acciones Rápidas',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                            lineHeight: 1.35,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: wrapWithModel(
                            model: _model.quickActionModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: QuickActionWidget(
                              action_id: 'act1',
                              bg_color: Color(0xFFE0F2F1),
                              icon: Icon(
                                Icons.qr_code_2_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24,
                              ),
                              icon_color: FlutterFlowTheme.of(context).primary,
                              label: 'Generar QR',
                              nav_target: 'navigate:DynamicQRGenerator',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: wrapWithModel(
                            model: _model.quickActionModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: QuickActionWidget(
                              action_id: 'act2',
                              bg_color: Color(0xFFFFF3E0),
                              icon: Icon(
                                Icons.person_add_rounded,
                                color: FlutterFlowTheme.of(context).secondary,
                                size: 24,
                              ),
                              icon_color:
                                  FlutterFlowTheme.of(context).secondary,
                              label: 'Autorizar',
                              nav_target: 'navigate:AuthorizeThirdParty',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: wrapWithModel(
                            model: _model.quickActionModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: QuickActionWidget(
                              action_id: 'act3',
                              bg_color: Color(0xFFF3E5F5),
                              icon: Icon(
                                Icons.history_rounded,
                                color: Color(0xFF7B1FA2),
                                size: 24,
                              ),
                              icon_color: Color(0xFF7B1FA2),
                              label: 'Historial',
                              nav_target: 'navigate:PickupHistory',
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 16)),
                    ),
                  ].divide(SizedBox(height: 16)),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Mis Hijos',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                                lineHeight: 1.35,
                              ),
                        ),
                        Text(
                          'Ver todos',
                          style:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).primary,
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
                      ],
                    ),
                    wrapWithModel(
                      model: _model.studentCardModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: StudentCardWidget(
                        btn_id: 'b1',
                        card_id: 's1',
                        grade: '4to Grado - Primaria',
                        name: 'Mateo García',
                      ),
                    ),
                    wrapWithModel(
                      model: _model.studentCardModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: StudentCardWidget(
                        btn_id: 'b2',
                        card_id: 's2',
                        grade: '2do Grado - Primaria',
                        name: 'Sofía García',
                      ),
                    ),
                  ].divide(SizedBox(height: 16)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Actividad Reciente',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                            lineHeight: 1.35,
                          ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(24),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(9999),
                                      shape: BoxShape.rectangle,
                                    ),
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Icon(
                                      Icons.login_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .onSurface,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ingreso Escolar',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                                lineHeight: 1.45,
                                              ),
                                        ),
                                        Text(
                                          'Mateo García • 07:45 AM',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                                lineHeight: 1.4,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16)),
                              ),
                              Divider(
                                height: 16,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(9999),
                                      shape: BoxShape.rectangle,
                                    ),
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Icon(
                                      Icons.verified_user_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .onSurface,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tercero Autorizado',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                                lineHeight: 1.45,
                                              ),
                                        ),
                                        Text(
                                          'Abuela Elena fue autorizada para hoy',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                                lineHeight: 1.4,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16)),
                              ),
                            ].divide(SizedBox(height: 16)),
                          ),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 16)),
                ),
              ),
              Container(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
