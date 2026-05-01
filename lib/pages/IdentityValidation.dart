import '/components/button/button_widget.dart';
import '/components/identity_card/identity_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'identity_validation_model.dart';
export 'identity_validation_model.dart';

class IdentityValidationWidget extends StatefulWidget {
  const IdentityValidationWidget({super.key});

  static String routeName = 'IdentityValidation';
  static String routePath = '/identityValidation';

  @override
  State<IdentityValidationWidget> createState() =>
      _IdentityValidationWidgetState();
}

class _IdentityValidationWidgetState extends State<IdentityValidationWidget> {
  late IdentityValidationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IdentityValidationModel());
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8,
                            buttonSize: 40,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                          Text(
                            'Identity Validation',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                  lineHeight: 1.35,
                                ),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8,
                            buttonSize: 40,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.info_outlined,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(24),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xFFB2DFDB),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.help,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 24,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'QR Code Verified. Please perform visual biometric check below.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                  lineHeight: 1.4,
                                                ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16)),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Student Information',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontStyle,
                                          lineHeight: 1.3,
                                        ),
                                  ),
                                  wrapWithModel(
                                    model: _model.identityCardModel1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: IdentityCardWidget(
                                      card_id: 'student_card',
                                      detail_label: 'Student ID',
                                      detail_value: 'ST-9920',
                                      name: 'Mateo Fernández',
                                      photo_desc:
                                          'https://dimg.dreamflow.cloud/v1/image/smiling%20school%20boy%20portrait',
                                      role: 'STUDENT',
                                      status_label: 'Enrolled',
                                      status_type: 'success',
                                      subtext: 'Grade 4 - Section B',
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
                                    'Authorized Pickup',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontStyle,
                                          lineHeight: 1.3,
                                        ),
                                  ),
                                  wrapWithModel(
                                    model: _model.identityCardModel2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: IdentityCardWidget(
                                      card_id: 'auth_card',
                                      detail_label: 'Document ID',
                                      detail_value: 'DNI 48.291.XXX',
                                      name: 'Elena Rodríguez',
                                      photo_desc:
                                          'https://dimg.dreamflow.cloud/v1/image/professional%20woman%20portrait',
                                      role: 'AUTHORIZED THIRD PARTY',
                                      status_label: 'Verified',
                                      status_type: 'success',
                                      subtext: 'Aunt / Legal Guardian',
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).success10,
                                  borderRadius: BorderRadius.circular(24),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).success30,
                                    width: 1,
                                  ),
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
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Face Match Confidence',
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
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .onPrimary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                    lineHeight: 1.45,
                                                  ),
                                            ),
                                            Text(
                                              '98.4%',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    font: GoogleFonts
                                                        .plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .onPrimary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                    lineHeight: 1.35,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        LinearPercentIndicator(
                                          percent: 0.98,
                                          lineHeight: 8,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor:
                                              FlutterFlowTheme.of(context)
                                                  .success,
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .success20,
                                          barRadius: Radius.circular(4),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ].divide(SizedBox(height: 8)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 80,
                              ),
                            ].divide(SizedBox(height: 24)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Container(
                        child: Container(
                          height: 61,
                          alignment: AlignmentDirectional(0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: wrapWithModel(
                                  model: _model.buttonModel1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ButtonWidget(
                                    content: 'Deny Entry',
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color:
                                          FlutterFlowTheme.of(context).onError,
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
                              ),
                              Expanded(
                                flex: 1,
                                child: wrapWithModel(
                                  model: _model.buttonModel2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ButtonWidget(
                                    content: 'Confirm Pickup',
                                    icon: Icon(
                                      Icons.check_circle_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .onPrimary,
                                      size: 16,
                                    ),
                                    icon_present: true,
                                    icon_end_present: false,
                                    color: FlutterFlowTheme.of(context).primary,
                                    bg: FlutterFlowTheme.of(context).tertiary,
                                    on_tap: 'navigate:PickupHistory',
                                    variant: 'primary',
                                    size: 'large',
                                    full_width: true,
                                    loading: false,
                                    disabled: false,
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
