import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/my_names/my_names_state.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/name_item.dart';

import 'my_names_bloc.dart';
import 'my_names_event.dart';

class MyNamesScreen extends StatefulWidget {
  @override
  _MyNamesScreenState createState() => _MyNamesScreenState();
}

class _MyNamesScreenState extends State<MyNamesScreen>
    with TickerProviderStateMixin {
  MyNamesBloc _myNamesBloc;
  TabController _tabController;

  @override
  void didChangeDependencies() {
    _myNamesBloc = BlocProvider.of<MyNamesBloc>(context);
    _myNamesBloc.getMyLikedNames();
    _myNamesBloc.getCommonNames();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _myNamesBloc.add(ShowMyLikedNamesEvent());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryGreen,
        brightness: Brightness.dark,
        flexibleSpace: Column(
          children: <Widget>[
            Container(color: AppColors.primaryGreen, height: MediaQuery.of(context).padding.top),
            Container(color: Colors.white, height: 8),
            Container(
              color: Colors.white,
              child: TabBar(
                onTap: (page) {
                  if (page == 0)
                    _myNamesBloc.add(ShowMyLikedNamesEvent());
                  else
                    _myNamesBloc.add(ShowCommonNamesEvent());
                },

                labelColor: AppColors.darkPurple,
                unselectedLabelColor: AppColors.darkPurple,
                labelPadding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                controller: _tabController,
                indicatorColor: AppColors.white,
                labelStyle: TextStyle(
                    color: AppColors.darkPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
                unselectedLabelStyle: TextStyle(
                    color: AppColors.darkPurple,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
                tabs: <Widget>[
                  Tab(text: Strings.likedNamesText.toUpperCase()),
                  Tab(text: Strings.commonNamesText.toUpperCase()),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child:
            BlocBuilder<MyNamesBloc, MyNamesState>(builder: (context, state) {
          if (state is ShowMyLikedNamesState)
            return _buildMyLikedNamesList();
          else
            return _buildCommonLikedNamesList();
        }),
      ),
    );
  }

  Widget _buildMyLikedNamesList() {
    return ListView.builder(
      itemCount: _myNamesBloc.likedNames.length,
      itemBuilder: (context, index) => NameItem(
          name: _myNamesBloc.likedNames[index],
          onDismissed: (nameId) {
            _myNamesBloc.add(RemoveLikedNameEvent(_myNamesBloc.likedNames
                .firstWhere((element) => element.id == nameId)));
          }),
    );
  }

  Widget _buildCommonLikedNamesList() {
    return ListView.builder(
      itemCount: _myNamesBloc.commonNames.length,
      itemBuilder: (context, index) => AbsorbPointer(
        child: NameItem(name: _myNamesBloc.commonNames[index]),
      ),
    );
  }
}
