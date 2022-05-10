import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:labeltv/network/blocs/api/bloc/api_bloc_alaune_model.dart';
import 'package:labeltv/network/blocs/api_bloc_alaune_model.dart';
import 'package:labeltv/network/model/app_description.dart';
import 'package:logger/logger.dart';

import '../constant.dart';
import 'home_page.dart';

class DescriptionPage extends StatefulWidget {
  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final AlauneBloc _newsBloc = AlauneBloc(null);


  @override
  void initState() {
    _newsBloc.add(GetAlauneList());
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
        //backgroundColor: whiteColor,
        iconTheme: IconThemeData(color: whiteColor,),
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: colorSecondary,
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
        child: BlocListener<AlauneBloc, AlauneState>(
          listener: (context, state) {
            if (state is AlauneError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text((state.message)),
                ),
              );
            }
          },
          child: BlocBuilder<AlauneBloc, AlauneState>(
            builder: (context, state) {
              if (state is AlauneInitial) {
                return _buildLoading();
              } else if (state is AlauneLoading) {
                return _buildLoading();
              } else if (state is AlauneLoaded) {
                return _buildCard(context, state.appdescription);
              } else if (state is AlauneError) {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Appdescription model) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            HtmlWidget('<span style="color:#001E4B"><br>${model.appDescription}</br>',)

          ],
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
