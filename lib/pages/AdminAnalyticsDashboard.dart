import '/components/audit_item/audit_item_widget.dart';
import '/components/button/button_widget.dart';
import '/components/metric_card/metric_card_widget.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'admin_analytics_dashboard_model.dart';
export 'admin_analytics_dashboard_model.dart';

class AdminAnalyticsDashboardWidget extends StatefulWidget {
  const AdminAnalyticsDashboardWidget({super.key});

  static String routeName = 'AdminAnalyticsDashboard';
  static String routePath = '/adminAnalyticsDashboard';

  @override
  State<AdminAnalyticsDashboardWidget> createState() =>
      _AdminAnalyticsDashboardWidgetState();
}

class _AdminAnalyticsDashboardWidgetState
    extends State<AdminAnalyticsDashboardWidget> {
  late AdminAnalyticsDashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminAnalyticsDashboardModel());
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
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'System Analytics',
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
                                  'Safe School Administrator',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.inter(
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
                              buttonSize: 40,
                              fillColor: Colors.transparent,
                              icon: Icon(
                                Icons.settings_rounded,
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: wrapWithModel(
                                model: _model.metricCardModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: MetricCardWidget(
                                  delta: '+12%',
                                  label: 'Total Pickups',
                                  value: '1,284',
                                  trend_up: true,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: wrapWithModel(
                                model: _model.metricCardModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: MetricCardWidget(
                                  delta: '+3%',
                                  label: 'Active Tutors',
                                  value: '856',
                                  trend_up: true,
                                ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pickups per Hour',
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
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                          lineHeight: 1.4,
                                        ),
                                  ),
                                  Icon(
                                    Icons.bar_chart_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24,
                                  ),
                                ],
                              ),
                              Container(
                                height: 200,
                                child: Container(
                                  height: 200,
                                  child: FlutterFlowBarChart(
                                    barData: [
                                      FFBarChartData(
                                        yData: ([
                                          12.0,
                                          45.0,
                                          89.0,
                                          120.0,
                                          65.0,
                                          30.0
                                        ])!,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      )
                                    ],
                                    xLabels: ([
                                      '8am',
                                      '10am',
                                      '12pm',
                                      '2pm',
                                      '4pm',
                                      '6pm'
                                    ])!,
                                    barWidth: 20,
                                    barBorderRadius: BorderRadius.circular(4),
                                    groupSpace: 12,
                                    alignment: BarChartAlignment.spaceEvenly,
                                    chartStylingInfo: ChartStylingInfo(
                                      backgroundColor: Colors.transparent,
                                      showGrid: true,
                                      showBorder: false,
                                    ),
                                    axisBounds: AxisBounds(
                                      minY: 0,
                                      maxX: 5,
                                      maxY: 144,
                                    ),
                                    xAxisLabelInfo: AxisLabelInfo(
                                      showLabels: true,
                                      labelTextStyle: FlutterFlowTheme.of(
                                              context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.inter(
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
                              Text(
                                'Peak activity detected at 2:00 PM dismissal',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
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
                            ].divide(SizedBox(height: 16)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Verification Health',
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
                                      lineHeight: 1.4,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                  ),
                                  Expanded(
                                    flex: 1,
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
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                                shape: BoxShape.rectangle,
                                              ),
                                            ),
                                            Text(
                                              '94% Biometric Match',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts.inter(
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
                                                        letterSpacing: 0.0,
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
                                                        lineHeight: 1.4,
                                                      ),
                                            ),
                                          ].divide(SizedBox(width: 4)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                                shape: BoxShape.rectangle,
                                              ),
                                            ),
                                            Text(
                                              '6% Manual Override',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts.inter(
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
                                                        letterSpacing: 0.0,
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
                                                        lineHeight: 1.4,
                                                      ),
                                            ),
                                          ].divide(SizedBox(width: 4)),
                                        ),
                                      ].divide(SizedBox(height: 8)),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 24)),
                              ),
                            ].divide(SizedBox(height: 16)),
                          ),
                        ),
                      ),
                    ),
                    Column(
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
                              'Recent Audit Logs',
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
                                    lineHeight: 1.4,
                                  ),
                            ),
                            wrapWithModel(
                              model: _model.buttonModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                content: 'View All',
                                icon_present: false,
                                icon_end_present: false,
                                color: FlutterFlowTheme.of(context).error,
                                on_tap: 'navigate:AuditLogs',
                                align: '',
                                radius: 9999.0,
                                variant: 'ghost',
                                size: 'small',
                                full_width: false,
                                loading: false,
                                disabled: false,
                              ),
                            ),
                          ],
                        ),
                        wrapWithModel(
                          model: _model.auditItemModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: AuditItemWidget(
                            cid: 'QmXoyp...3n8',
                            img_desc:
                                'https://dimg.dreamflow.cloud/v1/image/school%20student%20photo',
                            status: 'Verified',
                            time: '2m ago',
                            title: 'Mateo Smith',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.auditItemModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: AuditItemWidget(
                            cid: 'QmTzW1...9k2',
                            img_desc:
                                'https://dimg.dreamflow.cloud/v1/image/child%20smiling',
                            status: 'Verified',
                            time: '15m ago',
                            title: 'Alana Velez',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.auditItemModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: AuditItemWidget(
                            cid: 'QmRf4v...p0q',
                            img_desc:
                                'https://dimg.dreamflow.cloud/v1/image/student%20avatar',
                            status: 'Verified',
                            time: '42m ago',
                            title: 'Julian Ross',
                          ),
                        ),
                      ].divide(SizedBox(height: 16)),
                    ),
                  ].divide(SizedBox(height: 24)),
                ),
              ),
              Container(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
