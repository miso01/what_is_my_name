import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_is_my_name/alerts/error_screen.dart';
import 'package:what_is_my_name/alerts/loading_screen.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/app/app_event.dart';
import 'package:what_is_my_name/container_screen.dart';
import 'package:what_is_my_name/models/advertisement.dart';
import 'package:what_is_my_name/models/name.dart';
import 'package:what_is_my_name/name/name_bloc.dart';
import 'package:what_is_my_name/name/name_event.dart';
import 'package:what_is_my_name/name/name_state.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/sex_of_baby.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_button.dart';
import 'package:what_is_my_name/widgets/share_button.dart';

class NameScreen extends StatefulWidget {
  final NameScreenArgs args;

  const NameScreen(this.args);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  NameBloc _nameBloc;
  AppBloc _appBloc;

  @override
  void didChangeDependencies() async {
    _nameBloc = BlocProvider.of<NameBloc>(context);
    _appBloc = BlocProvider.of<AppBloc>(context);

    _nameBloc.add(GetNamesEvent(
        countryCode: "SK",
        isGenderChanged:
            widget.args == null ? false : widget.args.isGenderChanged));

    _nameBloc.add(ListenForDeviceShakeEvent());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NameBloc, NameState>(
        listenWhen: (previousState, state) =>
            state is OpenAdvertisementState ||
            state is NamesFetchInProgressState ||
            state is ErrorState ||
            state is NamesFetchSuccessState,
        listener: (context, state) async {
          if (state is OpenAdvertisementState) {
            if (await canLaunch(state.webUrl)) {
              await launch(state.webUrl);
            } else {
              throw 'Could not launch ${state.webUrl}';
            }
          } else if (state is NamesFetchInProgressState)
            Navigator.pushNamed(context, Routes.loadingScreen,
                arguments: LoadingScreenArgs(state.message));
          else if (state is ErrorState) {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushNamed(context, Routes.errorScreen,
                arguments: ErrorScreenArgs(state.message));
          } else if (state is NamesFetchSuccessState) {
            _appBloc.add(ListenForPartnerLikedNamesIdsEvent());
            Navigator.pop(context);
          }
        },
        buildWhen: (previousState, state) =>
            state is! OpenAdvertisementState &&
            state is! NamesFetchInProgressState &&
            state is! ErrorState,
        builder: (context, state) {
          if (state is NameInitialState) {
            return _buildScaffold(backgroundColor: AppColors.primaryGreen);
          } else if (state is NamesFetchSuccessState) {
            return _buildScaffold(backgroundColor: AppColors.primaryGreen);
          } else if (state is NamesLikedState) {
            return _buildScaffold(backgroundColor: Colors.green);
          } else if (state is NamesDislikedState) {
            return _buildScaffold(backgroundColor: Colors.red);
          } else if (state is RefreshedState) {
            return _buildScaffold(backgroundColor: AppColors.primaryGreen);
          } else if (state is DeviceShakenState) {
            return _buildScaffold(backgroundColor: AppColors.primaryGreen);
          } else if (state is OpenAdvertisementState) {
            return _buildScaffold(backgroundColor: AppColors.primaryGreen);
          } else if (state is ShowAdvertisementState) {
            return _buildScaffold(
                backgroundColor: AppColors.primaryGreen,
                advertisement: state.advertisement);
          } else {
            return _buildScaffold(backgroundColor: AppColors.primaryGreen);
          }
        });
  }

