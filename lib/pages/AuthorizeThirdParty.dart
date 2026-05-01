import '/components/button/button_widget.dart';
import '/components/form_section_header/form_section_header_widget.dart';
import '/components/switch_component/switch_component_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/components/upload_box/upload_box_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'authorize_third_party_model.dart';
export 'authorize_third_party_model.dart';

class AuthorizeThirdPartyWidget extends StatefulWidget {
  const AuthorizeThirdPartyWidget({super.key});

  static String routeName = 'AuthorizeThirdParty';
  static String routePath = '/authorizeThirdParty';

  @override
  State<AuthorizeThirdPartyWidget> createState() =>
      _AuthorizeThirdPartyWidgetState();
}

class _AuthorizeThirdPartyWidgetState extends State<AuthorizeThirdPartyWidget> {
  late AuthorizeThirdPartyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthorizeThirdPartyModel());
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 16,
                            buttonSize: 40,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Authorize Third Party',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                  'Add a trusted person to pick up your child',
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
                          ),
                        ].divide(SizedBox(width: 16)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          wrapWithModel(
                            model: _model.formSectionHeaderModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: FormSectionHeaderWidget(
                              accent: FlutterFlowTheme.of(context).secondary,
                              title: 'Select Child',
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(24),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              child: CachedNetworkImage(
                                                fadeInDuration:
                                                    Duration(milliseconds: 0),
                                                fadeOutDuration:
                                                    Duration(milliseconds: 0),
                                                imageUrl:
                                                    'https://dimg.dreamflow.cloud/v1/image/school%20boy%20portrait',
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                                alignment: Alignment(0, 0),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Mateo Garcia',
                                            maxLines: 1,
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                  lineHeight: 1.3,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '2nd Grade',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                        ].divide(SizedBox(height: 8)),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(24),
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            child: CachedNetworkImage(
                                              fadeInDuration:
                                                  Duration(milliseconds: 0),
                                              fadeOutDuration:
                                                  Duration(milliseconds: 0),
                                              imageUrl:
                                                  'https://dimg.dreamflow.cloud/v1/image/school%20girl%20portrait',
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(0, 0),
                                            ),
                                          ),
                                          Text(
                                            'Sofia Garcia',
                                            maxLines: 1,
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                  lineHeight: 1.3,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Kindergarten',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                        ].divide(SizedBox(height: 8)),
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 16)),
                            ),
                          ),
                        ].divide(SizedBox(height: 16)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          wrapWithModel(
                            model: _model.formSectionHeaderModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: FormSectionHeaderWidget(
                              accent: FlutterFlowTheme.of(context).secondary,
                              title: 'Authorized Person',
                            ),
                          ),
                          wrapWithModel(
                            model: _model.textFieldModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: TextFieldWidget(
                              label: false,
                              helper: false,
                              hint: 'Enter legal name',
                              value: '',
                              leading_icon: Icon(
                                Icons.person_outline_rounded,
                              ),
                              leading_icon_present: true,
                              trailing_icon_present: false,
                              variant: 'outlined',
                              error: false,
                            ),
                          ),
                          wrapWithModel(
                            model: _model.textFieldModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: TextFieldWidget(
                              label: false,
                              helper: false,
                              hint: 'Enter identification number',
                              value: '',
                              leading_icon: Icon(
                                Icons.badge_outlined,
                              ),
                              leading_icon_present: true,
                              trailing_icon_present: false,
                              variant: 'outlined',
                              error: false,
                            ),
                          ),
                          wrapWithModel(
                            model: _model.textFieldModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: TextFieldWidget(
                              label: false,
                              helper: false,
                              hint: '+1 (555) 000-0000',
                              value: '',
                              leading_icon: Icon(
                                Icons.phone_android_rounded,
                              ),
                              leading_icon_present: true,
                              trailing_icon_present: false,
                              variant: 'outlined',
                              error: false,
                            ),
                          ),
                        ].divide(SizedBox(height: 16)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          wrapWithModel(
                            model: _model.formSectionHeaderModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: FormSectionHeaderWidget(
                              accent: FlutterFlowTheme.of(context).tertiary,
                              title: 'Security & Verification',
                            ),
                          ),
                          Text(
                            'Clear photos help our guards verify identity quickly.',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.outfit(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: wrapWithModel(
                                  model: _model.uploadBoxModel1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: UploadBoxWidget(
                                    action: 'upload_face',
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    icon: Icon(
                                      Icons.face_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 32,
                                    ),
                                    label: 'Face Photo',
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: wrapWithModel(
                                  model: _model.uploadBoxModel2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: UploadBoxWidget(
                                    action: 'upload_id',
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    icon: Icon(
                                      Icons.contact_page_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 32,
                                    ),
                                    label: 'ID Document',
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.fingerprint_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .onSurface,
                                          size: 24,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Enable Biometric Check',
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
                                              'Requires face match at gate',
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
                                                                .secondaryText,
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
                                          ],
                                        ),
                                      ].divide(SizedBox(width: 16)),
                                    ),
                                    wrapWithModel(
                                      model: _model.switchComponentModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: SwitchComponentWidget(
                                        label: false,
                                        variant: 'Android',
                                        active: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 16)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          wrapWithModel(
                            model: _model.formSectionHeaderModel4,
                            updateCallback: () => safeSetState(() {}),
                            child: FormSectionHeaderWidget(
                              accent: FlutterFlowTheme.of(context).secondary,
                              title: 'Authorization Period',
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
                                  model: _model.textFieldModel4,
                                  updateCallback: () => safeSetState(() {}),
                                  child: TextFieldWidget(
                                    label: false,
                                    helper: false,
                                    hint: 'Today',
                                    value: '',
                                    leading_icon: Icon(
                                      Icons.calendar_today_rounded,
                                    ),
                                    leading_icon_present: true,
                                    trailing_icon_present: false,
                                    variant: 'outlined',
                                    error: false,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: wrapWithModel(
                                  model: _model.textFieldModel5,
                                  updateCallback: () => safeSetState(() {}),
                                  child: TextFieldWidget(
                                    label: false,
                                    helper: false,
                                    hint: 'Permanent',
                                    value: '',
                                    leading_icon: Icon(
                                      Icons.event_busy_rounded,
                                    ),
                                    leading_icon_present: true,
                                    trailing_icon_present: false,
                                    variant: 'outlined',
                                    error: false,
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16)),
                          ),
                        ].divide(SizedBox(height: 16)),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                          child: Container(
                            child: wrapWithModel(
                              model: _model.buttonModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                content: 'Authorize & Save',
                                icon: Icon(
                                  Icons.security_rounded,
                                  color: FlutterFlowTheme.of(context).onPrimary,
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
