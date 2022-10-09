import 'package:flutter/material.dart';

const users = [
  userGordon,
  userSalvatore,
  userSacha,
  userDeven,
  userSahil,
  userReuben,
  userNash,
];

const userGordon = DemoUser(
  id: 'gordon',
  name: 'Gordon Hayes',
  image:
      'https://www.themoviedb.org/t/p/original/whNwkEQYWLFJA8ij0WyOOAD5xhQ.jpg',
);

const userSalvatore = DemoUser(
  id: 'salvatore',
  name: 'Salvatore Giordano',
  image:
      'https://www.themoviedb.org/t/p/original/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg',
);

const userSacha = DemoUser(
  id: 'sacha',
  name: 'Sacha Arbonel',
  image:
      'https://www.themoviedb.org/t/p/original/bBRlrpJm9XkNSg0YT5LCaxqoFMX.jpg',
);

const userDeven = DemoUser(
  id: 'deven',
  name: 'Deven Joshi',
  image:
      'https://www.themoviedb.org/t/p/original/yVGF9FvDxTDPhGimTbZNfghpllA.jpg',
);

const userSahil = DemoUser(
  id: 'sahil',
  name: 'Sahil Kumar',
  image:
      'https://www.themoviedb.org/t/p/original/7rwSXluNWZAluYMOEWBxkPmckES.jpg',
);

const userReuben = DemoUser(
  id: 'reuben',
  name: 'Reuben Turner',
  image:
      'https://www.themoviedb.org/t/p/original/whNwkEQYWLFJA8ij0WyOOAD5xhQ.jpg',
);

const userNash = DemoUser(
  id: 'nash',
  name: 'Nash Ramdial',
  image:
      'https://www.themoviedb.org/t/p/original/whNwkEQYWLFJA8ij0WyOOAD5xhQ.jpg',
);

@immutable
class DemoUser {
  final String id;
  final String name;
  final String image;

  const DemoUser({
    required this.id,
    required this.name,
    required this.image,
  });
}
