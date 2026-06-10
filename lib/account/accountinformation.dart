import 'package:flutter/material.dart';

class AccountInformationPage extends StatefulWidget {
  const AccountInformationPage({Key? key}) : super(key: key);

  @override
  State<AccountInformationPage> createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true; // State penanda loading

  @override
  void initState() {
    super.initState();
    // Menginisialisasi TabController untuk 3 tab
    _tabController = TabController(length: 3, vsync: this);

    // Simulasi pengambilan data (Loading selama 2 detik)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Warna dasar abu-abu terang
      body: Stack(
        children: [
          // 1. Background Biru Bertekstur
          _buildBlueBackground(),

          SafeArea(
            bottom:
                false, // Membiarkan container putih memanjang sampai bawah layar
            child: Column(
              children: [
                // 2. Custom App Bar
                _buildAppBar(context),

                // 3. Account Card Information
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: AccountInfoCard(),
                ),

                // 4. Container Putih Bottom Sheet
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 5. Tab Bar
                        _buildTabBar(),

                        // 6. Search & Filter Bar
                        _buildSearchAndFilter(),

                        // 7. TabBarView untuk konten tiap tab
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildTransactionList(),
                              const Center(child: Text('Card Information')),
                              const Center(child: Text('Pocket Information')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Komponen Internal Halaman ---

  Widget _buildBlueBackground() {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF004B87), // Biru gelap
            Color(0xFF0066B3), // Biru agak terang
            Color(0xFF003366), // Biru sangat gelap (menambah dimensi)
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              // Kembali ke halaman Dashboard
              Navigator.pop(context);
            },
          ),
          const Text(
            'Account Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF00529C),
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: const Color(0xFF00529C),
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: 'Account Transactions'),
          Tab(text: 'Card'),
          Tab(text: 'Pocket'),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                  const SizedBox(width: 8),
                  Text('Search', style: TextStyle(color: Colors.grey.shade400)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.receipt_long,
              color: Colors.grey.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.filter_alt_outlined,
              color: Colors.grey.shade700,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    // Merender skeleton jika data masih dimuat
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: 6, // Jumlah skeleton
        itemBuilder: (context, index) => const SkeletonTransactionTile(),
      );
    }

    // Merender data asli jika selesai dimuat
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'June',
            style: TextStyle(
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        TransactionTile(
          dateOrStatus: 'PEND',
          title: 'TGL: 0606 QR 914 00000.00DIGAWA cof',
          subtitle: 'TRANSAKSI DEBIT',
          amount: 'IDR 20,000.00',
          isDebit: true,
        ),
        TransactionTile(
          dateOrStatus: 'PEND',
          title: 'TGL: 0606 QR 014 00000.00HHB H05 PA',
          subtitle: 'TRANSAKSI DEBIT',
          amount: 'IDR 66,000.00',
          isDebit: true,
        ),
        TransactionTile(
          dateOrStatus: 'PEND',
          title: '0606/FTSCY/WS95271 85000.00\nRAMADHAN SETIAWAN',
          subtitle: 'TRSF E-BANKING DB',
          amount: 'IDR 85,000.00',
          isDebit: true,
        ),
        TransactionTile(
          dateOrStatus: 'PEND',
          title: 'TGL: 0606 QR 009 00000.00SSB Cab Te',
          subtitle: 'TRANSAKSI DEBIT',
          amount: 'IDR 15,500.00',
          isDebit: true,
        ),
        TransactionTile(
          dateOrStatus: '05\nJun',
          title: 'BIAYA TXN KE 535 RIDHO ADHA MAULANA\nMyBCA',
          subtitle: 'BI FAST DB',
          amount: 'IDR 2,500.00',
          isDebit: true,
        ),
      ],
    );
  }
}

// --- Widget Terpisah (Clean Architecture UI) ---

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Kartu
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xFF5D8AA8), // Warna Muted Teal/Blue
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account No.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '024 - 021 - 9280',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.copy, color: Colors.white, size: 18),
              ],
            ),
          ),

          // Body Kartu
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Balance',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'IDR ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '• • • • • • •',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.visibility_off,
                      color: Colors.blue.shade800,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'TAHAPAN - IDR',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '06 Jun 2026 22:39:11 UTC+7',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String dateOrStatus;
  final String title;
  final String subtitle;
  final String amount;
  final bool isDebit;

  const TransactionTile({
    Key? key,
    required this.dateOrStatus,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isDebit = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Kiri: Tanggal / Status PEND
          SizedBox(
            width: 40,
            child: Text(
              dateOrStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
                fontSize: dateOrStatus == 'PEND' ? 12 : 14,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Kolom Kanan: Detail Transaksi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF003366), // Warna biru gelap teks myBCA
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: TextStyle(
                    color: isDebit
                        ? const Color(0xFFD32F2F)
                        : Colors.green, // Merah untuk pengeluaran
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonTransactionTile extends StatefulWidget {
  const SkeletonTransactionTile({Key? key}) : super(key: key);

  @override
  State<SkeletonTransactionTile> createState() =>
      _SkeletonTransactionTileState();
}

class _SkeletonTransactionTileState extends State<SkeletonTransactionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animasi denyut (pulse) untuk skeleton
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton untuk Kolom Tanggal/Status
            Container(
              width: 40,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),

            // Skeleton untuk Detail Transaksi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skeleton Title (Baris 1)
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Skeleton Subtitle (Baris 2)
                  Container(
                    width: 150,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Skeleton Amount (Baris 3)
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
