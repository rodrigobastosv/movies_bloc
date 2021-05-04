int getCount(double width) {
  if (width > 700) {
    return 4;
  } else if (width > 500) {
    return 2;
  }
  return 1;
}
