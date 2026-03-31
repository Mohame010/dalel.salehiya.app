import 'package:flutter/material.dart';

import '../../models/transport_model.dart';
import '../../services/api_service.dart';
import '../../widgets/cards/transport_card.dart';

class TransportScreen extends StatefulWidget {
  @override
  _TransportScreenState createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen>
    with TickerProviderStateMixin {

  List<TransportModel> routes = [];
  bool loading = true;

  late TabController _tabController;

  // ✅ تم التعديل (قطار بدل أتوبيس)
  final types = ["توكتوك", "ميكروباص", "قطار"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: types.length, vsync: this);

    loadRoutes();
  }

  Future<void> loadRoutes() async {
    try {
      final res = await ApiService.get('/routes');

      routes = (res as List)
          .map((e) => TransportModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "المواصلات",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.train), // ✅ قطار بدل أتوبيس
                ],
              ),
            ),

            /// 🚗 Tabs
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Color(0xFF0D9488),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: types.map((e) => Tab(text: e)).toList(),
              ),
            ),

            SizedBox(height: 10),

            /// 📄 Content
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: types.map((type) {

                        // ✅ فلترة محسنة
                        final filtered = routes.where((r) {
                          if (type == "قطار") {
                            return r.type == "قطار" || r.type == "أتوبيس";
                          }
                          return r.type.trim() == type.trim();
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.train,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text("لا يوجد بيانات"),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) =>
                              TransportCard(route: filtered[i]),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}