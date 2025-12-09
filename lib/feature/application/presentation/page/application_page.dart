import 'package:flutter/material.dart';

class ApplicationPage extends StatefulWidget {
  static const routeName = '/application';

  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  int _selectedIndex = 0;

  // Status step widget
  Widget _buildStatusStep({
    required String title,
    required String subtitle,
    required String time,
    bool isCompleted = false,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 24,
                  color: isCompleted ? Colors.green : Colors.grey[300],
                ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.blue
                      : (isCompleted ? Colors.green : Colors.grey[300]),
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 24,
                  color: isActive ? Colors.blue : Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive ? Colors.black : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.blue : Colors.grey[500],
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Next step item widget
  Widget _buildNextStepItem(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromRGBO(33, 150, 243, 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // History item widget
  Widget _buildHistoryItem({
    required String company,
    required String position,
    required String status,
    required String date,
    bool isAccepted = false,
    bool isRejected = false,
    bool isWithdrawn = false,
  }) {
    Color statusColor = Colors.grey;
    if (isAccepted) statusColor = Colors.green;
    if (isRejected) statusColor = Colors.red;
    if (isWithdrawn) statusColor = Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            position,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Application',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBBDEFB), Colors.white],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert, size: 20, color: Colors.black),
              onPressed: () {
                // Add your menu action here
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Application',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            'Progress',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          // Tab-like Navigation
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey[300]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _onItemTapped(0),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                        backgroundColor: _selectedIndex == 0
                            ? Colors.grey[200]
                            : Colors.transparent,
                      ),
                      child: Text(
                        'Applied',
                        style: TextStyle(
                          color: _selectedIndex == 0
                              ? Colors.black
                              : Colors.grey[600],
                          fontWeight: _selectedIndex == 0
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _onItemTapped(1),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: _selectedIndex == 1
                            ? Colors.grey[200]
                            : Colors.transparent,
                      ),
                      child: Text(
                        'Status',
                        style: TextStyle(
                          color: _selectedIndex == 1
                              ? Colors.black
                              : Colors.grey[600],
                          fontWeight: _selectedIndex == 1
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _onItemTapped(2),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        backgroundColor: _selectedIndex == 2
                            ? Colors.grey[200]
                            : Colors.transparent,
                      ),
                      child: Text(
                        'History',
                        style: TextStyle(
                          color: _selectedIndex == 2
                              ? Colors.black
                              : Colors.grey[600],
                          fontWeight: _selectedIndex == 2
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (_selectedIndex == 0) _buildApplicationsList(),
          if (_selectedIndex == 1) _buildStatusView(),
          if (_selectedIndex == 2) _buildHistoryView(),
        ],
      ),
    );
  }

  Widget _buildStatusView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Application Status',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusStep(
                title: 'Application Submitted',
                subtitle: 'Your application has been received',
                time: '2 days ago',
                isCompleted: true,
                isFirst: true,
              ),
              _buildStatusStep(
                title: 'Application Review',
                subtitle: 'Your application is under review',
                time: 'In progress',
                isCompleted: true,
                isActive: true,
              ),
              _buildStatusStep(
                title: 'Interview',
                subtitle: 'Scheduling in progress',
                time: 'Next step',
                isCompleted: false,
              ),
              _buildStatusStep(
                title: 'Final Decision',
                subtitle: 'Awaiting interview completion',
                time: 'Pending',
                isCompleted: false,
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Next Steps',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildNextStepItem(
          'Prepare for your interview',
          'Review the job description and prepare some questions',
          Icons.assignment_turned_in_outlined,
        ),
        const SizedBox(height: 12),
        _buildNextStepItem(
          'Check your email',
          'We\'ll contact you to schedule the interview',
          Icons.email_outlined,
        ),
      ],
    );
  }

  Widget _buildHistoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Application History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildHistoryItem(
          company: 'Microsoft',
          position: 'Senior Product Designer',
          status: 'Rejected',
          date: 'Oct 28, 2023',
          isRejected: true,
        ),
        const SizedBox(height: 12),
        _buildHistoryItem(
          company: 'Amazon',
          position: 'UX Designer II',
          status: 'Withdrawn',
          date: 'Sep 15, 2023',
          isWithdrawn: true,
        ),
        const SizedBox(height: 12),
        _buildHistoryItem(
          company: 'Netflix',
          position: 'Product Designer',
          status: 'Accepted',
          date: 'Aug 5, 2023',
          isAccepted: true,
        ),
      ],
    );
  }

  Widget _buildApplicationsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Applied Jobs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildJobCard(
          company: 'Google',
          position: 'Senior UI/UX Designer',
          location: 'California, USA',
          time: '2 days ago',
          isActive: true,
          progress: 0.7,
        ),
        const SizedBox(height: 16),
        _buildJobCard(
          company: 'Facebook',
          position: 'Product Designer',
          location: 'London, UK',
          time: '1 week ago',
          isActive: false,
          progress: 0.3,
        ),
      ],
    );
  }

  Widget _buildJobCard({
    required String company,
    required String position,
    required String location,
    required String time,
    required bool isActive,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'Active' : 'In Review',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            position,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isActive ? Colors.blue : Colors.grey[400]!,
                ),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
