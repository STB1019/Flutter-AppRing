
class DeviceHardware{
  String _id;
  String label;
  String description;
  bool avaiable;

  DeviceHardware._internal(this._id,this.label,this.description,this.avaiable);

  factory DeviceHardware(){
      return DeviceHardware._internal(null,"Interruttore 1","Gestore scale Est",true);
  }

  Future<bool> saveIntoDB(){
    if(this._id == null);
      //TODO something
      
  }
}