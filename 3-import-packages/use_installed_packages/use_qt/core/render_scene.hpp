#ifndef RENDERSCENE_HPP
#define RENDERSCENE_HPP

#include "core/render_line.hpp"

#include <QGraphicsPixmapItem>
#include <QGraphicsScene>
#include <QGraphicsSceneMouseEvent>
#include <QKeyEvent>

class RenderScene : public QGraphicsScene {
  Q_OBJECT

 public:
  explicit RenderScene(QObject *parent = 0);
  RenderScene(const QRectF &sceneRect, QObject *parent = 0);
  ~RenderScene();

  void SetImage(const QPixmap &image);

  std::vector<QLineF> GetLines();
  void SetLines(const std::vector<QLineF> &lines);

  bool IsItemSelected(int *index = nullptr);

  void ClearAllItems();
  void ClearPixmapItem();
  void ClearLineItems();

  QGraphicsPixmapItem *pixmap_item_;
  std::vector<RenderLine *> line_items_;

 private:
  void mouseMoveEvent(QGraphicsSceneMouseEvent *event);
  void mousePressEvent(QGraphicsSceneMouseEvent *event);
  void mouseReleaseEvent(QGraphicsSceneMouseEvent *event);

  void keyPressEvent(QKeyEvent *event);

  QPointF press_pos_, release_pos_;
  bool is_drawing_;
  int current_index_;
};

#endif  // RENDERSCENE_HPP
