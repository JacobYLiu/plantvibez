class Plant{
  String imageLink;
  String name;
  String species;
  DateTime waterTime;
  DateTime lightTime;

  Plant(String name, String species){
    this.name = name;
    this.species = species;
  }

  DateTime get wTime => waterTime;
  DateTime get lTime => lightTime;
  set wTime(DateTime waterTime) => waterTime = waterTime;
  set lTime(DateTime lightTime) => lightTime = lightTime;

}