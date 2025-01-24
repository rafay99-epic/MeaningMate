import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:meaning_mate/providers/chatbot_provider.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatbotProvider = Provider.of<ChatbotProvider>(context);
    final TextEditingController messageController = TextEditingController();
    final FocusNode messageFocusNode = FocusNode();

    void sendMessage() {
      final userMessage = messageController.text.trim();
      if (userMessage.isNotEmpty) {
        chatbotProvider.sendMessage(userMessage);
        messageController.clear();
        messageFocusNode.requestFocus();
      }
    }

    void copyToClipboard(String message) {
      Clipboard.setData(ClipboardData(text: message));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message copied to clipboard'),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Meaning Mate - LingoBot",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: chatbotProvider.messages.length,
              itemBuilder: (context, index) {
                final message =
                    chatbotProvider.messages.reversed.toList()[index];
                final isUserMessage = message["role"] == "user";
                return _buildMessageBubble(
                  message["content"]!,
                  isUserMessage,
                  context,
                  copyToClipboard,
                );
              },
            ),
          ),
          _buildInputArea(
            messageController,
            messageFocusNode,
            sendMessage,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    String message,
    bool isUserMessage,
    BuildContext context,
    void Function(String) onCopyPress,
  ) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUserMessage
              ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUserMessage ? 20 : 6),
            topRight: Radius.circular(isUserMessage ? 6 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUserMessage
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            if (!isUserMessage) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => onCopyPress(message),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.copy,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Copy',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onSendMessage,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surface.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (_) => onSendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: onSendMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              mini: false,
              child: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
