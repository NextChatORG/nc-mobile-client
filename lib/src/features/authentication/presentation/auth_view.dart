import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthView extends StatelessWidget {
  final bool showBackButton;
  final String title;

  final Widget child;

  const AuthView({
    this.showBackButton = false,
    this.title = 'NextChat',

    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    var insetBottom = mediaQuery.viewInsets.bottom;
    var keyboardOn = insetBottom > 0;

    return Scaffold(
      body: Container(
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: keyboardOn ? 0 : mediaQuery.size.height,
            ),
            child: IntrinsicHeight(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: showBackButton ? Alignment.centerLeft : Alignment.center,
                    padding: EdgeInsets.only(
                      left: showBackButton ? 24 : 0,
                      top: 48,
                    ),
                    height: (keyboardOn && !showBackButton) ? 0 : (showBackButton ? 48*3 : 48*5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: showBackButton ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: [
                        if (showBackButton) Container(
                          margin: const EdgeInsets.only(right: 24),
                          child: IconButton(
                            icon: const Icon(Icons.keyboard_arrow_left),
                            iconSize: 36,
                            onPressed: () {
                              context.go('/signIn');
                            },
                          ),
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ADLaM Display',
                            fontSize: showBackButton ? 24 : 48,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular((keyboardOn && !showBackButton) ? 0 : 72),
                        ),
                        color: theme.colorScheme.surface,
                      ),
                      padding: EdgeInsets.only(
                        bottom: 48,
                        left: 48,
                        right: 48,
                        top: 48 * ((keyboardOn && !showBackButton) ? 2 : 1),
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
