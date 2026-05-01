import '/components/button/button_widget.dart';
import '/components/profile_stat/profile_stat_widget.dart';
import '/components/setting_tile/setting_tile_widget.dart';
import '/components/switch_component/switch_component_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'user_profile_settings_model.dart';
export 'user_profile_settings_model.dart';

class UserProfileSettingsWidget extends StatefulWidget {
  const UserProfileSettingsWidget({super.key});

  static String routeName = 'UserProfileSettings';
  static String routePath = '/userProfileSettings';

  @override
  State<UserProfileSettingsWidget> createState() =>
      _UserProfileSettingsWidgetState();
}

class _UserProfileSettingsWidgetState extends State<UserProfileSettingsWidget> {
  late UserProfileSettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileSettingsModel());
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
                height: 320,
                child: Stack(
                  alignment: AlignmentDirectional(-1, -1),
                  children: [
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).secondary,
                            FlutterFlowTheme.of(context).secondary80
                          ],
                          stops: [0, 1],
                          begin: AlignmentDirectional(0, -1),
                          end: AlignmentDirectional(0, 1),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 60, 24, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FlutterFlowIconButton(
                                  borderRadius: 9999,
                                  buttonSize: 40,
                                  fillColor:
                                      FlutterFlowTheme.of(context).onPrimary20,
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).onPrimary,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    print('IconButton pressed ...');
                                  },
                                ),
                                Text(
                                  'Perfil de Usuario',
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
                                            .onSurface,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                        lineHeight: 1.3,
                                      ),
                                ),
                                FlutterFlowIconButton(
                                  borderRadius: 9999,
                                  buttonSize: 40,
                                  fillColor:
                                      FlutterFlowTheme.of(context).onPrimary20,
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).onPrimary,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    print('IconButton pressed ...');
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                              child: Container(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(24),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            children: [
                                              Container(
                                                width: 104,
                                                height: 104,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          9999),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    width: 4,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          9999),
                                                  child: CachedNetworkImage(
                                                    fadeInDuration: Duration(
                                                        milliseconds: 0),
                                                    fadeOutDuration: Duration(
                                                        milliseconds: 0),
                                                    imageUrl:
                                                        'https://dimg.dreamflow.cloud/v1/image/friendly%20father%20smiling',
                                                    width: 96,
                                                    height: 96,
                                                    fit: BoxFit.cover,
                                                    alignment: Alignment(0, 0),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.8, 0.8),
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9999),
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      width: 3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Ricardo Morales',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .plusJakartaSans(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.25,
                                                        ),
                                              ),
                                              Text(
                                                'Padre / Tutor Principal',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.outfit(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .onSurface,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      lineHeight: 1.45,
                                                    ),
                                              ),
                                            ].divide(SizedBox(height: 4)),
                                          ),
                                          Divider(
                                            height: 16,
                                            thickness: 1,
                                            indent: 20,
                                            endIndent: 20,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              wrapWithModel(
                                                model: _model.profileStatModel1,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: ProfileStatWidget(
                                                  label: 'Hijos',
                                                  value: '2',
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model.profileStatModel2,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: ProfileStatWidget(
                                                  label: 'Autorizados',
                                                  value: '4',
                                                ),
                                              ),
                                              wrapWithModel(
                                                model: _model.profileStatModel3,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: ProfileStatWidget(
                                                  label: 'Entregas',
                                                  value: '12',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 16)),
                                      ),
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
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuenta y Seguridad',
                          style: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).onSurface,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontStyle,
                                lineHeight: 1.3,
                              ),
                        ),
                        wrapWithModel(
                          model: _model.settingTileModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: SettingTileWidget(
                            icon: Icon(
                              Icons.person_outline_rounded,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 22,
                            ),
                            subtitle: 'DNI, Teléfono, Dirección',
                            title: 'Información Personal',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingTileModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: SettingTileWidget(
                            icon: Icon(
                              Icons.fingerprint_rounded,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 22,
                            ),
                            subtitle: 'Configurar huella o rostro',
                            title: 'Biometría',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingTileModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: SettingTileWidget(
                            icon: Icon(
                              Icons.qr_code_2_rounded,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 22,
                            ),
                            subtitle: 'QR permanente de identificación',
                            title: 'Mi Código QR',
                          ),
                        ),
                      ].divide(SizedBox(height: 16)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preferencias',
                          style: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).onSurface,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontStyle,
                                lineHeight: 1.3,
                              ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  wrapWithModel(
                                    model: _model.switchComponentModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SwitchComponentWidget(
                                      label: false,
                                      variant: 'Android',
                                      active: true,
                                    ),
                                  ),
                                  Divider(
                                    height: 16,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  wrapWithModel(
                                    model: _model.switchComponentModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: SwitchComponentWidget(
                                      label: false,
                                      variant: 'Android',
                                      active: false,
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16)),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 16)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aplicación',
                          style: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).onSurface,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontStyle,
                                lineHeight: 1.3,
                              ),
                        ),
                        wrapWithModel(
                          model: _model.settingTileModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: SettingTileWidget(
                            icon: Icon(
                              Icons.shield_outlined,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 22,
                            ),
                            subtitle: 'Políticas y privacidad',
                            title: 'Centro de Seguridad',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingTileModel5,
                          updateCallback: () => safeSetState(() {}),
                          child: SettingTileWidget(
                            icon: Icon(
                              Icons.help_outline_rounded,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 22,
                            ),
                            subtitle: 'Preguntas frecuentes',
                            title: 'Ayuda y Soporte',
                          ),
                        ),
                      ].divide(SizedBox(height: 16)),
                    ),
                    wrapWithModel(
                      model: _model.buttonModel,
                      updateCallback: () => safeSetState(() {}),
                      child: ButtonWidget(
                        content: 'Cerrar Sesión',
                        icon: Icon(
                          Icons.logout_rounded,
                          color: FlutterFlowTheme.of(context).onError,
                          size: 16,
                        ),
                        icon_present: true,
                        icon_end_present: false,
                        color: FlutterFlowTheme.of(context).primary,
                        bg: FlutterFlowTheme.of(context).tertiary,
                        on_tap: 'navigate:PickupHistory',
                        variant: 'destructive',
                        size: 'large',
                        full_width: true,
                        loading: false,
                        disabled: false,
                      ),
                    ),
                    Container(
                      height: 40,
                    ),
                  ].divide(SizedBox(height: 24)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
