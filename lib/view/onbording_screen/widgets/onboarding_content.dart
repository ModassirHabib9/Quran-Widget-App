class UnbordingContent {
  String? image;
  String? title;
  String? discription;
  // bool? check;

  UnbordingContent({this.image, this.title, this.discription /*, this.check*/});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'AI Generated Wallpapers',
      image: 'images/space.jpg',
      discription:
          "All the wallpapers in this app are generate via Artificial Intelligence."),
  UnbordingContent(
      title: 'Raw AI Generated Outputs',
      image: 'images/download.jpg',
      discription:
          "The wallpapers you see are completley raw, and un-edited. They are raw AI output results"),
  UnbordingContent(
      title: 'Handpicked Brilliant Wallpapers',
      image: 'images/nature1.jpg',
      discription:
          "Wallpapers are handpicked by us, you get the best AI generated results."),
  UnbordingContent(
      title: 'Free to download and use',
      image: 'images/screen.jpg',
      discription: "All the wallpapers in this app are free download!"),
];
