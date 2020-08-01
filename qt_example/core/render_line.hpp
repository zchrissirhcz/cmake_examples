#ifndef RENDER_LINE_HPP
#define RENDER_LINE_HPP

#include <QGraphicsItem>
#include <QGraphicsLineItem>
#include <QGraphicsSceneMouseEvent>

class RenderLine : public QGraphicsLineItem {
 public:
  explicit RenderLine(QGraphicsItem *parent = 0);
  ~RenderLine();

  enum { Type = UserType + 1 };
  int type() const Q_DECL_OVERRIDE { return Type; }
  void paint(QPainter *painter, const QStyleOptionGraphicsItem *option,
             QWidget *widget) Q_DECL_OVERRIDE;

  bool is_selected_;

 private:
  void mouseMoveEvent(QGraphicsSceneMouseEvent *event) Q_DECL_OVERRIDE;
  void mousePressEvent(QGraphicsSceneMouseEvent *event) Q_DECL_OVERRIDE;
  void mouseReleaseEvent(QGraphicsSceneMouseEvent *event) Q_DECL_OVERRIDE;
};

#endif  // RENDER_LINE_HPP
