#ifndef REMARKABLE_HPP
#define REMARKABLE_HPP

#include "core/render_scene.hpp"

#include <QDir>
#include <QFileDialog>
#include <QKeyEvent>
#include <QLabel>
#include <QMainWindow>
#include <QMap>

namespace Ui {
class Remarkable;
}

class Remarkable : public QMainWindow {
  Q_OBJECT

 public:
  explicit Remarkable(QWidget *parent = 0);
  ~Remarkable();

 private slots:
  void on_Open_File_triggered();
  void on_Open_Dir_triggered();

  void on_Save_triggered();
  void on_Save_As_triggered();

  void on_Previous_triggered();
  void on_Next_triggered();

 private:
  void keyPressEvent(QKeyEvent *event);

  bool IsHaveMarks();
  void SaveMarks(int current_index = -1);

  bool ShowScene(int current_index = -1);
  void ClearScene();

  bool LoadFromFile(QFile &file);
  bool SaveToFile(QFile &file);

  Ui::Remarkable *ui_;

  RenderScene *scene_;

  QLabel *path_label_;

  QString last_open_file_, last_open_dir_, last_save_file_;

  bool is_open_file_, is_open_dir_, is_revised_, is_saved_;

  std::vector<QString> file_paths_;
  int current_index_;

  QMap<QString, std::vector<QLineF>> marks_;
};

#endif  // REMARKABLE_HPP
