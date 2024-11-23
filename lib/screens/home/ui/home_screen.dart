import 'package:mintart/logic/cubit/auth_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:html' as html; // Web support

import '/routing/routes.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../theming/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  String _apiResult = '';
  bool _isImageFullScreen = false;
  late String _apiUrl;
  late String _apiKey;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context);
    _apiUrl = dotenv.env['API_URL'] ?? '';
    _apiKey = dotenv.env['API_KEY'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected ? _homePage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.mainBlue,
          ),
        ),
      ),
    );
  }

  Widget _homePage(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWideScreen = constraints.maxWidth > 600; // Web/Desktop vs Mobile

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                _buildHeader(context, isWideScreen),
                SizedBox(height: 20.h),
                Expanded(
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: ColorsManager.mainBlue,
                          )
                        : _apiResult.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isImageFullScreen = !_isImageFullScreen;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Image.memory(
                                        base64Decode(_apiResult),
                                        fit: BoxFit.cover,
                                        width: _isImageFullScreen || isWideScreen
                                            ? constraints.maxWidth
                                            : double.infinity,
                                        height: _isImageFullScreen
                                            ? constraints.maxHeight
                                            : 200.h,
                                      ),
                                    ),
                                    if (_isImageFullScreen)
                                      Positioned(
                                        top: 20.h,
                                        right: 20.w,
                                        child: IconButton(
                                          icon: const Icon(Icons.download, color: Colors.white),
                                          onPressed: () => _downloadImage(isWideScreen),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : const Text("No image generated yet."),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10.h),
                  child: _buildChatBar(context, isWideScreen),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Row _buildHeader(BuildContext context, bool isWideScreen) {
    return Row(
      mainAxisAlignment: isWideScreen ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.logout, color: ColorsManager.mainBlue),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, Routes.loginScreen);
            }
          },
        ),
        if (!isWideScreen) Spacer(),
        SizedBox(
          height: 50.h,
          width: 50.w,
          child: FirebaseAuth.instance.currentUser!.photoURL != null
              ? CachedNetworkImage(
                  imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                  placeholder: (context, url) => Image.asset('assets/images/loading.gif'),
                  fit: BoxFit.cover,
                )
              : Image.asset('assets/images/placeholder.png'),
        ),
      ],
    );
  }

  Widget _buildChatBar(BuildContext context, bool isWideScreen) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "Type your prompt...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            ),
            onSubmitted: isWideScreen ? (_) => _generateImage() : null,
          ),
        ),
        SizedBox(width: 10.w),
        IconButton(
          icon: Icon(Icons.send, color: ColorsManager.mainBlue),
          onPressed: _generateImage,
        ),
      ],
    );
  }

  Future<void> _generateImage() async {
    if (_textController.text.isEmpty || _apiUrl.isEmpty || _apiKey.isEmpty) return;

    setState(() {
      _isLoading = true;
      _apiResult = '';
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Authorization": "Bearer $_apiKey"},
        body: json.encode({"inputs": _textController.text}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _apiResult = base64Encode(response.bodyBytes);
        });
      } else {
        throw Exception("Failed to generate image");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadImage(bool isWideScreen) async {
    final bytes = base64Decode(_apiResult);
    if (kIsWeb) {
      // Web: Trigger a browser download
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = 'image.png'
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop: Save to temporary directory
      final directory = await Directory.systemTemp.createTemp();
      final file = File('${directory.path}/image.png');
      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image downloaded to temporary directory")),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
