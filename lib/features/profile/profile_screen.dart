import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:promptia/common/prompt_card.dart';
import 'package:promptia/features/auth/controllers/auth_controller.dart';
import 'package:promptia/features/profile/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        surfaceTintColor: Colors.grey[50],
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.specialElite(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Obx(() {
                final user = controller.authStateController.currentUser.value;
                return Column(
                  children: [
                    _buildProfileItem(
                      'Name',
                      user?.userMetadata?['name'] ?? 'N/A',
                      Icons.person_outline,
                    ),
                    const Divider(height: 30),
                    _buildProfileItem(
                      'Email',
                      user?.email ?? 'N/A',
                      Icons.email_outlined,
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : Expanded(
                    child: controller.prompts.isNotEmpty &&
                            !controller.notFound.value
                        ? RefreshIndicator(
                            onRefresh: () async {
                              controller.fetchPropmpts();
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.prompts.length,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) => PromptCard(
                                      promptModel: controller.prompts[index],
                                    )),
                          )
                        : const Center(
                            child: Text('No prompts found!'),
                          ),
                  )),
            // Sign Out Button
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: ElevatedButton(
              onPressed: controller.authController.isLoading.value
                  ? null
                  : () async {
                      await controller.authController.signOut();
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: controller.authController.isLoading.value
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      'Sign Out',
                      style: GoogleFonts.specialElite(
                        fontSize: 16,
                      ),
                    ),
            ),
          )),
    );
  }

  Widget _buildProfileItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.specialElite(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: GoogleFonts.specialElite(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
