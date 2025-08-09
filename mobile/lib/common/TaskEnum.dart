enum TaskEnum {
  PENDING('Pendiente'),
  DONE('Hecho');

  final String label;
  const TaskEnum(this.label);

  static TaskEnum fromString(String value){
      if(value == 'PENDING') return TaskEnum.PENDING;
      return TaskEnum.DONE;
  }
}