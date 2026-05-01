import '/components/stat_card/stat_card_widget.dart';
import '/components/student_list_tile/student_list_tile_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'admin_student_management_model.dart';
export 'admin_student_management_model.dart';

class AdminStudentManagementWidget extends StatefulWidget {
  const AdminStudentManagementWidget({super.key});

  static String routeName = 'AdminStudentManagement';
  static String routePath = '/adminStudentManagement';

  @override
  State<AdminStudentManagementWidget> createState() =>
      _AdminStudentManagementWidgetState();
}

class _AdminStudentManagementWidgetState
    extends State<AdminStudentManagementWidget> {
  late AdminStudentManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminStudentManagementModel());
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
          backgroundColor: FlutterFlowTheme.of(context).tertiary,
          icon: Icon(
            Icons.add_rounded,
            color: FlutterFlowTheme.of(context).onSurface,
            size: 24,
          ),
          elevation: 0,
          label: Text(
            'New Student',
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).onSurface,
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
                  padding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 16),
                  child: Container(
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
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Student Management',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                        lineHeight: 1.25,
                                      ),
                                ),
                                Text(
                                  'SafeGuard Admin Portal',
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
                              ],
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(9999),
                                shape: BoxShape.rectangle,
                              ),
                              alignment: AlignmentDirectional(0, 0),
                              child: Icon(
                                Icons.admin_panel_settings_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: wrapWithModel(
                                model: _model.textFieldModel,
                                updateCallback: () => safeSetState(() {}),
                                child: TextFieldWidget(
                                  label: false,
                                  helper: false,
                                  hint: 'Search students...',
                                  value: '',
                                  leading_icon: Icon(
                                    Icons.search_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 16,
                                  ),
                                  leading_icon_present: true,
                                  trailing_icon_present: false,
                                  variant: 'filled',
                                  error: false,
                                ),
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary10,
                                borderRadius: BorderRadius.circular(16),
                                shape: BoxShape.rectangle,
                              ),
                              alignment: AlignmentDirectional(0, 0),
                              child: Icon(
                                Icons.tune_rounded,
                                color: FlutterFlowTheme.of(context).onPrimary,
                                size: 24,
                              ),
                            ),
                          ].divide(SizedBox(width: 16)),
                        ),
                      ].divide(SizedBox(height: 16)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: wrapWithModel(
                        model: _model.statCardModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: StatCardWidget(
                          icon: Icon(
                            Icons.trending_up_rounded,
                            color: FlutterFlowTheme.of(context).success,
                            size: 16,
                          ),
                          icon_color: FlutterFlowTheme.of(context).success,
                          label: 'Total Students',
                          value: '842',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: wrapWithModel(
                        model: _model.statCardModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: StatCardWidget(
                          icon: Icon(
                            Icons.check_circle_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 16,
                          ),
                          icon_color: FlutterFlowTheme.of(context).primary,
                          label: 'Active Alerts',
                          value: '0',
                        ),
                      ),
                    ),
                  ].divide(SizedBox(width: 16)),
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
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
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
                                Text(
                                  'Weekly Pickups',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                        lineHeight: 1.35,
                                      ),
                                ),
                                Text(
                                  'Last 7 Days',
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
                                            .primary,
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
                              ],
                            ),
                            Container(
                              height: 180,
                              child: Container(
                                height: 180,
                                child: FlutterFlowBarChart(
                                  barData: [
                                    FFBarChartData(
                                      yData: ([
                                        120.0,
                                        150.0,
                                        135.0,
                                        160.0,
                                        180.0,
                                        90.0,
                                        40.0
                                      ])!,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    )
                                  ],
                                  xLabels: ([
                                    'M',
                                    'T',
                                    'W',
                                    'T',
                                    'F',
                                    'S',
                                    'S'
                                  ])!,
                                  barWidth: 24,
                                  barBorderRadius: BorderRadius.circular(4),
                                  groupSpace: 12,
                                  alignment: BarChartAlignment.spaceEvenly,
                                  chartStylingInfo: ChartStylingInfo(
                                    backgroundColor: Colors.transparent,
                                    showBorder: false,
                                  ),
                                  axisBounds: AxisBounds(
                                    minY: 0,
                                    maxX: 6,
                                    maxY: 216,
                                  ),
                                  xAxisLabelInfo: AxisLabelInfo(
                                    showLabels: true,
                                    labelTextStyle: FlutterFlowTheme.of(context)
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
                                          fontSize: 10,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                          lineHeight: 1,
                                        ),
                                    reservedSize: 20,
                                  ),
                                  yAxisLabelInfo: AxisLabelInfo(
                                    reservedSize: 0,
                                  ),
                                ),
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
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Recent Records',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                  lineHeight: 1.35,
                                ),
                          ),
                          Text(
                            'View All',
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                  lineHeight: 1.3,
                                ),
                          ),
                        ],
                      ),
                    ),
                    wrapWithModel(
                      model: _model.studentListTileModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: StudentListTileWidget(
                        grade: '4th Grade - Section B',
                        name: 'Mateo Garcia',
                        status: 'picked_up',
                      ),
                    ),
                    wrapWithModel(
                      model: _model.studentListTileModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: StudentListTileWidget(
                        grade: '2nd Grade - Section A',
                        name: 'Sofia Rodriguez',
                        status: 'picked_up',
                      ),
                    ),
                    wrapWithModel(
                      model: _model.studentListTileModel3,
                      updateCallback: () => safeSetState(() {}),
                      child: StudentListTileWidget(
                        grade: '5th Grade - Section C',
                        name: 'Lucas Miller',
                        status: 'picked_up',
                      ),
                    ),
                    wrapWithModel(
                      model: _model.studentListTileModel4,
                      updateCallback: () => safeSetState(() {}),
                      child: StudentListTileWidget(
                        grade: '1st Grade - Section A',
                        name: 'Elena Vance',
                        status: 'picked_up',
                      ),
                    ),
                    wrapWithModel(
                      model: _model.studentListTileModel5,
                      updateCallback: () => safeSetState(() {}),
                      child: StudentListTileWidget(
                        grade: '3rd Grade - Section B',
                        name: 'Julian Castro',
                        status: 'picked_up',
                      ),
                    ),
                  ],
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
