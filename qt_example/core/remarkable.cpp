#include "core/remarkable.hpp"
#include "ui_remarkable.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMessageBox>
#include <QTextStream>

#include <iostream>

Remarkable::Remarkable(QWidget *parent)
    : QMainWindow(parent),
      ui_(new Ui::Remarkable),
      scene_(new RenderScene),
      path_label_(new QLabel) {
  ui_->setupUi(this);

  ui_->Open_File->setIcon(QIcon(":/toolbar/resource/blue-fileopen.svg"));
  ui_->Open_Dir->setIcon(QIcon(":/toolbar/resource/blue-folder-open.svg"));
  ui_->Save->setIcon(QIcon(":/toolbar/resource/document-save.svg"));
  ui_->Save_As->setIcon(QIcon(":/toolbar/resource/document-save-as.svg"));
  ui_->Previous->setIcon(QIcon(":/toolbar/resource/go-previous.svg"));
  ui_->Next->setIcon(QIcon(":/toolbar/resource/go-next.svg"));

  this->setWindowIcon(QIcon(":/windows/resource/remarkable.svg"));

  ui_->graphics_View->setScene(scene_);

  ui_->status_Bar->addWidget(path_label_);

  last_open_file_ =
      "/home/jun/Workspace/datasets/adas/arc_lane/transform_mark/lines";
  last_open_dir_ = "/home/jun/Workspace/clion/shadow/data";
  last_save_file_ = "";

  is_open_file_ = false;
  is_open_dir_ = false;
  is_revised_ = false;
  is_saved_ = false;

  current_index_ = -1;
}

Remarkable::~Remarkable() {
  delete ui_;
  delete scene_;
  delete path_label_;
}

void Remarkable::on_Open_File_triggered() {
  if (IsHaveMarks() && !is_saved_) {
    QMessageBox::information(this, tr("Save works..."),
                             "Save current works before load label file!");
    return;
  }

  is_open_file_ = false;
  is_open_dir_ = false;
  is_saved_ = false;

  last_open_file_ =
      QFileDialog::getOpenFileName(this, tr("Open Label File..."),
                                   last_open_file_, tr("Label Marks (*.json)"));
  if (last_open_file_.isEmpty()) {
    return;
  } else {
    QFile file(last_open_file_);
    if (!file.open(QFile::ReadOnly | QFile::Text)) {
      QMessageBox::information(this, tr("Unable to open file"),
                               file.errorString());
      return;
    }
    ClearScene();
    is_open_file_ = LoadFromFile(file);
    file.close();
    if (is_open_file_) {
      current_index_ = marks_.size() > 0 ? 0 : -1;
      ShowScene(current_index_);
    }
  }
}

void Remarkable::on_Open_Dir_triggered() {
  if (IsHaveMarks() && !is_saved_) {
    QMessageBox::information(this, tr("Save works..."),
                             "Save current works before labeling!");
    return;
  }

  is_open_file_ = false;
  is_open_dir_ = false;
  is_saved_ = false;

  last_open_dir_ = QFileDialog::getExistingDirectory(
      this, tr("Open Directory..."), last_open_dir_,
      QFileDialog::Option::ReadOnly);
  if (last_open_dir_.isEmpty()) {
    return;
  } else {
    QStringList filters;
    filters << "*.jpg"
            << "*.png";
    QDir dir(last_open_dir_);
    dir.setNameFilters(filters);
    QFileInfoList file_infos = dir.entryInfoList(QDir::Files, QDir::DirsFirst);
    ClearScene();
    foreach (QFileInfo info, file_infos) {
      file_paths_.push_back(info.absoluteFilePath());
    }
    is_open_dir_ = true;
    current_index_ = file_paths_.size() > 0 ? 0 : -1;
    ShowScene(current_index_);
  }
}

void Remarkable::on_Save_triggered() {
  if (is_open_file_) {
    SaveMarks(current_index_);
    QFile file(last_open_file_);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
      QMessageBox::information(this, tr("Unable to write file"),
                               file.errorString());
      return;
    }
    is_saved_ = SaveToFile(file);
    file.close();
  } else if (is_open_dir_) {
    on_Save_As_triggered();
  }
}

