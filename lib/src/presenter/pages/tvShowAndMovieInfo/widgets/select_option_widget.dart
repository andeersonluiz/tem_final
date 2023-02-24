import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/icons.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/sub_item_result.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_button.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/conclusion/conclusion_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/conclusion/conclusion_state.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/sub_select_icon_circle.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/sub_unselect_icon_circle.dart';
import 'package:collection/collection.dart';

import '../../../stateManagement/bloc/conclusion/conclusion_bloc.dart';

class SelectOptionWidget extends StatefulWidget {
  const SelectOptionWidget({super.key, required this.tvShowAndMovie});
  final TvShowAndMovie tvShowAndMovie;
  @override
  State<SelectOptionWidget> createState() => SelectOptionWidgetState();
}

class SelectOptionWidgetState extends State<SelectOptionWidget>
    with SingleTickerProviderStateMixin {
  late ConclusionBloc conclusionBloc;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final ScrollController _scrollController;

  @override
  void initState() {
    conclusionBloc = context.read<ConclusionBloc>();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: kDurationAnimationFade),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward(from: 1);
    _scrollController = ScrollController();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();

    conclusionBloc.add(ResetConclusionEvent());
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: kDurationAnimationScroll),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMovie = widget.tvShowAndMovie.seasons == -1;
    ConclusionState? previousState;
    return BlocBuilder<ConclusionBloc, ConclusionState>(
        builder: (context, state) {
      final ConclusionSelectionStatus conclusionSelectionStatus =
          state.conclusionSelectionStatus;
      final bool selectFirstConclusion =
          conclusionSelectionStatus.hasSelectedFirstConclusion;
      final bool selectSecondConclusion =
          conclusionSelectionStatus.hasSelectedSecondConclusion;
      final bool bothConclusionSelected =
          conclusionSelectionStatus.bothConclusionSelected;
      final bool showAnimationOpacitySecondConclusion =
          conclusionSelectionStatus.showAnimationOpacitySecondConclusion;
      final bool showButton = conclusionSelectionStatus.showButton;
      if (state is Unauthorized) {
        CustomToast(msg: state.msg!);
        conclusionBloc.add(ResetConclusionEvent());
      }

      if (state is SelectConclusionDone) {
        CustomToast(msg: state.msg!);
        conclusionBloc
            .add(ShowResultsEvent(tvShowAndMovie: widget.tvShowAndMovie));
        return Container();
      }

      if (state is SelectConclusionError) {
        CustomToast(msg: state.msg!);
        conclusionBloc.add(ResetConclusionEvent());
      }

      if (state is ConclusionResults) {
        _controller.forward(from: 0);
        previousState = state;

        var stats = [
          state.tvShowAndMovieInfoStatus!.hasFinalAndClosed,
          state.tvShowAndMovieInfoStatus!.hasFinalAndOpened,
          state.tvShowAndMovieInfoStatus!.noHasfinalAndNoNewSeason,
          state.tvShowAndMovieInfoStatus!.noHasfinalAndNewSeason,
        ];
        stats.sort();

        int sumStats = stats.sum;
        var widgetsList = [
          SubItemResult(
            text: Strings.hasFinalOpenedText,
            count: state.tvShowAndMovieInfoStatus!.hasFinalAndOpened,
            totalCount: sumStats,
            icon1: const Icon(
              hasFinalIcon,
              size: kFirstIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon1: hasFinalColor,
            icon2: const Icon(
              openedIcon,
              size: kSecondIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon2: openedColor,
          ),
          SubItemResult(
            text: Strings.hasFinalOpenedText,
            count: state.tvShowAndMovieInfoStatus!.noHasfinalAndNewSeason,
            totalCount: sumStats,
            icon1: const Icon(
              noHasFinalIcon,
              size: kFirstIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon1: noHasFinalColor,
            icon2: const Icon(
              newSeasonIcon,
              size: kSecondIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon2: newSeasonColor,
          ),
          SubItemResult(
            text: Strings.hasFinalClosedText,
            count: state.tvShowAndMovieInfoStatus!.hasFinalAndClosed,
            totalCount: sumStats,
            icon1: const Icon(
              hasFinalIcon,
              size: kFirstIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon1: hasFinalColor,
            icon2: const Icon(
              closedIcon,
              size: kSecondIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon2: closedColor,
          ),
          SubItemResult(
            text: Strings.noHasFinalNoNewSeasonText,
            count: state.tvShowAndMovieInfoStatus!.noHasfinalAndNoNewSeason,
            totalCount: sumStats,
            icon1: const Icon(
              noHasFinalIcon,
              size: kFirstIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon1: noHasFinalColor,
            icon2: const Icon(
              noNewSeasonIcon,
              size: kSecondIconSizeOverlay,
              color: defaultIconColor,
            ),
            backgroundIcon2: noNewSeasonColor,
          ),
        ];
        widgetsList.sort((a, b) => b.count.compareTo(a.count));
        return FadeTransition(
          opacity: _animation,
          child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const Divider(
                      color: ratingColorPosterMainPage,
                      indent: 2,
                    ),
                    Container(
                      width: 100.h,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        Strings.resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: kHeaderSizeInfoPage,
                            fontWeight: FontWeight.bold,
                            color: textColorInfoPageColor),
                      ),
                    ),
                    const Divider(
                      color: ratingColorPosterMainPage,
                    ),
                    Container(
                        color: backgroundColor,
                        child: Column(children: widgetsList)),
                    const Divider(
                      color: ratingColorPosterMainPage,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: Container(
                        height: WidgetSize.heightButton,
                        width: 100.w,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        child: CustomButton(
                          onPressed: () async {
                            conclusionBloc.add(ResetConclusionEvent());
                          },
                          fontSize: kButtonSizeInfoPage,
                          text: Strings.backText,
                          disabledColor:
                              ratingColorPosterMainPage.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        );
      }
      if (previousState != null && previousState is ConclusionResults) {
        _controller.forward(from: 0);
      }

      previousState = state;
      return FadeTransition(
        opacity: _animation,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedPadding(
                    padding: selectFirstConclusion
                        ? const EdgeInsets.all(26)
                        : EdgeInsets.zero,
                    duration:
                        const Duration(milliseconds: kDurationAnimationPadding),
                    child: selectFirstConclusion
                        ? Text(
                            "${Strings.generateTypeTvShowAndMovie(isMovie: isMovie)} ${Strings.hasEndText.toLowerCase()}",
                            style: const TextStyle(
                                fontFamily: fontFamily,
                                fontSize: kHeaderSizeInfoPage,
                                fontWeight: FontWeight.w500,
                                color: textColorInfoPageColor),
                          )
                        : Container(),
                  ),

                  AnimatedContainer(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    duration:
                        const Duration(milliseconds: kDurationAnimationResize),
                    curve: Curves.linear,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              state.conclusion == Conclusion.hasFinal
                                  ? SubSelectedIconCircle(
                                      icon: Icon(
                                        hasFinalIcon,
                                        size: selectFirstConclusion
                                            ? kSelectFirstIconSize
                                            : kUnselectFirstIconSize,
                                        color: hasFinalColor,
                                      ),
                                      selectedColor: hasFinalColor,
                                      text: Strings.hasFinalOptionText,
                                      backgroundColor:
                                          selectedIconBackgroundColor,
                                      textSize: selectFirstConclusion
                                          ? kSizeSelectedFirstItem
                                          : kSizeUnselectedFirstItem,
                                    )
                                  : SubUnselectedIconCircle(
                                      onTap: () async {
                                        conclusionBloc.add(
                                            const SelectFirstConclusionEvent(
                                                Conclusion.hasFinal));
                                        print("ab cd");
                                        await Future.delayed(const Duration(
                                            milliseconds:
                                                kAwaitTimeToAnimation));
                                        print("ab cd1 ${state.msg}");
                                        conclusionBloc.add(const ShowAnimation(
                                            Conclusion.hasFinal));
                                      },
                                      backgroundColor: hasFinalColor,
                                      text: Strings.hasFinalOptionText,
                                      textSize: selectFirstConclusion
                                          ? kSizeSelectedFirstItem
                                          : kSizeUnselectedFirstItem,
                                    ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              state.conclusion == Conclusion.noHasFinal
                                  ? SubSelectedIconCircle(
                                      icon: Icon(
                                        noHasFinalIcon,
                                        size: selectFirstConclusion
                                            ? kSelectFirstIconSize
                                            : kUnselectFirstIconSize,
                                        color: noHasFinalColor,
                                      ),
                                      backgroundColor:
                                          selectedIconBackgroundColor,
                                      selectedColor: noHasFinalColor,
                                      text: Strings.noHasFinalOptionText,
                                      textSize: selectFirstConclusion
                                          ? kSizeSelectedFirstItem
                                          : kSizeUnselectedFirstItem,
                                    )
                                  : SubUnselectedIconCircle(
                                      onTap: () async {
                                        conclusionBloc.add(
                                            const SelectFirstConclusionEvent(
                                                Conclusion.noHasFinal));
                                        await Future.delayed(const Duration(
                                            milliseconds:
                                                kAwaitTimeToAnimation));
                                        conclusionBloc.add(const ShowAnimation(
                                            Conclusion.noHasFinal));
                                      },
                                      backgroundColor: noHasFinalColor,
                                      text: Strings.noHasFinalOptionText,
                                      textSize: selectFirstConclusion
                                          ? kSizeSelectedFirstItem
                                          : kSizeUnselectedFirstItem,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //SEGUNDA OPT
                  selectFirstConclusion
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimatedOpacity(
                              opacity:
                                  showAnimationOpacitySecondConclusion ? 1 : 0,
                              duration: const Duration(
                                  milliseconds: kDurationAnimationOpacity),
                              child: showAnimationOpacitySecondConclusion
                                  ? RichText(
                                      text: TextSpan(
                                          style: const TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: kConjuctionSizeInfoPage,
                                              fontStyle: FontStyle.italic),
                                          children: [
                                            TextSpan(
                                                text: Strings
                                                        .generateTypeTvShowAndMovie(
                                                            isMovie: isMovie)
                                                    .toString()
                                                    .toUpperCase()),
                                            state.conclusion ==
                                                    Conclusion.noHasFinal
                                                ? const TextSpan(
                                                    text:
                                                        " ${Strings.noHasFinalOptionText}",
                                                    style: TextStyle(
                                                        color: noHasFinalColor,
                                                        fontWeight:
                                                            FontWeight.bold))
                                                : const TextSpan(
                                                    text:
                                                        " ${Strings.hasFinalOptionText}",
                                                    style: TextStyle(
                                                        color: hasFinalColor,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            state.conclusion ==
                                                    Conclusion.noHasFinal
                                                ? const TextSpan(
                                                    text: Strings
                                                        .noHasFinalConjuctionText)
                                                : const TextSpan(
                                                    text: Strings
                                                        .hasFinalConjuctionText),
                                          ]),
                                    )
                                  : const Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: kConjuctionSizeInfoPage,
                                          color: Colors.transparent),
                                    )),
                        ),
                  AnimatedContainer(
                    duration:
                        const Duration(milliseconds: kDurationAnimationResize),
                    height: selectSecondConclusion ? 22.h : 0,
                    child: AnimatedOpacity(
                      alwaysIncludeSemantics: true,
                      duration: const Duration(
                          milliseconds: kDurationAnimationOpacity),
                      curve: Curves.easeInQuint,
                      opacity: showAnimationOpacitySecondConclusion ? 1 : 0,
                      child: !showAnimationOpacitySecondConclusion
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: state.conclusion ==
                                              Conclusion.noHasFinal
                                          ? [
                                              state.conclusionNoHasFinal ==
                                                      ConclusionNoHasFinal
                                                          .newSeason
                                                  ? const SubSelectedIconCircle(
                                                      icon: Padding(
                                                        padding: EdgeInsets.all(
                                                            16.0),
                                                        child: Icon(
                                                          newSeasonIcon,
                                                          size: kIconSizeOption,
                                                          color: newSeasonColor,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          selectedIconBackgroundColor,
                                                      selectedColor:
                                                          newSeasonColor,
                                                      text: Strings
                                                          .newSeasonOptionText,
                                                      maxLines: 2,
                                                    )
                                                  : SubUnselectedIconCircle(
                                                      onTap: () async {
                                                        conclusionBloc.add(SelectSecondConclusionEvent(
                                                            conclusion:
                                                                Conclusion
                                                                    .noHasFinal,
                                                            conclusionNoHasFinal:
                                                                ConclusionNoHasFinal
                                                                    .newSeason));
                                                        _scrollDown();
                                                      },
                                                      backgroundColor:
                                                          newSeasonColor,
                                                      text: Strings
                                                          .newSeasonOptionText,
                                                      maxLines: 2,
                                                    ),
                                            ]
                                          : [
                                              state.conclusionHasFinal ==
                                                      ConclusionHasFinal.opened
                                                  ? const SubSelectedIconCircle(
                                                      icon: Padding(
                                                        padding: EdgeInsets.all(
                                                            16.0),
                                                        child: Icon(
                                                          openedIcon,
                                                          size: kIconSizeOption,
                                                          color: openedColor,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          selectedIconBackgroundColor,
                                                      selectedColor:
                                                          openedColor,
                                                      text: Strings
                                                          .openedOptionText,
                                                    )
                                                  : SubUnselectedIconCircle(
                                                      onTap: () async {
                                                        conclusionBloc.add(
                                                            SelectSecondConclusionEvent(
                                                                conclusion:
                                                                    Conclusion
                                                                        .hasFinal,
                                                                conclusionHasFinal:
                                                                    ConclusionHasFinal
                                                                        .opened));
                                                        _scrollDown();
                                                      },
                                                      backgroundColor:
                                                          openedColor,
                                                      text: Strings
                                                          .openedOptionText,
                                                    ),
                                            ]),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: state.conclusion ==
                                            Conclusion.noHasFinal
                                        ? [
                                            state.conclusionNoHasFinal ==
                                                    ConclusionNoHasFinal
                                                        .noNewSeason
                                                ? const SubSelectedIconCircle(
                                                    icon: Padding(
                                                      padding:
                                                          EdgeInsets.all(16.0),
                                                      child: Icon(
                                                        noNewSeasonIcon,
                                                        size: kIconSizeOption,
                                                        color: noNewSeasonColor,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        selectedIconBackgroundColor,
                                                    selectedColor:
                                                        noNewSeasonColor,
                                                    text: Strings
                                                        .noNewSeasonOptionText,
                                                    maxLines: 2,
                                                  )
                                                : SubUnselectedIconCircle(
                                                    onTap: () {
                                                      conclusionBloc.add(
                                                          SelectSecondConclusionEvent(
                                                              conclusion:
                                                                  Conclusion
                                                                      .noHasFinal,
                                                              conclusionNoHasFinal:
                                                                  ConclusionNoHasFinal
                                                                      .noNewSeason));
                                                      _scrollDown();
                                                    },
                                                    backgroundColor:
                                                        noNewSeasonColor,
                                                    text: Strings
                                                        .noNewSeasonOptionText,
                                                    maxLines: 2,
                                                  ),
                                          ]
                                        : [
                                            state.conclusionHasFinal ==
                                                    ConclusionHasFinal.closed
                                                ? const SubSelectedIconCircle(
                                                    icon: Padding(
                                                      padding:
                                                          EdgeInsets.all(16.0),
                                                      child: Icon(closedIcon,
                                                          size: kIconSizeOption,
                                                          color: closedColor),
                                                    ),
                                                    backgroundColor:
                                                        selectedIconBackgroundColor,
                                                    selectedColor: closedColor,
                                                    text: Strings
                                                        .closedOptionText,
                                                  )
                                                : SubUnselectedIconCircle(
                                                    onTap: () async {
                                                      conclusionBloc.add(
                                                          SelectSecondConclusionEvent(
                                                              conclusion:
                                                                  Conclusion
                                                                      .hasFinal,
                                                              conclusionHasFinal:
                                                                  ConclusionHasFinal
                                                                      .closed));
                                                      _scrollDown();
                                                    },
                                                    backgroundColor:
                                                        closedColor,
                                                    text: Strings
                                                        .closedOptionText,
                                                  )
                                          ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        showButton
                            ? Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: WidgetSize.heightButton,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0, vertical: 8.0),
                                        child: CustomButton(
                                          onPressed: () async {
                                            conclusionBloc
                                                .add(ResetConclusionEvent());
                                          },
                                          fontSize: kButtonSizeInfoPage,
                                          text: Strings.backText,
                                          disabledColor:
                                              ratingColorPosterMainPage
                                                  .withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: WidgetSize.heightButton,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8.0),
                                        child: CustomButton(
                                          onPressed: bothConclusionSelected
                                              ? () async {
                                                  conclusionBloc.add(
                                                      SendConclusionEvent(
                                                          tvShowAndMovie: widget
                                                              .tvShowAndMovie));
                                                }
                                              : null,
                                          fontSize: kButtonSizeInfoPage,
                                          text: Strings.confirmText,
                                          disabledColor:
                                              ratingColorPosterMainPage
                                                  .withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 16,
                child: AnimatedOpacity(
                  duration:
                      const Duration(milliseconds: kDurationAnimationOpacity),
                  opacity: selectFirstConclusion ? 1 : 0,
                  child: Container(
                    width: 100.w,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        selectFirstConclusion
                            ? Expanded(
                                child: Container(
                                  height: WidgetSize.heightButton,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  child: CustomButton(
                                      onPressed: () async {
                                        conclusionBloc.add(ShowResultsEvent(
                                            tvShowAndMovie:
                                                widget.tvShowAndMovie));
                                      },
                                      fontSize: kButtonSizeInfoPage,
                                      text: Strings.viewResultsText,
                                      backgroundColor:
                                          ratingColorPosterMainPage),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
