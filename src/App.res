@react.component
let make = () => {
  let (points, setPoints) = React.useState(() => [])
  let ((newPointX, newPointY), setNewPoint) = React.useState(() => (20, 20))

  let box = (t, l, h, w, c, key) => {
    <div
      key
      style={{
        position: "absolute",
        top: t->Belt.Int.toString ++ "px",
        left: l->Belt.Int.toString ++ "px",
        backgroundColor: c,
        height: h->Belt.Int.toString ++ "px",
        width: w->Belt.Int.toString ++ "px",
      }}
    />
  }

  let t = 10 // thickness
  let red = "#f87171"
  let blue = "#3730a3"
  let yellow = "#f59e0b"

  <div className="overflow-scroll ">
    <div
      className="w-[500px] h-[500px] m-5 border-4 border-black"
      onMouseMove={e => {
        setNewPoint(((vX, vY)) => {
          let posX = e->JsxEvent.Mouse.clientX
          let posY = e->JsxEvent.Mouse.clientY
          points->Array.length == 0
            ? (posX, posY)
            : mod(points->Array.length, 2) == 0
            ? (vX, posY)
            : (posX, vY)
        })
      }}
      onMouseUp={e => {
        let posX = e->JsxEvent.Mouse.clientX
        let posY = e->JsxEvent.Mouse.clientY

        setPoints(p => {
          let len = p->Array.length
          len == 0
            ? [(posX, posY)]
            : {
                let (lastX, lastY) = p->Array.getUnsafe(len - 1)
                let new = mod(len, 2) == 0 ? [(lastX, posY)] : [(posX, lastY)]
                p->Array.concat(new)
              }
        })
        setNewPoint(_ => (posX, posY))
      }}>
      {points
      ->Array.reduceWithIndex([], (arr, cur, i) => {
        let (ax, ay) = cur

        arr->Array.concat(
          switch (points->Array.get(i + 1), points->Array.get(i + 2)) {
          | (Some((bx, by)), c) => {
              let w = Math.abs((bx - ax)->Int.toFloat)->Float.toInt
              let h = Math.abs((by - ay)->Int.toFloat)->Float.toInt
              let horz = mod(i, 2) == 0
              let key = s => s ++ i->Int.toString

              let edges = horz
                ? bx > ax
                    ? [
                        box(ay, ax, t, w, red, "edgeA"->key),
                        box(ay - t, ax, t, w, blue, "edgeB"->key),
                      ]
                    : [
                        box(by - t, bx, t, w, red, "edgeA"->key),
                        box(by, bx, t, w, blue, "edgeB"->key),
                      ]
                : by > ay
                ? [box(ay, ax, h, t, blue, "edgeA"->key), box(ay, ax - t, h, t, red, "edgeB"->key)]
                : [box(by, bx - t, h, t, blue, "edgeA"->key), box(by, bx, h, t, red, "edgeB"->key)]

              let corner = switch c {
              | Some((cx, cy)) =>
                switch (cx > ax, cy > ay, horz) {
                | (true, true, true) => [box(by - t, bx, t, t, blue, "corner"->key)]
                | (false, false, false) => [box(by - t, bx, t, t, red, "corner"->key)]
                | (false, true, true) => [box(by - t, bx - t, t, t, red, "corner"->key)]
                | (true, false, false) => [box(by - t, bx - t, t, t, blue, "corner"->key)]
                | (true, false, true) => [box(by, bx, t, t, red, "corner"->key)]
                | (false, true, false) => [box(by, bx, t, t, blue, "corner"->key)]
                | (false, false, true) => [box(by, bx - t, t, t, blue, "corner"->key)]
                | (true, true, false) => [box(by, bx - t, t, t, red, "corner"->key)]
                }

              | None => []
              }
              Array.concat(edges, corner)
            }

          | _ => [React.null]
          },
        )
      })
      ->React.array}
      {switch points->Array.get(points->Array.length - 1) {
      | None => React.null
      | Some((lastX, lastY)) => box(lastY - t, lastX - t, t * 2, t * 2, yellow, "head")
      }}
      {box(newPointY - t, newPointX - t, t * 2, t * 2, yellow, "newPoint")}
    </div>
  </div>
}
