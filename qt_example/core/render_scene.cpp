#include "core/render_scene.hpp"

#include <iostream>

const int MinusGap = 20;

RenderScene::RenderScene(QObject *parent) : QGraphicsScene(parent) {
  pixmap_item_ = nullptr;
}

RenderScene::RenderScene(const QRectF &sceneRect, QObject *parent)
    : QGraphicsScene(sceneRect, parent) {
  pixmap_item_ = nullptr;
}

RenderScene::~RenderScene() { ClearAllItems(); }

void RenderScene::SetImage(const QPixmap &image) {
  if (pixmap_item_ == nullptr) {
    pixmap_item_ = new QGraphicsPixmapItem();
    addItem(pixmap_item_);
  }
  pixmap_item_->setPixmap(image);
}

std::vector<QLineF> RenderScene::GetLines() {
  std::vector<QLineF> lines;
  for (size_t i = 0; i < line_items_.size(); ++i) {
    QLineF line = line_items_[i]->line();
    QPointF pos = line_items_[i]->pos();
    lines.push_back(QLineF(line.x1() + pos.x(), line.y1() + pos.y(),
                           line.x2() + pos.x(), line.y2() + pos.y()));
  }

  return lines;
}

void RenderScene::SetLines(const std::vector<QLineF> &lines) {
  ClearLineItems();
  for (size_t i = 0; i < lines.size(); ++i) {
    RenderLine *line_item = new RenderLine();
    line_item->setLine(lines[i]);
    line_items_.push_back(line_item);
    addItem(line_item);
  }
}

bool RenderScene::IsItemSelected(int *index) {
  for (size_t i = 0; i < line_items_.size(); ++i) {
    if (line_items_[i]->isSelected()) {
      if (index != nullptr) {
        *index = i;
      }
      return true;
    }
  }
  if (index != nullptr) {
    *index = -1;
  }
  return false;
}

void RenderScene::ClearAllItems() {
  ClearPixmapItem();
  ClearLineItems();
}

void RenderScene::ClearPixmapItem() {
  if (pixmap_item_ != nullptr) {
    removeItem(pixmap_item_);
    delete pixmap_item_;
    pixmap_item_ = nullptr;
  }
}

void RenderScene::ClearLineItems() {
  for (size_t i = 0; i < line_items_.size(); ++i) {
    removeItem(line_items_[i]);
    delete line_items_[i];
  }
  line_items_.clear();
}

void RenderScene::mouseMoveEvent(QGraphicsSceneMouseEvent *event) {
  if (is_drawing_) {
    QPointF current_pos = event->scenePos();
    line_items_[current_index_]->setLine(press_pos_.x(), press_pos_.y(),
                                         current_pos.x(), current_pos.y());
    update();
  }
  QGraphicsScene::mouseMoveEvent(event);
}

void RenderScene::mousePressEvent(QGraphicsSceneMouseEvent *event) {
  QGraphicsScene::mousePressEvent(event);

  if (event->button() == Qt::LeftButton && !IsItemSelected()) {
    is_drawing_ = true;
    press_pos_ = event->scenePos();
    RenderLine *line_item = new RenderLine();
    current_index_ = line_items_.size();
    line_items_.push_back(line_item);
    addItem(line_item);
    update();
  }
}

void RenderScene::mouseReleaseEvent(QGraphicsSceneMouseEvent *event) {
  if (is_drawing_ && event->button() == Qt::LeftButton) {
    is_drawing_ = false;
    release_pos_ = event->scenePos();
    if (std::abs(release_pos_.x() - press_pos_.x()) > MinusGap ||
        std::abs(release_pos_.y() - press_pos_.y()) > MinusGap) {
      //      std::cout << "x: " << press_pos_.x() << ", y: " << press_pos_.y()
      //      << "; ";
      //      std::cout << "x: " << release_pos_.x() << ", y: " <<
      //      release_pos_.y()
      //                << std::endl;
    } else {
      removeItem(line_items_[current_index_]);
      delete line_items_[current_index_];
      line_items_.erase(line_items_.begin() + current_index_);
    }
    update();
  }
  QGraphicsScene::mouseReleaseEvent(event);
}

void RenderScene::keyPressEvent(QKeyEvent *event) {
  int index;
  bool is_item_selected = IsItemSelected(&index);
  if (event->key() == Qt::Key::Key_Delete) {
    if (is_item_selected) {
      removeItem(line_items_[index]);
      delete line_items_[index];
      line_items_.erase(line_items_.begin() + index);
      update();
    }
  } else if (event->key() == Qt::Key::Key_A) {
    if (is_item_selected) {
      line_items_[index]->moveBy(-10, 0);
      update();
    }
  } else if (event->key() == Qt::Key::Key_D) {
    if (is_item_selected) {
      line_items_[index]->moveBy(10, 0);
      update();
    }
  } else if (event->key() == Qt::Key::Key_W) {
    if (is_item_selected) {
      line_items_[index]->moveBy(0, -10);
      update();
    }
  } else if (event->key() == Qt::Key::Key_S) {
    if (is_item_selected) {
      line_items_[index]->moveBy(0, 10);
      update();
    }
  }
  QGraphicsScene::keyPressEvent(event);
}
