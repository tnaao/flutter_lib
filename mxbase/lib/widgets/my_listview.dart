import 'package:flutter/material.dart';
import 'package:mxbase/widgets/my_refresh_header.dart';

class MyListView<T> extends StatelessWidget {
  final List<T> data;
  final IndexedWidgetBuilder itemBuilder;
  final Function onRefresh;
  final Function loadMore;
  Function endRefresh;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: MyRefreshHeader(
            onRefresh: this.onRefresh,
            loadMore: this.loadMore,
            child: ListView.builder(
                itemCount: data.length, itemBuilder: itemBuilder)));
  }

  MyListView(this.data, this.itemBuilder,
      {this.onRefresh, this.loadMore, this.endRefresh, this.height});
}
