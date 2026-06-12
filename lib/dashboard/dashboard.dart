import 'package:flutter/material.dart';
import 'dart:async';
import 'package:reverse_engineering_bca/account/accountinformation.dart';
import 'package:reverse_engineering_bca/settings/settings_page.dart';

class MyBcaHomeScreen extends StatefulWidget {
  const MyBcaHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyBcaHomeScreen> createState() => _MyBcaHomeScreenState();
}

class _MyBcaHomeScreenState extends State<MyBcaHomeScreen> {
  final Color bcaBlue = const Color(0xFF005BAC);
  final Color bcaLightBlue = const Color(0xFF1CB5E0);

  String userName = 'KRESNA MUHARRAM';
  String accountNumber = '0240219280';
  String balance = '10000000';
  bool isBalanceVisible = false;

  String _formatBalance(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '0';
    String result = '';
    int count = 0;
    for (int i = digits.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        result = '.$result';
      }
      result = digits[i] + result;
      count++;
    }
    return result;
  }

  String _formatAccountNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    String result = '';
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 3 == 0) {
        if (digits.length - i == 1) {
          // don't add dash if only 1 digit is left
        } else {
          result += '-';
        }
      }
      result += digits[i];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Stack(
        children: [
          // Background Biru Atas
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(color: bcaBlue),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),
                  _buildGreeting(),
                  _buildAccountCard(context),
                  Stack(
                    children: [
                      _buildPromoBanner(),
                      Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: _buildMainMenu(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const BcaPromoCarousel(), // Carousel ditambahkan di sini
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/header_myBCA.png',
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        initialName: userName,
                        initialAccountNumber: accountNumber,
                        initialBalance: balance,
                      ),
                    ),
                  );
                  if (result != null && result is Map) {
                    setState(() {
                      userName = result['name'];
                      accountNumber = result['accountNumber'];
                      balance = result['balance'];
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: 'HELLO, ',
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
          children: [
            TextSpan(
              text: userName.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Bagian BCA ID
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF17C3CE), Color(0xFF0C97B2)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'BCA ID >',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Account: ${_formatAccountNumber(accountNumber)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.copy, color: Colors.white70, size: 14),
                    ],
                  ),
                ],
              ),
            ),
            // Bagian Active Balance
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Balance',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'IDR ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isBalanceVisible ? _formatBalance(balance) : '••••••••',
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: isBalanceVisible ? 0 : 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isBalanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: bcaBlue,
                    ),
                    onPressed: () {
                      setState(() {
                        isBalanceVisible = !isBalanceVisible;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            // Tombol Account Transactions (DI SINI PENAMBAHAN ROUTINGNYA)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Memicu perpindahan halaman ke AccountInformationPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountInformationPage(),
                    ),
                  );
                },
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: bcaBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Account Transactions',
                        style: TextStyle(
                          color: bcaBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 50.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 1, 91, 180), Color.fromARGB(255, 79, 214, 255)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/TheNewGebyar.png',
            height: 45,
          ),
          Row(
            children: const [
              Text(
                'Menangkan di Sini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2.0,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu Utama',
                  style: TextStyle(
                    color: Color(0xFF003D79),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.tune, color: bcaLightBlue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Atur',
                      style: TextStyle(
                        color: bcaLightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildMenuGrid(),
          // Carousel Indicators (Dots) digantikan oleh BcaPromoCarousel di bawah
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    Widget _buildTransferIcon() {
      return const Icon(Icons.send, color: Color(0xFF004D8E), size: 32);
    }

    Widget _buildBayarIsiUlangIcon() {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Icon(Icons.receipt, color: Color(0xFF004D8E), size: 30),
          Positioned(
            top: -2,
            left: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(color: Color(0xFF1CB5E0), shape: BoxShape.circle),
              child: const Text('Rp', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    }

    Widget _buildInvestasiIcon() {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFF004D8E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.show_chart, color: Colors.yellow, size: 20),
      );
    }

    Widget _buildLifestyleIcon() {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Icon(Icons.local_mall, color: Color(0xFF004D8E), size: 30),
          Positioned(
            bottom: -2,
            right: -6,
            child: const Icon(Icons.local_mall, color: Color(0xFF1CB5E0), size: 18),
          ),
        ],
      );
    }

    Widget _buildEStatementIcon() {
      return const Icon(Icons.description, color: Color(0xFF004D8E), size: 32);
    }

    Widget _buildFlazzIcon() {
      return Container(
        width: 32,
        height: 22,
        decoration: BoxDecoration(
          color: const Color(0xFF004D8E),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 2,
              left: 2,
              child: Icon(Icons.wifi, color: Color(0xFF1CB5E0), size: 10),
            ),
            const Text('Flazz', style: TextStyle(color: Colors.white, fontSize: 8, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    Widget _buildCardlessIcon() {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Icon(Icons.phone_android, color: Color(0xFF004D8E), size: 30),
          Positioned(
            bottom: 4,
            right: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFF1CB5E0), borderRadius: BorderRadius.circular(4)),
              child: const Text('Rp', style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    }

    Widget _buildProdukPerbankanIcon() {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Icon(Icons.account_balance, color: Color(0xFF004D8E), size: 30),
          Positioned(
            bottom: -2,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Color(0xFF1CB5E0), shape: BoxShape.circle),
              child: const Text('Rp', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    }

    Widget _buildProteksiIcon() {
      return const Icon(Icons.health_and_safety, color: Color(0xFF004D8E), size: 32);
    }

    Widget _buildSemuaFiturIcon() {
      return SizedBox(
        width: 26,
        height: 26,
        child: Wrap(
          spacing: 2,
          runSpacing: 2,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF004D8E), borderRadius: BorderRadius.circular(4))),
            Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.amber.shade400, borderRadius: BorderRadius.circular(4))),
            Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF004D8E), borderRadius: BorderRadius.circular(4))),
            Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF004D8E), borderRadius: BorderRadius.circular(4))),
          ],
        ),
      );
    }

    final List<Map<String, dynamic>> menuItems = [
      {'customIcon': _buildTransferIcon(), 'label': 'Transfer', 'isNew': false},
      {'customIcon': _buildBayarIsiUlangIcon(), 'label': 'Bayar & Isi\nUlang', 'isNew': true},
      {'customIcon': _buildInvestasiIcon(), 'label': 'Investasi', 'isNew': false},
      {'customIcon': _buildLifestyleIcon(), 'label': 'Lifestyle', 'isNew': true},
      {'customIcon': _buildEStatementIcon(), 'label': 'e-Statement', 'isNew': false},
      {'customIcon': _buildFlazzIcon(), 'label': 'Flazz', 'isNew': false},
      {'customIcon': _buildCardlessIcon(), 'label': 'Cardless', 'isNew': false},
      {'customIcon': _buildProdukPerbankanIcon(), 'label': 'Produk\nPerbankan', 'isNew': false},
      {'customIcon': _buildProteksiIcon(), 'label': 'Proteksi', 'isNew': false},
      {'customIcon': _buildSemuaFiturIcon(), 'label': 'Semua Fitur', 'isNew': false},
    ];

    Widget buildItem(Map<String, dynamic> item) {
      return SizedBox(
        width: 95,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5F6FA),
                    shape: BoxShape.circle,
                  ),
                  child: item['customIcon'],
                ),
                if (item['isNew'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item['label'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
              maxLines: 2,
            ),
          ],
        ),
      );
    }

    final ScrollController scrollController = ScrollController();
    double scrollProgress = 0.0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification.metrics.maxScrollExtent > 0) {
                  setState(() {
                    scrollProgress = notification.metrics.pixels / notification.metrics.maxScrollExtent;
                    if (scrollProgress < 0.0) scrollProgress = 0.0;
                    if (scrollProgress > 1.0) scrollProgress = 1.0;
                  });
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: menuItems.sublist(0, 5).map((item) => buildItem(item)).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: menuItems.sublist(5, 10).map((item) => buildItem(item)).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left, size: 16, color: bcaLightBlue),
                  const SizedBox(width: 4),
                  Container(
                    width: 24,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: scrollProgress * (24 - 12),
                          child: Container(
                            width: 12,
                            height: 5,
                            decoration: BoxDecoration(
                              color: bcaLightBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 16, color: bcaLightBlue),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5F6FA),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.contactless_outlined,
                      color: bcaBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'NFC Pay',
                    style: TextStyle(
                      color: Color(0xFF003D79),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    'QRIS',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'tap',
                    style: TextStyle(
                      color: Color(0xFF1CB5E0),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Color(0xFF003D79)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF004D8E)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', isSelected: true),
              _buildNavItem(Icons.receipt_long, 'Activity'),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1CB5E0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'QRIS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildNavItem(Icons.star_border, 'For You'),
              _buildNavItem(Icons.person_outline, 'My Account'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? Colors.white : Colors.white60),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// WIDGET CAROUSEL PROMO
// ---------------------------------------------------------------------------

class BcaPromoCarousel extends StatefulWidget {
  const BcaPromoCarousel({Key? key}) : super(key: key);

  @override
  State<BcaPromoCarousel> createState() => _BcaPromoCarouselState();
}

class _BcaPromoCarouselState extends State<BcaPromoCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  // Placeholder data promo
  final List<String> _promoItems = [
    'Promo 1: Gebyar Hadiah',
    'Promo 2: Diskon Lifestyle',
    'Promo 3: Kemudahan Investasi',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _promoItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _promoItems.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF002244),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _promoItems[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots Indicator Animasi
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promoItems.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF1CB5E0)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
