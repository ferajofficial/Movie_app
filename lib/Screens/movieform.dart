import 'package:movie/utils/import.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Movie {
  String title;
  String director;
  String poster;

  Movie({required this.title, required this.director, required this.poster});
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  MovieListScreenState createState() => MovieListScreenState();
}

class MovieListScreenState extends State<MovieListScreen> {
  // isLogin() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   sp.getString('movie_title').toString();
  //   sp.getString('director_name').toString();
  //   sp.getString('poster_url').toString();
  //   setState(() {});
  // }

  TextEditingController movieController = TextEditingController();
  TextEditingController directorController = TextEditingController();
  TextEditingController posterController = TextEditingController();

  final List<Movie> _movies = [];
  bool animate = false;
  void _showAddMovieDialog() async {
    // String title = '';
    // String director = '';
    // String poster = '';

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: scBg,

            //clipBehavior: Clip.hardEdge,
            title: Text(
              'Add Movie',
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
            ),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    movieController.text = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Name of the Movie'),
                ),
                TextField(
                  onChanged: (value) {
                    directorController.text = value;
                  },
                  decoration: const InputDecoration(labelText: 'Director Name'),
                ),
                TextField(
                  onChanged: (value) {
                    posterController.text = value;
                  },
                  decoration: const InputDecoration(labelText: 'Poster URL'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kprimarylightColor),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18)),
                ),
                onPressed: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();

                  sp.setString('movie_title', movieController.text);
                  sp.setString('director_name', directorController.text);
                  sp.setString('poster_url', posterController.text);
                  // print("object");

                  setState(() {
                    _movies.add(Movie(
                        title: movieController.text,
                        director: directorController.text,
                        poster: posterController.text));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _deleteMovie(int index) {
    setState(() {
      _movies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: scBg,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Watched Movies",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: kSecondaryColor)),
        ),
      ),
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
            return ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 5),
                  child: ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      tileColor: tileBg,
                      title: Text(
                        snapshot.data!.getString('movie_title').toString(),
                        //_movies[index].title,
                        //isLogin(),
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)),
                      ),
                      subtitle: Text(
                          snapshot.data!.getString('director_name').toString(),
                          //_movies[index].director,
                          // isLogin(),
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15))),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          snapshot.data!.getString('poster_url').toString(),
                          //_movies[index].poster,
                          //isLogin(),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: kSecondaryColor,
                          size: 25,
                        ),
                        onPressed: () {
                          _deleteMovie(index);
                        },
                      )),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kprimarylightColor,
        // shape: ShapeBorder.,
        onPressed: () {
          _showAddMovieDialog();
        },
        child: const Icon(
          Icons.add,
          color: floatBG,
          size: 30,
        ),
      ),
    );
  }
}
