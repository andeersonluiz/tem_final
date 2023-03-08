import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/icons.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/presenter/pages/login/login_dialog_page.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_button.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/valueNotifier/local_rating_notifier.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => InfoWidgetState();
}

class InfoWidgetState extends State<InfoWidget> {
  final TextStyle textStyle =
      const TextStyle(fontFamily: fontFamily, color: textColorFilledOption);
  late TvShowAndMovieInfoBloc tvShowAndMovieInfoBloc;
  late RatingBloc ratingBloc;
  late LocalRatingNotifier localRatingNotifier;
  late TvShowAndMovie tvShowAndMovie;

  @override
  void initState() {
    tvShowAndMovieInfoBloc = context.read<TvShowAndMovieInfoBloc>();
    ratingBloc = context.read<RatingBloc>();
    tvShowAndMovie = tvShowAndMovieInfoBloc.tvShowAndMovie;
    ratingBloc.add(UpdateRatingEvent(tvShowAndMovie.localRating));
    localRatingNotifier = context.read<LocalRatingNotifier>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: ratingColorPosterMainPage,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tvShowAndMovie.ageClassification.isNotEmpty
                      ? Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Strings.classificationText,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: textStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: generateIconAgeClassification(
                                    tvShowAndMovie.ageClassification),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Imdb",
                            style: textStyle.copyWith(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              tvShowAndMovie.imdbInfo.rating == -1
                                  ? "-"
                                  : "${tvShowAndMovie.imdbInfo.rating}/10",
                              style: textStyle.copyWith(fontSize: 20)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                              Strings.generateDateLastUpdate(
                                  lastUpdate:
                                      tvShowAndMovie.imdbInfo.lastUpdate),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: textStyle.copyWith(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  tvShowAndMovie.seasons != -1
                      ? Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Strings.seasonsText,
                                  style: textStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(tvShowAndMovie.seasons.toString(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: textStyle.copyWith(fontSize: 20)),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            const Divider(
              color: ratingColorPosterMainPage,
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: BlocBuilder<RatingBloc, RatingState>(
                    builder: (_, state) {
                      if (state is Unauthorized) {
                        CustomToast(
                            msg: state.error!, toastLength: Toast.LENGTH_SHORT);
                        ratingBloc
                            .add(UpdateRatingEvent(tvShowAndMovie.localRating));
                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const LoginDialogPage()));
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Strings.myRatingText,
                                style: textStyle.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            CustomButton(
                              onPressed: () async {
                                await _showModalBottomSheet(
                                    tvShowAndMovie, Strings.yourRatingText);
                              },
                              text: Strings.generateButtonText(
                                  isMovie: tvShowAndMovie.seasons == -1),
                            ),
                          ],
                        );
                      }
                      if (state is RatingLoading) {
                        return const CustomLoadingWidget();
                      }

                      if (state is RatingDone || state is SavingRatingDone) {
                        if (state is SavingRatingDone) {
                          CustomToast(
                              msg: state.sucess!,
                              toastLength: Toast.LENGTH_SHORT);
                          ratingBloc
                              .add(UpdateRatingEvent(ratingBloc.ratingValue));
                        }
                        int ratingValue = state.ratingValue!;
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Strings.myRatingText,
                                style: textStyle.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ratingValue != -1
                                ? GestureDetector(
                                    onTap: () async {
                                      await _showModalBottomSheet(
                                          tvShowAndMovie,
                                          Strings.updateRatingText);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RatingBarIndicator(
                                        rating: ratingValue.toDouble(),
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        unratedColor:
                                            unratedColorPosterMainPage,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: ratingColorPosterMainPage,
                                        ),
                                      ),
                                    ),
                                  )
                                : CustomButton(
                                    onPressed: () async {
                                      await _showModalBottomSheet(
                                          tvShowAndMovie,
                                          Strings.yourRatingText);
                                    },
                                    text: Strings.generateButtonText(
                                        isMovie: tvShowAndMovie.seasons == -1),
                                  )
                          ],
                        );
                      }
                      if (state is RatingError) {
                        CustomToast(msg: state.error!);
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Strings.myRatingText,
                                style: textStyle.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            tvShowAndMovie.localRating != -1
                                ? GestureDetector(
                                    onTap: () async {
                                      await _showModalBottomSheet(
                                          tvShowAndMovie,
                                          Strings.updateRatingText);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RatingBarIndicator(
                                        rating: tvShowAndMovie.localRating
                                            .toDouble(),
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        unratedColor:
                                            unratedColorPosterMainPage,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: ratingColorPosterMainPage,
                                        ),
                                      ),
                                    ),
                                  )
                                : CustomButton(
                                    onPressed: () async {
                                      await _showModalBottomSheet(
                                          tvShowAndMovie,
                                          Strings.yourRatingText);
                                    },
                                    text: Strings.generateButtonText(
                                        isMovie: tvShowAndMovie.seasons == -1),
                                  )
                          ],
                        );
                      }
                      return Container();
                    },
                  )),
            ),
            const Divider(
              color: ratingColorPosterMainPage,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(Strings.synopsisText,
                  style: textStyle.copyWith(
                      fontSize: 20,
                      color: ratingColorPosterMainPage,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(tvShowAndMovie.synopsis,
                  textAlign: TextAlign.justify,
                  style: textStyle.copyWith(fontSize: 16)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(Strings.genresText,
                  style: textStyle.copyWith(
                      fontSize: 20,
                      color: ratingColorPosterMainPage,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Wrap(
                  children: tvShowAndMovie.genres
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, top: 8.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ratingColorPosterMainPage,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  e,
                                  style: textStyle.copyWith(fontSize: 15),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }

  _showModalBottomSheet(
    TvShowAndMovie tvShowAndMovie,
    String text,
  ) {
    localRatingNotifier.update(ratingBloc.ratingValue.toDouble());
    ratingBloc.add(UpdateRatingEvent(ratingBloc.ratingValue));
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        backgroundColor: optionFilledColor,
        builder: (context) {
          return SizedBox(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(text,
                      style: const TextStyle(
                          fontFamily: fontFamily,
                          color: textColorFilledOption,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                ValueListenableBuilder<double>(
                  valueListenable: localRatingNotifier.state,
                  builder: (_, state, w) {
                    return RatingBar.builder(
                      onRatingUpdate: localRatingNotifier.update,
                      minRating: 1,
                      initialRating: localRatingNotifier.state.value,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 45,
                      glow: false,
                      ignoreGestures: ratingBloc.isLoading,
                      itemPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      unratedColor: unratedColorPosterMainPage,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child:
                      BlocBuilder<RatingBloc, RatingState>(builder: (_, state) {
                    final bool isLoading = state is RatingLoading;
                    if (state is SavingRatingDone) {
                      CustomToast(
                          msg: state.sucess!, toastLength: Toast.LENGTH_SHORT);
                      ratingBloc.add(UpdateRatingEvent(ratingBloc.ratingValue));
                      Navigator.of(context).pop();
                    }
                    if (state is RatingError) {
                      CustomToast(msg: state.error!);
                    }
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              ratingBloc.add(UpdateRatingEvent(
                                  localRatingNotifier.value.toInt()));
                              ratingBloc.add(SaveRatingEvent(
                                  localRatingNotifier.value.toInt(),
                                  tvShowAndMovie));
                            },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: ratingColorPosterMainPage),
                      child: const Text(
                        Strings.sendRatingText,
                        style: TextStyle(
                            fontFamily: fontFamily,
                            color: textColorFilledOption,
                            fontSize: 14),
                      ),
                    );
                  }),
                )
              ],
            ),
          );
        });
  }
}
