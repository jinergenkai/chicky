import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../data/models/user_vocab_model.dart';
import 'vocab_card.dart';

typedef OnSwipeCallback = void Function(String direction, UserVocabModel card);

class CardSwiperWidget extends StatefulWidget {
  const CardSwiperWidget({
    super.key,
    required this.cards,
    this.onSwipe,
    this.onEmpty,
  });

  final List<UserVocabModel> cards;
  final OnSwipeCallback? onSwipe;
  final VoidCallback? onEmpty;

  @override
  State<CardSwiperWidget> createState() => _CardSwiperWidgetState();
}

class _CardSwiperWidgetState extends State<CardSwiperWidget> {
  late final CardSwiperController _controller;
  final Set<int> _flipped = {};

  @override
  void initState() {
    super.initState();
    _controller = CardSwiperController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'All done!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      );
    }

    return CardSwiper(
      controller: _controller,
      cardsCount: widget.cards.length,
      numberOfCardsDisplayed: 3,
      backCardOffset: const Offset(0, 40),
      padding: const EdgeInsets.all(24),
      onSwipe: (previousIndex, currentIndex, direction) {
        final dirStr = direction == CardSwiperDirection.right
            ? 'right'
            : direction == CardSwiperDirection.left
                ? 'left'
                : 'up';
        widget.onSwipe?.call(dirStr, widget.cards[previousIndex]);

        if (currentIndex == null) {
          widget.onEmpty?.call();
        }
        return true;
      },
      cardBuilder: (context, index, horizontalOffsetPercent, verticalOffsetPercent) {
        return GestureDetector(
          onTap: () => setState(() {
            if (_flipped.contains(index)) {
              _flipped.remove(index);
            } else {
              _flipped.add(index);
            }
          }),
          child: VocabCard(
            vocab: widget.cards[index],
            isFlipped: _flipped.contains(index),
          ),
        );
      },
    );
  }
}
