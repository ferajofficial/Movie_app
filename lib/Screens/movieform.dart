import 'package:movie/utils/import.dart';
// For converting between object and JSON representation

class Movie {
  String movieName;
  String director;
  String poster;

  Movie(
      {required this.movieName, required this.director, required this.poster});

  // Convert movie object to a map
  Map<String, dynamic> toMap() {
    return {
      'movieName': movieName,
      'director': director,
      'poster': poster,
    };
  }

  // Create a movie object from a map
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      movieName: map['movieName'],
      director: map['director'],
      poster: map['poster'],
    );
  }

  // Convert movie object to a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create a movie object from a JSON string
  factory Movie.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return Movie.fromMap(map);
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  MovieListScreenState createState() => MovieListScreenState();
}

class MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [];
  TextEditingController movieNameController = TextEditingController();
  TextEditingController directorController = TextEditingController();
  TextEditingController posterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String>? movieStrings = sp.getStringList('movies');
    if (movieStrings != null) {
      setState(() {
        movies = movieStrings
            .map((movieString) => Movie.fromJson(movieString))
            .toList();
      });
    }
  }

  Future<void> _saveMovies() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> movieStrings =
        movies.map((movies) => movies.toJson()).toList();
    await sp.setStringList('movies', movieStrings);
  }

  void _addMovie() {
    String movieName = movieNameController.text;
    String director = directorController.text;
    String poster = posterController.text;
    if (movieName.isNotEmpty && director.isNotEmpty && poster.isNotEmpty) {
      setState(() {
        movies.add(
            Movie(movieName: movieName, director: director, poster: poster));
        _saveMovies();
      });
    }
  }

  void _showAddMovieDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: scBg,
            title: Text(
              'Add Movie',
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
            ),
            content: SizedBox(
              height: getDeviceHeight(200),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      movieNameController.text = value;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Name of the Movie'),
                  ),
                  TextField(
                    onChanged: (value) {
                      directorController.text = value;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Director Name'),
                  ),
                  TextField(
                    onChanged: (value) {
                      posterController.text = value;
                    },
                    decoration: const InputDecoration(labelText: 'Poster URL'),
                  ),
                ],
              ),
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
                  _addMovie();
                  SharedPreferences sp = await SharedPreferences.getInstance();

                  sp.setString('movie_title', movieNameController.text);
                  sp.setString('director_name', directorController.text);
                  sp.setString('poster_url', posterController.text);

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _deleteMovie(int index) {
    setState(() {
      movies.removeAt(index);
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
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
            child: ListTile(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                tileColor: tileBg,
                title: Text(
                  movies[index].movieName,
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18)),
                ),
                subtitle: Text(movies[index].director,
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15))),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    movies[index].poster,
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
      ),
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
