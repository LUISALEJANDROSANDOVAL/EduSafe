import '/components/button/button_widget.dart';
import '/components/info_item/info_item_widget.dart';
import '/components/student_chip/student_chip_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'dynamic_q_r_generator_model.dart';
export 'dynamic_q_r_generator_model.dart';

class DynamicQRGeneratorWidget extends StatefulWidget {
  const DynamicQRGeneratorWidget({super.key});

  static String routeName = 'DynamicQRGenerator';
  static String routePath = '/dynamicQRGenerator';

  @override
  State<DynamicQRGeneratorWidget> createState() =>
      _DynamicQRGeneratorWidgetState();
}

class _DynamicQRGeneratorWidgetState extends State<DynamicQRGeneratorWidget> {
  late DynamicQRGeneratorModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DynamicQRGeneratorModel());
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('FAB pressed ...');
          },
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          icon: Icon(
            Icons.phone_forwarded_rounded,
            color: FlutterFlowTheme.of(context).onPrimary,
            size: 24,
          ),
          elevation: 0,
          label: Text(
            'School Support',
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).onPrimary,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  lineHeight: 1.3,
                ),
          ),
        ),
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
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 16),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                            FlutterFlowIconButton(
                              borderRadius: 8,
                              buttonSize: 40,
                              fillColor: Colors.transparent,
                              icon: Icon(
                                Icons.info_outlined,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ],
                        ),
                        Text(
                          'Pickup QR Code',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                                lineHeight: 1.25,
                              ),
                        ),
                        Text(
                          'Show this code to the guard at the gate',
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 48,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    wrapWithModel(
                                      model: _model.studentChipModel1,
                                      updateCallback: () => safeSetState(() {}),
                                      child: StudentChipWidget(
                                        initials: 'ML',
                                        name: 'Mateo Lopez',
                                        selected: true,
                                      ),
                                    ),
                                    wrapWithModel(
                                      model: _model.studentChipModel2,
                                      updateCallback: () => safeSetState(() {}),
                                      child: StudentChipWidget(
                                        initials: 'SL',
                                        name: 'Sofia Lopez',
                                        selected: false,
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 16)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 16)),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Container(
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(32),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(24),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).primary20,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Container(
                                    child: Container(
                                      width: 0,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Lottie.network(
                                        'https://dimg.dreamflow.cloud/v1/lottie/circular+loading+progress+timer',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                        animate: true,
                                      ),
                                      Text(
                                        'Refreshes in 45s',
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              font: GoogleFonts.plusJakartaSans(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                              lineHeight: 1.3,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 4)),
                                  ),
                                  Text(
                                    'Valid only for today\'s pickup',
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
                                ].divide(SizedBox(height: 8)),
                              ),
                            ].divide(SizedBox(height: 24)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
                child: Container(
                  child: Container(
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
                      padding: EdgeInsets.all(24),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            wrapWithModel(
                              model: _model.infoItemModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: InfoItemWidget(
                                icon: Icon(
                                  Icons.person_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 20,
                                ),
                                label: 'Student',
                                value: 'Mateo Lopez - 2nd Grade A',
                              ),
                            ),
                            Divider(
                              height: 16,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            wrapWithModel(
                              model: _model.infoItemModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: InfoItemWidget(
                                icon: Icon(
                                  Icons.schedule_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 20,
                                ),
                                label: 'Valid Until',
                                value: 'Today, 4:30 PM',
                              ),
                            ),
                            Divider(
                              height: 16,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            wrapWithModel(
                              model: _model.infoItemModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: InfoItemWidget(
                                icon: Icon(
                                  Icons.verified_user_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 20,
                                ),
                                label: 'Security Level',
                                value: 'Encrypted Dynamic Token',
                              ),
                            ),
                          ].divide(SizedBox(height: 16)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    wrapWithModel(
                      model: _model.buttonModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: ButtonWidget(
                        content: 'Authorize Someone Else',
                        icon: Icon(
                          Icons.person_add_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 16,
                        ),
                        icon_present: true,
                        icon_end_present: false,
                        color: FlutterFlowTheme.of(context).primary,
                        bg: FlutterFlowTheme.of(context).tertiary,
                        on_tap: 'navigate:AuthorizeThirdParty',
                        variant: 'outline',
                        size: 'medium',
                        full_width: true,
                        loading: false,
                        disabled: false,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.buttonModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: ButtonWidget(
                        content: 'Share QR Code',
                        icon: Icon(
                          Icons.share_rounded,
                          color: FlutterFlowTheme.of(context).onSecondary,
                          size: 16,
                        ),
                        icon_present: true,
                        icon_end_present: false,
                        color: FlutterFlowTheme.of(context).primary,
                        bg: FlutterFlowTheme.of(context).tertiary,
                        on_tap: 'navigate:PickupHistory',
                        variant: 'secondary',
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
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
