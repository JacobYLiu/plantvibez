class DefaultPlant{
  String imageLink;
  String name;

  DateTime waterTime;
  DateTime lightTime;

  DefaultPlant(String imageLink, String name){
    this.imageLink = imageLink;
    this.name = name;
  }

  DateTime get wTime => waterTime;
  DateTime get lTime => lightTime;
  set wTime(DateTime waterTime) => waterTime = waterTime;
  set lTime(DateTime lightTime) => lightTime = lightTime;

}