  Widget _buildScaffold(
      {@required Color backgroundColor, Advertisement advertisement}) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top),
          _appBloc.allNames.isEmpty
              ? Expanded(child: Container(color: AppColors.primaryGreen))
              : _buildSwipeableCard(
                  advertisement: advertisement,
                  backgroundColor: backgroundColor),
          Container(
            color: AppColors.white,
            child: Row(
              children: <Widget>[
                AppButton(
                    text: Strings.menuText,
                    color: AppColors.white,
                    onPressed: () async {
                      await Navigator.pushNamed(context, Routes.containerScreen,
                          arguments: ContainerScreenArgs(0));
                      _nameBloc.add(RefreshEvent());
                    }),
                Container(
                  height: 40,
                  child: VerticalDivider(
                    thickness: 1.5,
                    color: AppColors.grey,
                  ),
                ),
                AppButton(
                    text: Strings.myText,
                    color: AppColors.white,
                    widget: Row(
                      children: [
                        SizedBox(width: 8),
                        SvgPicture.asset(
                          Assets.heartIcon,
                          width: 17,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      await Navigator.pushNamed(context, Routes.containerScreen,
                          arguments: ContainerScreenArgs(1));
                      _nameBloc.add(RefreshEvent());
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSwipeableCard(
      {Advertisement advertisement, Color backgroundColor}) {
    if (_appBloc.unseenNames.isNotEmpty) {
      return backgroundColor == AppColors.primaryGreen
          ? Expanded(
              child: SwipeStack(
                padding: EdgeInsets.all(30),
                stackFrom: StackFrom.None,
                translationInterval: 6,
                scaleInterval: 0,
                threshold: 13,
                onSwipe: (int index, SwiperPosition position) async {
                  if (advertisement == null) {
                    if (position == SwiperPosition.Right)
                      _nameBloc.add(LikeNameEvent());
                    else if (position == SwiperPosition.Left)
                      _nameBloc.add(DislikeNameEvent());

                    await Future.delayed(Duration(milliseconds: 600));
                    _nameBloc.add(RefreshEvent());
                  } else
                    _nameBloc.add(RefreshEvent());
                },
                children: [
                  SwiperItem(
                    builder: (SwiperPosition position, double progress) =>
                        advertisement != null
                            ? _buildAdvertisementCard(context, advertisement)
                            : _buildCard(
                                context,
                                _appBloc.unseenNames[0],
                              ),
                  )
                ],
              ),
            )
          : Spacer();
    } else
      return _buildEmptyCard();
  }

  Widget _buildEmptyCard() {
    return Expanded(
      child: Container(
        color: AppColors.white,
        margin: EdgeInsets.all(30),
        child: Container(
          margin: EdgeInsets.all(MediaQuery.of(context).devicePixelRatio * 15),
          child: Column(
            children: <Widget>[
              Spacer(),
              Text(
                Strings.didYouFindText.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkPurple,
                    fontSize: 26),
              ),
              Spacer(),
              Text(Strings.youHaveSeenAllNamesText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.blue,
                      fontSize: 22)),
              Spacer(),
              Text(
                Strings.checkLikedOrRestartText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: AppColors.darkPurple),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Name name) {
    return Material(
      child: Container(
        color: name.gender == Gender.BOY
            ? AppColors.lightBlueButton
            : AppColors.lightPink,
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.all(MediaQuery.of(context).devicePixelRatio * 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name.name.toUpperCase(),
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white),
              ),
              SizedBox(height: 5),
              Text(
                name.nameDay,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white),
              ),
              SizedBox(height: 30),
              Expanded(
                child: AutoSizeText(name.description,
                    maxFontSize: 30,
                    minFontSize: 18,
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w300,
                        color: AppColors.white)),
              ),
              SizedBox(height: 10),
              ShareButton(
                onPressed: () {
                  Share.share(
                      Strings.shareNameText(name.name, name.description),
                      subject: Strings.whatIsMyNameText);
                },
                title: Strings.shareText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvertisementCard(
      BuildContext context, Advertisement advertisement) {
    return GestureDetector(
      onTap: () => _nameBloc.add(OpenAdvertisementEvent(advertisement.webUrl)),
      child: Material(
          child: advertisement.isSvg
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SvgPicture.network(
                    advertisement.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(advertisement.imageUrl),
                    ),
                  ),
                )),
    );
  }
}

class NameScreenArgs {
  final bool isGenderChanged;

  const NameScreenArgs({this.isGenderChanged});
}
