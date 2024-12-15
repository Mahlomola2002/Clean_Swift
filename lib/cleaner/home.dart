import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String _status = "Approved";
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    // Simulate a network request with a 3-second delay
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      appointments = [
        {
          "name": "John Doe333",
          "price": 800,
          "address": "123 st St",
          "time": "14:00",
          "service": "Deep Cleaning",
          "duration": "2 hours",
          "profileImage": "https://randomuser.me/api/portraits/men/1.jpg",
          "rating": 4.5
        },
        {
          "name": "John Doe",
          "price": 82,
          "address": "123 Main St",
          "time": "14:00",
          "service": "Deep Cleaning",
          "duration": "1.5 hours",
          "profileImage": "https://randomuser.me/api/portraits/men/2.jpg",
          "rating": 4.2
        },
        {
          "name": "Love jon",
          "price": 100,
          "address": "123 Mobs",
          "time": "18:00",
          "service": "Deep Cleaning",
          "duration": "2 hours",
          "profileImage": "https://randomuser.me/api/portraits/women/1.jpg",
          "rating": 4.7
        },
        {
          "name": "Pule john",
          "price": 100,
          "address": "Mowbrary",
          "time": "08:00",
          "service": "Clean windows",
          "duration": "1 hour",
          "profileImage": "https://randomuser.me/api/portraits/women/2.jpg",
          "rating": 3.9
        },
      ];

      isLoading = false;
    });
  }

  void rejectAppointment(int index) {
    setState(() {
      appointments.removeAt(index);
    });
  }

  void acceptAppointment(int index) {
    setState(() {
      // Add to accepted appointments (you can implement this if needed)
      appointments.removeAt(index);
    });
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index < rating ? Icons.star_half : Icons.star_border),
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 77, 64),
        title: const Text(
          "CleanSwift",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Application Status",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Status:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              _status == "Pending"
                                  ? Icons.hourglass_empty
                                  : Icons.check_circle,
                              color: _status == "Pending"
                                  ? Colors.orange
                                  : Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _status,
                              style: TextStyle(
                                color: _status == "Pending"
                                    ? Colors.orange
                                    : Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: const Text(
              "Incoming bookings",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : appointments.isEmpty
                      ? const Center(
                          child: Text(
                            "No appointments available at the moment.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.pixels ==
                                    notification.metrics.maxScrollExtent ||
                                notification.metrics.pixels ==
                                    notification.metrics.minScrollExtent) {
                              _fetchAppointments();
                            }
                            return false;
                          },
                          child: _buildAppointmentCards(),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCards() {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              color: Color.fromARGB(255, 245, 245, 245),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(appointment['profileImage']),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                _buildStarRating(appointment['rating']),
                                const SizedBox(width: 5),
                                Text(
                                  '${appointment['rating']}/5',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.cleaning_services,
                            size: 20, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          appointment['service'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.timelapse,
                            size: 20, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          appointment['time'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 20, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          appointment['duration'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 20, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          appointment['address'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 194, 24, 91),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              elevation: 5,
                            ),
                            onPressed: () => rejectAppointment(index),
                            child: const Text(
                              "Reject",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 56, 142, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              elevation: 5,
                            ),
                            onPressed: () => acceptAppointment(index),
                            child: const Text(
                              "Accept",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
