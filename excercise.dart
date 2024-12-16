import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(ExerciseApp());
}

class ExerciseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knee Osteoarthritis Exercises',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExerciseScreen(),
    );
  }
}

class ExerciseScreen extends StatelessWidget {
  // List of exercises
  final List<Map<String, String>> exercises = [
    {
      'title': 'Step ups',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360572/step_ups_enlnb1.jpg', // Use the new image URL
      'description': 'Do this to strengthen your legs for climbing steps.\n\nStand in front of stairs, and hold onto the banister for balance. Then place your left foot on a step. Tighten your left thigh muscle and step up, touching your right foot onto the step. Keep your muscles tight as you slowly lower your right foot. Touch the floor and lift again. Do two sets of 10 repetitions. Switch legs after each set.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380743/IMG_0104_w4e061.mov',
    },
    {
      'title': 'Hamstring Stretch',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360570/hamstring_erqwia.jpg', // Use the new image URL
      'description': 'Stretching keeps you flexible and improves your range of motion, or how far you can move your joints in certain directions. It also helps you lower your odds of pain and injuries.\n\nAlways warm up with a 5-minute walk first. Lie down when you\'re ready to stretch your hamstring. Loop a bed sheet around your right foot. Use the sheet to help pull the straight leg up. Hold for 20 seconds, then lower the leg. Repeat twice. Then, switch legs.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380776/IMG_0107_ep1l0f.mov',
    },
    {
      'title': 'Sit to Stand',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360568/sit_to_stand_gw6vqr.jpg', // Use the new image URL
      'description': 'Practice this move to make standing easier.\n\nPlace two pillows on a chair. Sit on top, with your back straight, feet flat on the floor. Use your leg muscles to slowly and smoothly stand up tall. Then lower again to sit. Be sure your bent knees don’t move ahead of your toes.\n\nTry with your arms crossed or loose at your sides.\n\nToo tough to do? Add pillows. Or use a chair with armrests and help push up with your arms.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380698/IMG_0108_z2wpz0.mov',
    },
     {
      'title': 'Straight leg raise',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360566/straight_leg_raise_lgtchp.jpg', // Use the new image URL
      'description': 'Build muscle strength to help support weak joints.\n\nLie on the floor, upper body supported by your elbows. Bend your left knee, foot on the floor. Keep the right leg straight, toes pointed up. Tighten your thigh muscles and raise your right leg.\n\nPause, as shown, for 3 seconds. Keep your thigh muscles tight and slowly lower your leg to the ground. Touch and raise again. Do two sets of 10 repetitions. Switch legs after each set.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380771/IMG_0111_qzlkst.mov',
    },
    {
      'title': 'Seated Hip March',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360563/seated_hip_march_fdsfvy.jpg', // Use the new image URL
      'description': 'Strengthen your hips and thigh muscles. It can help with daily activities like walking or standing up.\n\nSit up straight in a chair. Kick your left foot back slightly, but keep your toes on the floor. Lift your right foot off the floor, knee bent. Hold the right leg in the air 3 seconds. Slowly lower your foot to the ground. Do two sets of 10 repetitions. Switch legs after each set.\n\nToo hard? Use your hands to help lift your leg.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380745/IMG_0112_i170r4.mov',
    },
    {
      'title': 'Calf Stretch',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360558/calf_stretch_k7ec1k.jpg', // Use the new image URL
      'description': 'Hold onto a chair for balance. Bend your right leg. Step back with your left leg, and slowly straighten it behind you. Press your left heel toward the floor. You should feel the stretch in the calf of your back leg. Hold for 20 seconds. Repeat twice, then switch legs.\n\nFor more of a stretch, lean forward and bend the right knee deeper -- but don’t let it go past your toes.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380726/IMG_0116_pzduls.mov',
    },
     {
      'title': 'Walking',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360553/walking_hg7quc.jpg', // Use the new image URL
      'description': 'Even if you have stiff or sore knees, walking may be a great exercise. Start slow, stand tall, and keep at it. You can ease joint pain, strengthen your leg muscles, improve your posture, and improve your flexibility. It\'s also good for your heart.\n\nIf you\'re not active now, check in with your doctor before you start a new exercise program.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380635/IMG_0121_cml3ix.mov',
    },
     {
      'title': 'Side Leg raise',
      'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360552/side_leg_raise_m9bitj.jpg', // Use the new image URL
      'description': 'Stand and hold the back of a chair for balance. Place your weight on your left leg. Stand tall and lift the right leg out to the side -- keep the right leg straight and outer leg muscles tensed. Hold 3 seconds, then slowly lower the leg. Do two sets of 10 repetitions. Switch legs after each set.\n\nToo hard? Increase leg height over time. After a few workouts, you’ll be able to raise it higher.',
      'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380729/IMG_0119_vocldw.mov',
    },
    // {
    //   'title': 'Heel raise',
    //   'image': 'https://res.cloudinary.com/du4gxoyn7/image/upload/v1732360551/heel_raise_ilwe87.jpg', // Use the new image URL
    //   'description': 'Stand tall and hold the back of a chair for support. Lift your heels off the ground and rise up on the toes of both feet. Hold for 3 seconds. Slowly lower both heels to the ground. Do two sets of 10 repetitions.\n\nToo tricky? Do the same exercise while sitting in a chair.',
    //   'video': 'https://res.cloudinary.com/du4gxoyn7/video/upload/v1732380736/IMG_0120_zrxzje.mov',
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knee Osteoarthritis Exercises'),
      ),
      body: SingleChildScrollView(  // Use SingleChildScrollView to make the content scrollable
        child: Column(
          children: exercises.map((exercise) => ExerciseCard(exercise: exercise)).toList(),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final Map<String, String> exercise;

  ExerciseCard({required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.exercise['video']!) // Use network for video URL
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise['title']!,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Scrollable Image
            Container(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Image.network(
                  widget.exercise['image']!, // Use network for image URL
                  width: 400,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Video Player
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
            SizedBox(height: 10),
            Text(
              widget.exercise['description']!,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
