import '/components/button/button_widget.dart';
import '/components/pickup_record_item/pickup_record_item_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pickup_history_model.dart';
export 'pickup_history_model.dart';

class PickupHistoryWidget extends StatefulWidget {
  const PickupHistoryWidget({super.key});

  static String routeName = 'PickupHistory';
  static String routePath = '/pickupHistory';

  @override
  State<PickupHistoryWidget> createState() => _PickupHistoryWidgetState();
}

class _PickupHistoryWidgetState extends State<PickupHistoryWidget> {
  late PickupHistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PickupHistoryModel());
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
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 48, 20, 20),
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
                        'Pickup History',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                              lineHeight: 1.3,
                            ),
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8,
                        buttonSize: 40,
                        fillColor: Colors.transparent,
                        icon: Icon(
                          Icons.tune_rounded,
                          color: FlutterFlowTheme.of(context).secondary,
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
            ),
            Expanded(
              flex: 1,
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
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(24),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '128',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineMedium
                                                  .override(
                                                    font: GoogleFonts
                                                        .plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
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
                                                            .headlineMedium
                                                            .fontStyle,
                                                    lineHeight: 1.25,
                                                  ),
                                            ),
                                            Text(
                                              'Total Today',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .onPrimary80,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontStyle,
                                                        lineHeight: 1.2,
                                                      ),
                                            ),
                                          ].divide(SizedBox(height: 4)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      borderRadius: BorderRadius.circular(24),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '12',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineMedium
                                                  .override(
                                                    font: GoogleFonts
                                                        .plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMedium
                                                            .fontStyle,
                                                    lineHeight: 1.25,
                                                  ),
                                            ),
                                            Text(
                                              'Pending',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText80,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontStyle,
                                                        lineHeight: 1.2,
                                                      ),
                                            ),
                                          ].divide(SizedBox(height: 4)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 16)),
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
                                      hint: 'Search student...',
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
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(16),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Container(
                                      child: Icon(
                                        Icons.calendar_month_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .onSurface,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 16)),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Recent Activity',
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
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                        lineHeight: 1.35,
                                      ),
                                ),
                                wrapWithModel(
                                  model: _model.pickupRecordItemModel1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: PickupRecordItemWidget(
                                    authorized_by: 'Lucia Garcia (Mother)',
                                    grade: '2nd Grade - A',
                                    guard_name: 'Rodriguez',
                                    status: 'completed',
                                    student_name: 'Mateo Garcia',
                                    time: '02:45 PM',
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.pickupRecordItemModel2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: PickupRecordItemWidget(
                                    authorized_by: 'David Chen (Father)',
                                    grade: '1st Grade - B',
                                    guard_name: 'Rodriguez',
                                    status: 'completed',
                                    student_name: 'Sofia Chen',
                                    time: '02:40 PM',
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.pickupRecordItemModel3,
                                  updateCallback: () => safeSetState(() {}),
                                  child: PickupRecordItemWidget(
                                    authorized_by: 'Unknown / No ID',
                                    grade: 'K-5',
                                    guard_name: 'Rodriguez',
                                    status: 'flagged',
                                    student_name: 'Lucas Miller',
                                    time: '02:32 PM',
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.pickupRecordItemModel4,
                                  updateCallback: () => safeSetState(() {}),
                                  child: PickupRecordItemWidget(
                                    authorized_by: 'Marco Rossi (Uncle)',
                                    grade: '4th Grade - C',
                                    guard_name: 'Martinez',
                                    status: 'completed',
                                    student_name: 'Elena Rossi',
                                    time: '02:15 PM',
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.pickupRecordItemModel5,
                                  updateCallback: () => safeSetState(() {}),
                                  child: PickupRecordItemWidget(
                                    authorized_by: 'Sarah Wilson (Mother)',
                                    grade: '3rd Grade - A',
                                    guard_name: 'Martinez',
                                    status: 'completed',
                                    student_name: 'Liam Wilson',
                                    time: '01:55 PM',
                                  ),
                                ),
                              ].divide(SizedBox(height: 8)),
                            ),
                            wrapWithModel(
                              model: _model.buttonModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                content: 'Export Daily Report',
                                icon: Icon(
                                  Icons.download_rounded,
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
                            Container(
                              height: 32,
                            ),
                          ].divide(SizedBox(height: 24)),
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
