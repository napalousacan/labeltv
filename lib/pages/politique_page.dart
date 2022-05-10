import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:labeltv/network/blocs/api/bloc/api_bloc.dart';
import 'package:labeltv/network/blocs/api_bloc.dart';
import 'package:labeltv/network/model/app_privacy.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import 'drawers.dart';
import 'home_page.dart';

class PolitiquePage extends StatefulWidget {
  @override
  _PolitiquePageState createState() => _PolitiquePageState();
}

class _PolitiquePageState extends State<PolitiquePage> {
  final ApiBloc _newsBloc = ApiBloc(null);


  @override
  void initState() {
    _newsBloc.add(GetApiList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorPrimary
          ),
        ),
        backgroundColor: whiteColor,
        title: Text(""),
        iconTheme: IconThemeData(color: whiteColor,),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: colorbg,
        child: SingleChildScrollView(
          child: _buildListApi(),
        ),
      ),
    );
  }
  Widget _buildListApi() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<ApiBloc, ApiState>(
          listener: (context, state) {
            if (state is ApiError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: (state.icon),
                ),
              );
            }
          },
          child: BlocBuilder<ApiBloc, ApiState>(
            builder: (context, state) {
              if (state is ApiInitial) {
                return _buildLoading();
              } else if (state is ApiLoading) {
                return _buildLoading();
              } else if (state is ApiLoaded) {
                return _buildCard(context, state.appprivacy);
              } else if (state is ApiError) {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Appprivacy model) {
    return Card(
      child: Container(
        width: double.infinity,
        //height: double.infinity,
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            HtmlWidget('<span style="color:#001E4B"><br>${model.appPrivacy}</br></span>')

          ],
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
