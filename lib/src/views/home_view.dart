import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/home_controller.dart';
import '../utils/constants.dart';
import 'video_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the controller using Provider
    final controller = Provider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appName)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Error Display
            if (controller.error != null)
              Container(
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                child: Text(
                  controller.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Media Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Media Capture',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Photo'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.pickVideo(ImageSource.camera),
                        icon: const Icon(Icons.videocam),
                        label: const Text('Video'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (controller.selectedImage != null)
                    Column(
                      children: [
                        const Text('Selected Image:'),
                        const SizedBox(height: 5),
                        Image.file(controller.selectedImage!, height: 200),
                      ],
                    ),
                  if (controller.selectedVideo != null)
                    Column(
                      children: [
                        const Text('Selected Video:'),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 200,
                          child: VideoWidget(
                            videoFile: controller.selectedVideo!,
                          ),
                        ),
                      ],
                    ),
                  if (controller.selectedImage != null ||
                      controller.selectedVideo != null)
                    TextButton(
                      onPressed: controller.clearMedia,
                      child: const Text('Clear Media'),
                    ),
                ],
              ),
            ),

            const Divider(),

            // API Data Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Internet Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.loadPosts,
                        child: const Text('Fetch Posts'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (controller.isLoading)
                    const CircularProgressIndicator()
                  else if (controller.posts.isEmpty)
                    const Text('No posts loaded.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.posts.length > 5
                          ? 5
                          : controller.posts.length, // Show only 5 for demo
                      itemBuilder: (context, index) {
                        final post = controller.posts[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              post.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: CircleAvatar(
                              child: Text(post.id.toString()),
                            ),
                          ),
                        );
                      },
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
