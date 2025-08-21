class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });
}

final List<Restaurant> restaurantList = [
  Restaurant(
    id: 'r01',
    name: 'Warung Sate Pak Joko',
    description: 'Sate lezat dengan bumbu kacang khas Jawa Tengah.',
    pictureId: '01',
    city: 'Yogyakarta',
    rating: 4.5,
  ),
  Restaurant(
    id: 'r02',
    name: 'Bakso Bu Rini',
    description: 'Bakso kenyal dengan kuah gurih dan topping melimpah.',
    pictureId: '02',
    city: 'Surabaya',
    rating: 4.3,
  ),
  Restaurant(
    id: 'r03',
    name: 'Nasi Padang Sederhana',
    description: 'Aneka lauk Padang dengan cita rasa otentik Minang.',
    pictureId: '03',
    city: 'Padang',
    rating: 4.7,
  ),
  Restaurant(
    id: 'r04',
    name: 'Ayam Geprek Mantul',
    description: 'Ayam geprek pedas dengan sambal pilihan.',
    pictureId: '04',
    city: 'Bandung',
    rating: 4.4,
  ),
  Restaurant(
    id: 'r05',
    name: 'Mie Aceh Bang Rizal',
    description: 'Mie Aceh spesial dengan rasa rempah yang kuat.',
    pictureId: '05',
    city: 'Aceh',
    rating: 4.6,
  ),
  Restaurant(
    id: 'r06',
    name: 'Pempek Palembang Asli',
    description: 'Pempek lembut dengan cuko khas Palembang.',
    pictureId: '06',
    city: 'Palembang',
    rating: 4.5,
  ),
  Restaurant(
    id: 'r07',
    name: 'Gudeg Yu Djum',
    description: 'Gudeg manis dengan krecek dan ayam kampung.',
    pictureId: '07',
    city: 'Yogyakarta',
    rating: 4.8,
  ),
  Restaurant(
    id: 'r08',
    name: 'Soto Betawi Haji Mamat',
    description: 'Soto Betawi dengan daging sapi empuk dan kuah santan.',
    pictureId: '08',
    city: 'Jakarta',
    rating: 2,
  ),
  Restaurant(
    id: 'r09',
    name: 'Rendang Minang Raya',
    description: 'Rendang daging sapi dengan bumbu kaya rempah.',
    pictureId: '09',
    city: 'Bukittinggi',
    rating: 4.9,
  ),
  Restaurant(
    id: 'r10',
    name: 'Lontong Medan Mak Ucok',
    description: 'Lontong Medan dengan sayur dan sambal khas.',
    pictureId: '10',
    city: 'Medan',
    rating: 3.2,
  ),
];
