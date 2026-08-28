import 'package:flutter/material.dart';

class AvatarSelector extends StatelessWidget {
  final String? selectedAvatar;
  final ValueChanged<String> onSelected;

  static const List<String> avatars = [
    '🐻',
    '🐱',
    '🐶',
    '🦁',
    '🐸',
    '🐼',
    '🦊',
    '🐰',
    '🐵',
    '🐧',
    '🦋',
    '🌟',
  ];

  const AvatarSelector({
    super.key,
    this.selectedAvatar,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isSelected = avatar == selectedAvatar;

        return GestureDetector(
          onTap: () => onSelected(avatar),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        );
      },
    );
  }
}
