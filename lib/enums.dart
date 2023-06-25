// ignore_for_file: constant_identifier_names, camel_case_types

enum TODO_STATUS { NOT_STARTED, IN_PROGRESS, COMPLETED }

String getEnumNameString(TODO_STATUS statusValue) {
  var status = '';
  switch (statusValue) {
    case (TODO_STATUS.COMPLETED):
      status = 'Completed';
      break;
    case (TODO_STATUS.NOT_STARTED):
      status = 'Not Started';
      break;
    case (TODO_STATUS.IN_PROGRESS):
      status = 'In Progress';
      break;
    default:
      status = '';
      break;
  }
  return status;
}

TODO_STATUS getEnumValueFromString(String value) {
  TODO_STATUS status;
  switch (value) {
    case ('Completed'):
      status = TODO_STATUS.COMPLETED;
      break;
    case ('Not Started'):
      status = TODO_STATUS.NOT_STARTED;
      break;
    case ('In Progress'):
      status = TODO_STATUS.IN_PROGRESS;
      break;
    default:
      status = TODO_STATUS.NOT_STARTED;
      break;
  }
  return status;
}
