
import 'package:flutter/material.dart'; 
import 'package:google_generative_ai/google_generative_ai.dart' as GAI;

import '../cost.dart'; 

class MyHomePage extends StatefulWidget { 
  const MyHomePage({Key? key}) : super(key: key); 

  @override 
  State<MyHomePage> createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController promptController = TextEditingController();
  List<ChatMessage> messages = []; // List to store chat messages

  @override
  void initState() {
    super.initState();
    messages.add(ChatMessage(
      sender: MessageSender.Bot,
      text: 'Hello! How may I help you?',
    ));
  }

  // Function to interact with Generative AI model
  Future<void> interactWithModel() async {
    final model = GAI.GenerativeModel(model: 'gemini-1.5-flash', apiKey: Gemini_Api_Key);

    final prompt = GAI.TextPart(promptController.text);
    final content = GAI.Content.text(prompt.text);

    final response = await model.generateContent([content]);

    setState(() {
      messages.add(ChatMessage(
        sender: MessageSender.User,
        text: prompt.text,
      ));
      messages.add(ChatMessage(
        sender: MessageSender.Bot,
        text: response.text,
      ));
    });

    // Clear prompt controller
    promptController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generative AI Chatbot'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: promptController,
                    decoration: const InputDecoration(
                      labelText: 'Ask a question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: interactWithModel,
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageSender {
  User,
  Bot,
}

class ChatMessage {
  final MessageSender sender;
  final String? text;

  ChatMessage({
    required this.sender,
    this.text,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: message.sender == MessageSender.User
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          if (message.sender == MessageSender.Bot)
            const CircleAvatar(child: Text('AI')),
          const SizedBox(width: 8.0),
          if (message.text != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: message.sender == MessageSender.Bot
                      ? Colors.blueGrey[100]
                      : Colors.green[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Text(message.text!),
              ),
            ),
          const SizedBox(width: 8.0),
          if (message.sender == MessageSender.User)
            const CircleAvatar(child: Text('You')),
        ],
      ),
    );
  }
}
