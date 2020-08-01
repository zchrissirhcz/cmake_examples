#include <QApplication>

#include "core/remarkable.hpp"

int main(int argc, char *argv[]) {
  QApplication a(argc, argv);
  Remarkable w;

  w.show();

  return a.exec();
}
