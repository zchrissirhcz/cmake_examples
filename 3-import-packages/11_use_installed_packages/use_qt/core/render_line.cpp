#include "core/render_line.hpp"

#include <QPainter>

#include <iostream>

RenderLine::RenderLine(QGraphicsItem *parent)
    : QGraphicsLineItem(parent), is_selected_(false) {
  setAcceptedMouseButtons(Qt::LeftButton | Qt::RightButton);
  setFlags(QGraphicsItem::ItemIsMovable | QGraphicsItem::ItemIsSelectable);
}

RenderLine::~RenderLine() {}

void RenderLine::paint(QPainter *painter, const QStyleOptionGraphicsItem *,
                       QWidget *) {
  QPen pen(Qt::green);
  pen.setWidth(3);

  if (isSelected()) {
    pen.setColor(Qt::red);
  }

  painter->setPen(pen);
  painter->drawLine(line());
}

void RenderLine::mouseMoveEvent(QGraphicsSceneMouseEvent *event) {
  if (is_selected_) {
    update();
  }
  QGraphicsLineItem::mouseMoveEvent(event);
}

void RenderLine::mousePressEvent(QGraphicsSceneMouseEvent *event) {
  is_selected_ = true;
  update();
  QGraphicsLineItem::mousePressEvent(event);
}

void RenderLine::mouseReleaseEvent(QGraphicsSceneMouseEvent *event) {
  is_selected_ = false;
  update();
  QGraphicsLineItem::mouseReleaseEvent(event);
}