void Remarkable::on_Save_As_triggered() {
  SaveMarks(current_index_);
  last_save_file_ = QFileDialog::getSaveFileName(
      this, tr("Save Results..."), last_save_file_, tr("Label Marks (*.json)"));
  if (last_save_file_.isEmpty()) {
    return;
  } else {
    QFile file(last_save_file_);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
      QMessageBox::information(this, tr("Unable to write file"),
                               file.errorString());
      return;
    }
    is_saved_ = SaveToFile(file);
    file.close();
  }
}

void Remarkable::on_Previous_triggered() {
  if (current_index_ > 0) {
    SaveMarks(current_index_--);
    ShowScene(current_index_);
  }
}

void Remarkable::on_Next_triggered() {
  if (current_index_ < file_paths_.size() - 1) {
    SaveMarks(current_index_++);
    ShowScene(current_index_);
  }
}

void Remarkable::keyPressEvent(QKeyEvent *event) {
  if (event->key() == Qt::Key::Key_A && !scene_->IsItemSelected()) {
    on_Previous_triggered();
  } else if (event->key() == Qt::Key::Key_D && !scene_->IsItemSelected()) {
    on_Next_triggered();
  }
  QMainWindow::keyPressEvent(event);
}

bool Remarkable::IsHaveMarks() {
  for (auto mark = marks_.begin(); mark != marks_.end(); ++mark) {
    if (mark.value().size() > 0) {
      return true;
      break;
    }
  }
  return false;
}

void Remarkable::SaveMarks(int current_index) {
  if (current_index >= 0 && current_index < file_paths_.size()) {
    marks_.insert(file_paths_[current_index], scene_->GetLines());
  }
}

bool Remarkable::ShowScene(int current_index) {
  if (current_index >= 0 && current_index < file_paths_.size()) {
    QString file_path = file_paths_[current_index];
    if (QFile::exists(file_path)) {
      path_label_->setText(file_path);
      scene_->SetImage(QPixmap(file_path));
      scene_->SetLines(marks_.value(file_path));
      scene_->update();
    } else {
      QMessageBox::information(this, tr("Unable to find file"),
                               "File: " + file_path + " doesn't exist!");
      return false;
    }
    return true;
  }
  return false;
}

void Remarkable::ClearScene() {
  marks_.clear();
  file_paths_.clear();
  scene_->ClearAllItems();
}

bool Remarkable::LoadFromFile(QFile &file) {
  QTextStream in(&file);

  QString json_str = in.readAll();
  QJsonParseError error;
  QJsonDocument document = QJsonDocument::fromJson(json_str.toUtf8(), &error);
  if (error.error == QJsonParseError::NoError) {
    if (!(document.isNull() || document.isEmpty())) {
      if (document.isArray()) {
        foreach (QJsonValue mark, document.array()) {
          QJsonObject object = mark.toObject();
          std::vector<QLineF> line_vec;
          foreach (QJsonValue line, object["lines"].toArray()) {
            QJsonArray line_arr = line.toArray();
            if (line_arr.size() == 4) {
              line_vec.push_back(
                  QLineF(line_arr[0].toInt(), line_arr[1].toInt(),
                         line_arr[2].toInt(), line_arr[3].toInt()));
            } else {
              continue;
            }
          }
          QString path = object["path"].toString();
          if (QFile::exists(path)) {
            file_paths_.push_back(path);
            marks_.insert(path, line_vec);
          }
        }
      }
    }
  } else {
    QMessageBox::information(this, tr("Unable to load json file"),
                             error.errorString());
    return false;
  }
  return true;
}

bool Remarkable::SaveToFile(QFile &file) {
  QTextStream out(&file);

  QJsonArray images_arr;
  for (auto mark = marks_.begin(); mark != marks_.end(); ++mark) {
    QString key = mark.key();
    std::vector<QLineF> lines = mark.value();
    if (lines.size() == 0) {
      continue;
    } else {
      QJsonObject lines_obj;
      QJsonArray lines_arr;
      for (size_t i = 0; i < lines.size(); ++i) {
        QLineF line = lines[i];
        QJsonArray line_arr;
        line_arr.insert(0, line.x1());
        line_arr.insert(1, line.y1());
        line_arr.insert(2, line.x2());
        line_arr.insert(3, line.y2());
        lines_arr.insert(i, line_arr);
      }
      lines_obj.insert("lines", lines_arr);
      lines_obj.insert("path", key);
      images_arr.push_back(lines_obj);
    }
  }

  QJsonDocument document;
  document.setArray(images_arr);
  QByteArray byte_array = document.toJson(QJsonDocument::Indented);
  QString json_str(byte_array);

  out << json_str;

  return true;
}
