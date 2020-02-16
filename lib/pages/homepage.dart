import 'package:flutter/material.dart';

final Color backgroundColor = Colors.white;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Product", style: TextStyle(color: Colors.deepOrange, fontSize: 22)),
                SizedBox(height: 10),
                Text("Pesanan", style: TextStyle(color: Colors.deepOrange, fontSize: 22)),
                SizedBox(height: 10),
                Text("Logout", style: TextStyle(color: Colors.deepOrange, fontSize: 22)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          color: backgroundColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: Icon(Icons.menu, color: Colors.deepOrange),
                        onTap: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 65.0,
                        child: Image.asset('assets/12.png')
                      ),
                      Icon(Icons.settings, color: Colors.deepOrange),
                    ],
                  ),
                  Container(
                    height: 200,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.8),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      children: <Widget>[
                        Card(  
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.redAccent,
                          child:Center(
                            child:
                            Text("Content", style: TextStyle(fontSize: 14, color: Colors.white)),
                          )
                        ),
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.blueAccent,
                          child:Center(
                            child:
                            Text("Content", style: TextStyle(fontSize: 14, color: Colors.white)),
                          )
                        ),
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.green,
                          child:Center(
                            child:
                            Text("Content", style: TextStyle(fontSize: 14, color: Colors.white)),
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Product", style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
                  ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Vape"),
                      subtitle: Text("Merk"),
                      trailing: Text("290k"),
                    );
                  }, separatorBuilder: (context, index) {
                    return Divider(height: 16);
                  }, itemCount: 3)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}