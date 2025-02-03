import 'package:flutter/material.dart';
import 'package:tourista/screens/Wilaya_list_page.dart';


import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InformationPagess extends StatefulWidget {
  final PlaceInfo placeInfo;

  const InformationPagess({Key? key, required this.placeInfo}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPagess> {
  late WebViewController _webViewController;
  bool _isWebViewInitialized = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    initWebViewController();
  }

  Future<void> initWebViewController() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.placeInfo.mapUrl));
    setState(() {
      _isWebViewInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Information page',
          style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopImageSection(),
            _buildTitleSection(),
            _buildDescriptionSection(),
            _buildLocationSection(),
            _buildRatingSection(),
            CommentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImageSection() {
    return Stack(
      children: [
        widget.placeInfo.imageUrl.startsWith('http')
            ? Image.network(
                widget.placeInfo.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              )
            : Image.asset(
                widget.placeInfo.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.placeInfo.name,
                style: TextStyle(
                  color: Color(0xFF6D071A),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Color(0xFF6D071A),
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          _buildLocationAndRatingRow(),
          _buildStatusRow(),
        ],
      ),
    );
  }

  Widget _buildLocationAndRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFFD79384)),
            SizedBox(width: 5),
            Text(
              widget.placeInfo.location,
              style: TextStyle(
                color: Color(0xFF6D071A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.star, color: Colors.yellow, size: 20),
            Text(
              ' ${widget.placeInfo.rating}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Icon(Icons.hourglass_empty, color: Color(0xFFD79384)),
        SizedBox(width: 5),
        Text(
          widget.placeInfo.status,
          style: TextStyle(
            color: Color(0xFF6D071A),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(icon: Icons.article, title: 'Description'),
          Divider(
            color: Color(0xFF6D071A),
            thickness: 1.75,
          ),
          Text(
            widget.placeInfo.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          SizedBox(height: 16),
          SectionTitle(icon: Icons.history, title: 'Historical Background'),
          Divider(
            color: Color(0xFF6D071A),
            thickness: 1.75,
          ),
          Text(
            widget.placeInfo.historicalBackground,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(icon: Icons.location_on, title: 'Location'),
          Divider(
            color: Color(0xFF6D071A),
            thickness: 1.75,
          ),
          SizedBox(height: 10),
          if (_isWebViewInitialized)
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: WebViewWidget(
                  controller: _webViewController,
                ),
              ),
            )
          else
            Center(
              child: CircularProgressIndicator(),
            ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WilayaListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D071A),
                side: BorderSide(
                  color: Color(0xFF6D071A),
                  width: 1.75,
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                'Find Guide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(icon: Icons.star, title: 'Rating'),
          Divider(
            color: Color(0xFF6D071A),
            thickness: 1.75,
          ),
          SizedBox(height: 10),
          Center(
            child: RatingBar.builder(
              initialRating: widget.placeInfo.rating,
              minRating: 0.5,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Color(0xFFD79384),
              ),
              onRatingUpdate: (rating) {
              
                print('Rating is $rating');
              },
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
             
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                          color: Color(0xFF6D071A),
                          width: 2,
                        ),
                      ),
                      title: Text(
                        'Rating Submitted',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D071A),
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Thank you for your feedback!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK' , style: TextStyle( color: Color(0xFF6D071A)) ,),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D071A),
                side: BorderSide(
                  color: Color(0xFF6D071A),
                  width: 1.75,
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PlaceInfo {
  final int? id;
  final String name;
  final String imageUrl;
  final String location;
  final double rating;
  final String status;
  final String description;
  final String historicalBackground;
  final String mapUrl;
  final String category;
  final String categoryIcon;
  bool isFavorite;

  PlaceInfo({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.status,
    required this.description,
    required this.historicalBackground,
    required this.mapUrl,
    required this.category,
    required this.categoryIcon,
    this.isFavorite = false,
  });

  factory PlaceInfo.fromMap(Map<String, dynamic> map) {
    return PlaceInfo(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      location: map['location'],
      rating: map['rating'],
      status: map['status'],
      description: map['description'],
      historicalBackground: map['historicalBackground'],
      mapUrl: map['mapUrl'],
      category: map['category'],
      categoryIcon: map['categoryIcon'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'location': location,
      'rating': rating,
      'status': status,
      'description': description,
      'historicalBackground': historicalBackground,
      'mapUrl': mapUrl,
      'category': category,
      'categoryIcon': categoryIcon,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}


class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD79384)),
        SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D071A),
          ),
        ),
      ],
    );
  }
}


class CommentsSection extends StatefulWidget {
  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  List<CommentTile> comments = [];

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.add(CommentTile(
          name: 'User',
          comment: _commentController.text,
          rating: 4.0,
        ));
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(icon: Icons.comment, title: 'Comments'),
          Divider(
            color: Color(0xFF6D071A),
            thickness: 1.75,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.brown),
                onPressed: _addComment,
              ),
            ],
          ),
          SizedBox(height: 20),
          ...comments,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}


class CommentTile extends StatelessWidget {
  final String name;
  final String comment;
  final double rating;

  const CommentTile({
    required this.name,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.brown,
                child: Text(
                  name[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          RatingBarIndicator(
            rating: rating,
            itemBuilder: (context, index) => Icon(Icons.star, color: Color(0xFFD79384)),
            itemCount: 5,
            itemSize: 20.0,
          ),
          SizedBox(height: 5),
          Text(
            comment,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

