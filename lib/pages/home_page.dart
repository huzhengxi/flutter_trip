import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _appBarAlpha = 0;

  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModal;
  SalesBoxModel salesBoxModel;
  List<CommonModel> bannerList = [];

  bool _loading = true;

  Widget get _listView => ListView(
        children: [
          Container(
            height: 160,
            child: Swiper(
              itemCount: bannerList.length,
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  bannerList[index].icon,
                  fit: BoxFit.fill,
                );
              },
              pagination: SwiperPagination(builder: SwiperPagination.dots),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(localNavList: localNavList),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(gridNavModel: gridNavModal),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
              child: SubNav(subNavList: subNavList)),
          Padding(
              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
              child: SalesBox(
                salesBox: salesBoxModel,
              )),
        ],
      );

  Widget get _appBar => Opacity(
        opacity: _appBarAlpha,
        child: Container(
          height: 80,
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('首页'),
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    print('hello _handleRefresh');
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        gridNavModal = model.gridNav;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: [
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                  color: Colors.yellow,
                  backgroundColor: Colors.redAccent,
                  onRefresh: _handleRefresh,
                  child: NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.depth == 0) {
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                      return false;
                    },
                    child: _listView,
                  ),
                ),
              ),
              _appBar,
            ],
          ),
        ));
  }

  void _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      _appBarAlpha = alpha;
    });
  }
}
